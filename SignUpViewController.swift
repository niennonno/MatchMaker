//
//  SignUpViewController.swift
//  MatchMaker
//
//  Created by Aditya Vikram Godawat on 01/02/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class SignUpViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var interestedInWomen: UISwitch!
    
    @IBAction func signUp(sender: AnyObject) {
        
        PFUser.currentUser()?["interestedInWomen"] = interestedInWomen.on
        do { try PFUser.currentUser()?.save()
        } catch {
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender"])
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if error != nil {
                print(error)
            } else {
                
                if let result = result {
                    
                    PFUser.currentUser()?["gender"] = result["gender"]
                    PFUser.currentUser()?["name"] = result["name"]
                    
                    do { try PFUser.currentUser()?.save()
                    } catch {
                    }
                    
                    let userId = result["id"] as! String
                    
                    let facebookProfilePictureURL = "https:/graph.facebook.com/" + userId + "/picture?type=large"
                    
                    if let fbpicURL = NSURL(string: facebookProfilePictureURL) {
                        
                        if let data = NSData(contentsOfURL: fbpicURL) {
                            
                            self.userImage.image = UIImage(data: data)
                            
                            let imageFile: PFFile = PFFile(data: data)!
                            
                            PFUser.currentUser()?["image"] = imageFile
                            
                            do { try PFUser.currentUser()?.save()
                            } catch {
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
