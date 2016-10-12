//
//  TableViewController.swift
//  StickPics
//
//  Created by Dylan Wight on 10/9/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit
import CoreData
import Messages

let backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)

class TableViewController: UITableViewController {
    
    static let storyboardIdentifier = "TableViewController"
    
    weak var delegate: CreateStickPicDelegate?
    
    var stickPics: [URL] {
        return StickPicHistory.load().stickPicURLs
    }
    
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        tableView?.tableFooterView = UIView()
        tableView?.backgroundColor = backgroundColor
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stickPics.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        do {
            cell.stickerView.sticker = try MSSticker(contentsOfFileURL: stickPics[indexPath.row], localizedDescription: "test")
        } catch {
            print(error)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contoller = segue.destination as? CreateStickPicController {
            contoller.delegate = delegate
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return  UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt editActionsForRowAtIndexPath: IndexPath) -> [UITableViewRowAction] {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { action, indexPath in
            self.setEditing(false, animated: true)
            let deleteAlert = UIAlertController(title: "Delete StickPic?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                StickPicHistory.load().remove(url: self.stickPics[indexPath.row])
                self.tableView?.reloadData()
            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
            self.present(deleteAlert, animated: true, completion: nil)
        })
        return [deleteAction]
    }
    
    @IBAction func handleCreateTapped(_ sender: UIBarButtonItem) {
        if stickPics.count < 8 {
            performSegue(withIdentifier: "toCreate", sender: sender)
        } else {
            let fullAlert = UIAlertController(title: "Your Collection is Full", message: "Drag cells to the left to delete them", preferredStyle: UIAlertControllerStyle.alert)

            fullAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil ))
            self.present(fullAlert, animated: true, completion: nil)
        }
    }
}
