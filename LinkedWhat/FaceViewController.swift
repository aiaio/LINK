//
//  FaceViewController.swift
//  LinkedWhat
//
//  Created by Tim Broder on 10/3/15.
//  Copyright © 2015 Tim Broder. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftyJSON

class FaceViewController: UIViewController {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var faceImageView: UIImageView!
    
    var json: JSON? // raw data back from LinkedIn or apiary
    var titles: Set<String> // unique list of titles. used to power the random buttons
    var people: [Person] // model versions of JSON
    
    //TODO make this model driven
    var counter = 0
    
    required init?(coder aDecoder: NSCoder) {
        self.titles = Set<String>()
        self.people = [Person]()
        
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide UI until we get data back
        leftButton.hidden = true
        rightButton.hidden = true
        faceImageView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        // Mock data
        let url = NSURL(string: "https://private-d208d-linkedwhat.apiary-mock.com/docs/rest-api/connections")!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            SVProgressHUD.dismiss()

            if error != nil {
                // TODO Handle error...
                return
            }
            
            // convert data to SwiftyJSON
            self.json = JSON(data: data!)

            // get unique titles and convert to models
            for (_,subJson):(String, JSON) in self.json! {
                let person = Person(firstName: subJson["title"].string!, lastName: subJson["title"].string!, title: subJson["title"].string!)
                self.people.append(person)
                
                self.titles.insert(person.title)
                
            }
            
            // get us back to the main thread for animations
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.showNext()
            })
            
        }
        
        task.resume()
    }
    
    
    //TODO break out into View Model w/Notifications & KVO
    private func showNext() {
        print("show next")
        
        let person = self.people[self.counter]
        SVProgressHUD.dismiss()
        
        leftButton.hidden = false
        rightButton.hidden = false
        faceImageView.hidden = false
        
        let randomRight = person.title
        let check = arc4random_uniform(2)
        
        // get random title
        let startIndex = self.titles.startIndex
        var randomOffsetLeft = Int(arc4random_uniform(UInt32(self.titles.count)))
        var randomLeft = self.titles[startIndex.advancedBy(randomOffsetLeft)]
        
        // TODO BAD could be infinite
        // make sure random title isn't the same as the title of the person we're showing
        while randomLeft == randomRight {
            randomOffsetLeft = Int(arc4random_uniform(UInt32(self.titles.count)))
            randomLeft = self.titles[startIndex.advancedBy(randomOffsetLeft)]
        }
        
        // randomize where the correct answer is
        leftButton.titleLabel?.text = randomLeft
        
        if check == 0 {
            leftButton.setTitle(randomLeft, forState: .Normal)
            leftButton.setTitle(randomLeft, forState: .Highlighted)
            
            rightButton.setTitle(randomRight, forState: .Normal)
            rightButton.setTitle(randomRight, forState: .Highlighted)
        } else {
            rightButton.setTitle(randomLeft, forState: .Normal)
            rightButton.setTitle(randomLeft, forState: .Highlighted)
            
            leftButton.setTitle(randomRight, forState: .Normal)
            leftButton.setTitle(randomRight, forState: .Highlighted)
        }
        
        
        
    }
    
    //Todo Move to View Model
    private func checkChoice(value: String) {
        
        let person = self.people[self.counter]
        var message = "WRONG!"
        
        if value == person.title {
            message = "Correct!"
        }
        
        let alertController = UIAlertController(title: message, message: value, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                // move to the next person
                self.counter++
                
                if self.counter == self.people.count {
                    self.counter = 0
                }
                
                self.showNext()
            })
        }
        alertController.addAction(cancelAction)
                
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    
    @IBAction func leftTapped(sender: AnyObject) {
        self.checkChoice((leftButton.titleLabel?.text)!)
    }
    
    
    @IBAction func rightTapped(sender: AnyObject) {
        self.checkChoice((rightButton.titleLabel?.text)!)
    }

    
}
