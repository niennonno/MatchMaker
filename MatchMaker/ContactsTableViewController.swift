//
//  ContactsTableViewController.swift
//  MatchMaker
//
//  Created by Aditya Vikram Godawat on 02/02/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit
import Parse

class ContactsTableViewController: UITableViewController {

    var emails = [String]()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let  query = PFUser.query()!
        query.whereKey("accepted", equalTo: (PFUser.currentUser()?.objectId)!)
        query.whereKey("objectId", containedIn: PFUser.currentUser()?["accepted"] as! Array)
        
        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            
            if error != nil {
                print(error)
            } else if let results = results {
                
                for result in results as! [PFUser] {
                
                    self.emails.append(result.email!)
                    
                    let imageFile = result["image"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        if error != nil{
                            
                            print(error)
                            
                        } else {
                            if let data = data {
                                self.images.append(UIImage(data: data)!)
                                
                                self.tableView.reloadData()

                            }
                        }
                    })

               
                }
                
                self.tableView.reloadData()
                
            }
            
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return emails.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if images.count > indexPath.row {
            
            cell.imageView?.image = images[indexPath.row]
            
        }
        
        cell.textLabel?.text = self.emails[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: "mailto: " + emails[indexPath.row])
        
        UIApplication.sharedApplication().openURL(url!)
        
    }
    
}
