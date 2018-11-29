//
//  MirageAlert.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/2/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation
import UIKit

class alertAction {
    
    var title = ""
    var style = UIAlertActionStyle.default
    var handler: Selector!
    
    init(title: String, style: UIAlertActionStyle, handler: Selector) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
}

