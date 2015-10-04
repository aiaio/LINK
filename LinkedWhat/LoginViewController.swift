//
//  LoginViewController.swift
//  LinkedWhat
//
//  Created by Tim Broder on 10/3/15.
//  Copyright © 2015 Tim Broder. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let client = TIMLinkedin.client
        
        //TODO handle nil client
        
        client?.getAuthorizationCode({ (code) -> Void in
            //success

            //TODO Store code and accessToken in a better way (SwiftyUserDefaults)
            client?.getAccessToken(code, success: { (accessTokenData) -> Void in
                let accessToken = accessTokenData["access_token"]
                
                }, failure: { (error) -> Void in
                    //TODO handle
                    print(error)
            })
            
            
            
            //TODO handle
            }, cancel: { () -> Void in
                
            //TODO handle
            }, failure: { (error) -> Void in
                print(error)
        })
    }
}
