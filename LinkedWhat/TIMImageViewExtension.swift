//
//  TIMImageViewExtension.swift
//  LinkedWhat
//
//  Created by Tim Broder on 10/4/15.
//  Copyright © 2015 Tim Broder. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func roundify() {
        self.layer.cornerRadius = self.frame.size.height / 1.5;
        self.clipsToBounds = true;
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
    }
}