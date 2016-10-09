//
//  CreateStickPicController.swift
//  StickPics
//
//  Created by Dylan Wight on 8/20/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import Foundation
import UIKit
import Messages

let savedStickerKey = "savedStickerKey"

protocol CreateStickPicDelegate {
    func save () -> ()
}

class CreateStickPicController: UIViewController {
    
    var delegate: CreateStickPicDelegate?
    
    static let storyboardIdentifier = "CreateStickPicController"
    
    fileprivate var undoStack = [UIImage]()
    
    fileprivate var currentStroke: UIImage?
    
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundTile"))
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var leftUnderFingerView: UIImageView! {
        didSet {
            leftUnderFingerView.layer.cornerRadius = min(leftUnderFingerView.frame.height, leftUnderFingerView.frame.width) / 2.0
            leftUnderFingerView.clipsToBounds = true
            leftUnderFingerView.layer.borderWidth = 2.0
            leftUnderFingerView.layer.borderColor = UIColor.black.cgColor
            leftUnderFingerView.alpha = 0.0
            leftUnderFingerView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundTile"))
        }
    }
    
    var brushSize: CGFloat {
        return (CGFloat(sizeSlider.value) * CGFloat(sizeSlider.value))
    }
    
    var lastPoint: CGPoint?
    
    var actualSize: CGSize {
        return CGSize(width: imageView.frame.width * 2.0, height: imageView.frame.height * 2.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let drag = UILongPressGestureRecognizer(target: self, action: #selector(CreateStickPicController.handleDrag(_:)))
        drag.minimumPressDuration = 0.0
        drag.delegate = self
        imageView.addGestureRecognizer(drag)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let savedSticker = UserDefaults.standard.string(forKey: savedStickerKey) {
            imageView.image = UIImage.fromBase64(savedSticker)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        let saveAlert = UIAlertController(title: "Done?", message: "Adds new sticker to collection", preferredStyle: .alert)
        
        saveAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            if let image = self.imageView.image {
                if let data = UIImagePNGRepresentation(image) {
                    
                    let id = NSUUID().uuidString
                    let url = URL(fileURLWithPath: self.getDocumentsDirectory().appendingPathComponent("\(id).png"))
                    
                    StickPicHistory.load().addStickPicURL(url: url)
                    
                    do {
                        try data.write(to: url)
                        UserDefaults.standard.setValue(nil, forKey: savedStickerKey)
                        self.delegate?.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }))
        saveAlert.addAction(UIAlertAction(title: "Nope", style: .cancel, handler: nil))
        self.present(saveAlert, animated: true, completion: nil)
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        addChildViewController(imagePicker)
        
        imagePicker.view.frame = view.bounds
        imagePicker.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagePicker.view)
        
        imagePicker.view.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        imagePicker.view.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        imagePicker.view.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        imagePicker.view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        
        imagePicker.didMove(toParentViewController: self)
    }
    
    @IBAction func undo(_ sender: UIButton) {
        _ = undoStack.popLast()
        imageView.image = undoStack.last
        UserDefaults.standard.setValue(imageView.image, forKey: savedStickerKey)
    }
    
    @IBOutlet weak var sizeSlider: UISlider! {
        didSet {
            sizeSlider.minimumValue = 2.0
            sizeSlider.maximumValue = 10.0
            sizeSlider.value = 5.5
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }


    func handleDrag(_ sender: UILongPressGestureRecognizer) {
        
        let point = sender.location(in: imageView)
        
        setUnderFingerView(point)
        
        switch sender.state {
        case .began:
            lastPoint = point
        case .changed:
            let currentPoint = sender.location(in: imageView)
            
            UIGraphicsBeginImageContext(imageView.frame.size)
            imageView.image?.draw(at: CGPoint.zero)
            
            let context = UIGraphicsGetCurrentContext()!
            
            context.setLineCap(.round)
            context.setLineWidth(brushSize)
            context.setBlendMode(.clear)
            
            context.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            context.beginPath()
            
            if let lastPoint = lastPoint {
                context.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            }
            context.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))

            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            lastPoint = currentPoint
            
        case .ended:
            hideUnderFingerView()
            addToUndoStack(imageView.image)
        default:
            break
        }
    }
    
    fileprivate func addToUndoStack(_ image: UIImage?) {
        UserDefaults.standard.setValue(imageView.image, forKey: savedStickerKey)
        if let image = image {
            if undoStack.count <= 20 {
                undoStack.append(image)
            } else {
                undoStack.remove(at: 0)
                undoStack.append(image)
            }
        }
    }
}


extension CreateStickPicController {
    
    public func hideUnderFingerView() {
        UIView.animate(withDuration: 0.5,delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.leftUnderFingerView.alpha = 0.0
        }, completion: nil)
    }
    
    public func showUnderFingerView() {
        UIView.animate(withDuration: 0.5,delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.leftUnderFingerView.alpha = 1.0
        }, completion: nil)
    }
    
    public func setUnderFingerView(_ position: CGPoint) {
        
        let underFingerSize: CGSize
        
        let maxUnderFinger: CGFloat = 400.0
        let minUnderFinger: CGFloat = 200.0
        
        let ceilingSize: CGFloat = 80.0
        let baseSize: CGFloat = 10.0
        
        if (brushSize > ceilingSize) {
            underFingerSize = CGSize(width: maxUnderFinger, height: maxUnderFinger)
        } else if (brushSize < baseSize){
            underFingerSize = CGSize(width: minUnderFinger, height: minUnderFinger)
        } else {
            let underFinger = ((brushSize - baseSize) / ceilingSize) * (maxUnderFinger - minUnderFinger) + minUnderFinger
            underFingerSize = CGSize(width: underFinger, height: underFinger)
        }
        
        leftUnderFingerView.frame = CGRect(x: position.x - (leftUnderFingerView.frame.width/2.0), y: position.y - 30.0 - leftUnderFingerView.frame.height, width: leftUnderFingerView.frame.width, height: leftUnderFingerView.frame.height)
        leftUnderFingerView.image = imageView.image?.cropToSquare(position, cropSize: underFingerSize)
        
        showUnderFingerView()
    }
}

extension CreateStickPicController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIGraphicsBeginImageContext(imageView.frame.size)
            pickedImage.draw(in: imageView.frame)
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            addToUndoStack(imageView.image)
        }
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
}

extension CreateStickPicController: UIGestureRecognizerDelegate {}




