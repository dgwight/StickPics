//
//  StickPicsCollectionViewController.swift
//  StickPics
//
//  Created by Dylan Wight on 8/20/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//


import UIKit
import Messages

class StickPicsCollectionViewController: UICollectionViewController {
    
    enum Section: Int {
        case create = 0
        case stickPic = 1
    }
    
    // MARK: Properties
    
    static let storyboardIdentifier = "StickPicsCollectionViewController"
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .create:
            return 1
        case .stickPic:
            return StickPicHistory.load().stickPicURLs.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .create:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateCell.reuseIdentifier, for: indexPath) as! CreateCell
            return cell
        case .stickPic:
            let url = StickPicHistory.load().stickPicURLs[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickPicCell.reuseIdentifier, for: indexPath) as! StickPicCell
            
            do {
                cell.stickerView.sticker = try MSSticker(contentsOfFileURL: url, localizedDescription: "test")
            } catch {
                fatalError("Failed to load sticker image: \(error)")
            }
            
            return cell
        }
    }
}

