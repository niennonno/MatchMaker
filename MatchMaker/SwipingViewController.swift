//
//  SwipingViewController.swift
//  MatchMaker
//
//  Created by Aditya Vikram Godawat on 01/02/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        var interestedIn = "male"
        
        if PFUser.currentUser()!["interestedInWomen"] as! Bool == true {
        
            interestedIn = "female"
            
        }
        
        var isFemale = true
        
        if PFUser.currentUser()!["gender"] as! String == "male" {
        
            isFemale = false
            
        }
        
            query!.whereKey("gender", equalTo: interestedIn)
            query?.whereKey("interestedInWomen", equalTo: isFemale)
            query?.limit = 1
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if error != nil {
                print(error)
            }else {
                
                for object in objects! {

                let imageFile = object["image"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        if error != nil{
                            
                            print(error)
                            
                        } else {
                            if let data = data {
                                self.userImage.image = UIImage(data: data)
                            }
                        }
                    })
                
                }
                
            }
            
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logOut" {
            PFUser.logOut()
        }
    }
    
}
