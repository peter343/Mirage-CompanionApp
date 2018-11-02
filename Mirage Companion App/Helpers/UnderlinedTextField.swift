//
//  UnderlinedTextField.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/6/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation
import UIKit

class UnderlinedTextField: UITextField {
    
    @IBOutlet weak var underlineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        underlineView.backgroundColor = UIColor.init(red: 255, green: 196, blue: 81, alpha: 100)
    }
}
