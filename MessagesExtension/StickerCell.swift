//
//  StickerCell.swift
//  StickPics
//
//  Created by Dylan Wight on 10/9/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit

class StickerCell: UITableViewCell {
    
    var url: URL? {
        didSet {
            guard let url = url else { return }
            
            stickerImageView?.image = UIImage(contentsOfFile: url.absoluteString)
            stickerNameLabel?.text = url.absoluteString
        }
    }
    
    @IBOutlet var stickerImageView: UIImageView?
    
    @IBOutlet var stickerNameLabel: UILabel?
    
}
