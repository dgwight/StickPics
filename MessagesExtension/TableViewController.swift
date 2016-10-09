//
//  TableViewController.swift
//  StickPics
//
//  Created by Dylan Wight on 10/9/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var stickPics: [URL] {
        return StickPicHistory.load().stickPicURLs
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stickPics.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
