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
    
//MARK :- IBOutlets

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var infoLabel: UILabel!

//MARK :- Global Variables
    
    var displayedUserId = ""
    
//MARK :- User Defined Functions
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 100)
        
        let scale = min( 100 / abs(xFromCenter), 1)
        
        var stretch = CGAffineTransformScale(rotation, scale, 0.9)
        
        label.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 50 {
                acceptedOrRejected = "rejected"
            } else if label.center.x > self.view.bounds.width - 50 {
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayedUserId], forKey: acceptedOrRejected)
                do { try PFUser.currentUser()?.save() }
                    catch{}
                
            }
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2    )
            
            updateImage()
            
        }
        
    }

    func updateImage() {
        
        let query = PFUser.query()
        
        if let latitude = PFUser.currentUser()?["location"].latitude {
        
            if let longitude = PFUser.currentUser()?["location"].longitude {
        
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1,
                    longitude: longitude + 1))
            }
        }
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
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"]{
            
            ignoredUsers += acceptedUsers as! Array
            
        }
        
        if let rejectedUsers = PFUser.currentUser()?["rejected"]{
            
            ignoredUsers += rejectedUsers as! Array
        
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        query?.limit = 1
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if error != nil {
                print(error)
            }else {
                
                for object in objects! {
                    
                    self.displayedUserId = object.objectId!
                    
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
    
//MARK :- Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        userImage.addGestureRecognizer(gesture)
        userImage.userInteractionEnabled = true
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint, error) -> Void in
            
            if error != nil {
                print(error)
            } else if let geoPoint = geoPoint {
                
                PFUser.currentUser()?["location"] = geoPoint
                do { try PFUser.currentUser()?.save() }
                catch{}
            }
            
        }
        
        updateImage()
        
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
