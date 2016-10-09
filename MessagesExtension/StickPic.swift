//
//  StickPic.swift
//  StickPics
//
//  Created by Dylan Wight on 10/9/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import RealmSwift
import Foundation

class StickPic: Object {
    
    dynamic var urlString: String = ""
    dynamic var title: String = ""
    dynamic var image: NSData? = nil
    
    var url: URL? {
        return URL(string: urlString)
    }
}
