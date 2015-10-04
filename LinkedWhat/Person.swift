//
//  Person.swift
//  LinkedWhat
//
//  Created by Tim Broder on 10/3/15.
//  Copyright © 2015 Tim Broder. All rights reserved.
//

import Foundation

struct Person {
    let firstName: String
    let lastName: String
    let title: String
    
    init(firstName: String, lastName: String, title: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.title = title
    }
}