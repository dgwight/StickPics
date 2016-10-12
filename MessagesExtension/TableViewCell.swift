//
//  TableViewCell.swift
//  StickPics
//
//  Created by Dylan Wight on 10/10/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit
import Messages

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TableViewCell"
    
    @IBOutlet weak var stickerView: MSStickerView!
}
