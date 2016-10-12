//
//  StickPicsCollectionViewController.swift
//  StickPics
//
//  Created by Dylan Wight on 8/20/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit
import Messages

protocol StickPicsCollectionViewDelegate: class {
    func stickPicsViewControllerDidSelectAdd(_ controller: StickPicsCollectionViewController)
}

class StickPicsCollectionViewController: UICollectionViewController {
    
    enum CollectionViewItem {
        case stickPic(URL)
        case create
    }
    
    // MARK: Properties
    
    static let storyboardIdentifier = "StickPicsCollectionViewController"
    
    weak var delegate: StickPicsCollectionViewDelegate?
    
    private let items: [CollectionViewItem]
    
    required init?(coder aDecoder: NSCoder) {
        // Map the previously completed ice creams to an array of `CollectionViewItem`s.
        let reversedHistory = StickPicHistory.load().stickPicURLs.reversed()
        var items: [CollectionViewItem] = reversedHistory.map { .stickPic($0) }
        
        // Add `CollectionViewItem` that the user can tap to start building a new ice cream.
        items.insert(.create, at: 0)
        
        self.items = items
        super.init(coder: aDecoder)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.row]
        
        switch item {
        case .create:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateCell.reuseIdentifier, for: indexPath) as! CreateCell
            return cell
        case .stickPic(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickPicCell.reuseIdentifier, for: indexPath) as! StickPicCell
            
            do {
                cell.stickerView.sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "test")
            } catch {
                fatalError("Failed to load sticker image: \(error)")
            }
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        switch item {
        case .create:
            delegate?.stickPicsViewControllerDidSelectAdd(self)
        case .stickPic(_):
            break
        }
    }
}

