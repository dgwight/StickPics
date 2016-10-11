//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Dylan Wight on 8/20/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var subview: UIView!
        
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        presentViewController(style: presentationStyle)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        presentViewController(style: presentationStyle)
    }

    private func presentViewController(style: MSMessagesAppPresentationStyle) {
        if let url = activeConversation?.selectedMessage?.url {
            print(url.absoluteString)
        }
        
        let controller: UIViewController
        
        if style == .compact {
            controller = storyboard?.instantiateViewController(withIdentifier: StickPicsCollectionViewController.storyboardIdentifier) as! StickPicsCollectionViewController
            (controller as! StickPicsCollectionViewController).delegate = self
        } else {
            controller = (storyboard?.instantiateViewController(withIdentifier: TableViewController.storyboardIdentifier))!
//            (controller as! CreateStickPicController).delegate = self
        }
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = subview.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        subview.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: subview.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: subview.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
        controller.didMove(toParentViewController: self)
    }
}

//    // MARK: Convenience
//
//    fileprivate func composeMessage(with url: URL, caption: String, session: MSSession? = nil) -> MSMessage {
//        var components = URLComponents()
//        components.queryItems = iceCream.queryItems
//        
//        let layout = MSMessageTemplateLayout()
//        layout.image = iceCream.renderSticker(opaque: true)
//        layout.caption = caption
//        
//        let message = MSMessage(session: session ?? MSSession())
//        message.url = components.url!
//        message.layout = layout
//        
//        return message
//    }
//}

extension MessagesViewController: CreateStickPicDelegate {
    func save() {
        requestPresentationStyle(.compact)
    }
}

extension MessagesViewController: StickPicsCollectionViewDelegate {
    func stickPicsViewControllerDidSelectAdd(_ controller: StickPicsCollectionViewController) {
        requestPresentationStyle(.expanded)
    }
}





