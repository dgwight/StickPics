//
//  StickPicService.swift
//  StickPics
//
//  Created by Dylan Wight on 8/20/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import RealmSwift
import Realm

struct StickPicService {
    
    let realm = try! Realm()
    
    func addStickPic(url: URL) {
        let stickPic = StickPic()
        stickPic.title = "Test"
        stickPic.urlString = url.absoluteString
        
        try! realm.write {
            realm.add(stickPic)
        }
    }
}
