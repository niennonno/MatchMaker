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

    
    @IBOutlet var button: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let permissions = ["public_profile"]
       
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
        
            (user: PFUser?, error: NSError?) -> Void in
            
            if let anError = error {
                print(anError)
            } else {
                
                if let aUser = user {
                    
                    print(aUser)
                    
                }
                
            }
        
        }
        
        
//        let button: FBSDKLoginButton = FBSDKLoginButton()
//        self.button.readPermissions = permissions   
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

