//
//  Destination.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/7/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation
import UIKit

class Destination: NSObject, Codable {
    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.name, forKey: "destName")
//        aCoder.encode(self.address, forKey: "destAddress")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        let name = aDecoder.decodeObject(forKey: "destName") as? String
//        let address = aDecoder.decodeObject(forKey: "destAddress") as? String
//        self.name = name ?? ""
//        self.address = address ?? ""
//    }
//
    public var name: String
    public var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
    
}
