//
//  Destination.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/7/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation
import UIKit


/// A Destination object that holds a name and address of a user's frequent destination.
/// # Is JSON serializable
class Destination: NSObject, Codable {
    
    /// Name of the destination
    public var name: String
    /// Address of the destination
    public var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
    
}
