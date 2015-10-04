//
//  TIMLinkedin.swift
//  LinkedWhat
//
//  Created by Tim Broder on 10/3/15.
//  Copyright © 2015 Tim Broder. All rights reserved.
//

import Foundation
import IOSLinkedInAPI
import NRSimplePlist

struct TIMLinkedin {
    
    static var client: LIALinkedInHttpClient? {
        let clientID: String
        let clientSecret: String
        
        do {
            clientID = try plistGet("clientId", forPlistNamed: "settings") as! String
            clientSecret = try plistGet("clientSecret", forPlistNamed: "settings") as! String
            
            let application = LIALinkedInApplication(redirectURL: "http://timbroder.com",
                clientId: clientID,
                clientSecret: clientSecret,
                state: "DCEEFWF45453sdffef424",
                grantedAccess: ["r_basicprofile", "r_emailaddress"])
            
            return LIALinkedInHttpClient(forApplication: application, presentingViewController: nil)
            
        } catch let error1 as NSError {
            //TODO handle error
            print(error1)
        }

        return nil
    }
    
    init() {
        
    }
    
}