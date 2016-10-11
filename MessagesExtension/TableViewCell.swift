//
//  TableViewCell.swift
//  StickPics
//
//  Created by Dylan Wight on 10/10/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TableViewCell"
    
    @IBOutlet weak var stickerImageView: UIImageView?
    
    var url: URL? {
        didSet {
            guard let url = url else { return }
            stickerImageView?.image = UIImage(contentsOfFile: url.absoluteString)
        }
    }
}
