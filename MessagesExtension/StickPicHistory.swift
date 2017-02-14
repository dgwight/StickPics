//
//  Store.swift
//  StickPics
//
//  Created by Dylan Wight on 8/20/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Messages

class StickPicHistory {
    
    static let userDefaultsKey = "StickPicHistory"

    let prefs = UserDefaults()

    var stickPicURLs: [URL] {
        return Array(urls)
    }
        
    var urls = Set<URL>()
    
    func add(url: URL) {
        urls.insert(url)
        save()
    }
    
    func remove(url: URL) {
        urls.remove(url)
        save()
    }
    
    private init(stickPicURLs: [URL]) {
        self.urls = Set(stickPicURLs)
    }
    
    /// Loads previously created `IceCream`s and returns a `IceCreamHistory` instance.
    static func load() -> StickPicHistory {
        var stickPicURLs = [URL]()
        let defaults = UserDefaults.standard
        
        if let savedStickPics = defaults.object(forKey: StickPicHistory.userDefaultsKey) as? [String] {
            stickPicURLs = savedStickPics.flatMap { urlString in
                return URL(string: urlString)
            }
        }
        
        return StickPicHistory(stickPicURLs: stickPicURLs)
    }
    
    /// Saves the history.
    func save() {
        
        let defaults = UserDefaults.standard

        let stickPicURLStrings: [String] = urls.flatMap { stickPic in
            return stickPic.absoluteString
        }
        
        defaults.set(stickPicURLStrings as AnyObject, forKey: StickPicHistory.userDefaultsKey)
    }
}


