//
//  ViewController.swift
//  MatchMaker
//
//  Created by Aditya Vikram Godawat on 27/01/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit
import Parse
//import Bolts
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
//import ParseFacebookUtils

class ViewController: UIViewController {
    
    @IBAction func signin(sender: AnyObject) {
        
        let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            
            (user: PFUser?, error: NSError?) -> Void in
            
            if let anError = error {1
                print(anError)
            } else {
                
                if let user = user {
                    
                    if let interestedInWomen = user["interestedInWomen"] {
                        
                        self.performSegueWithIdentifier("logUserIn", sender: self)
                        
                    } else {
                        
                        self.performSegueWithIdentifier("showSignInScreen", sender: self)
                        
                    }
                }
                
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
                
        if let username = PFUser.currentUser()?.username {
           
            if let interestedInWomen = PFUser.currentUser()?["interestedInWomen"] {
                
                self.performSegueWithIdentifier("logUserIn", sender: self)
                
            } else {
                
                self.performSegueWithIdentifier("showSignInScreen", sender: self)
                
            }

            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

