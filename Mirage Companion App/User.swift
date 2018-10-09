//
//  User.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/9/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation

class User: NSObject, Codable {
    
    public var name: String
    public var address: String
    public var freqDests: [Destination]
    
    init(name: String, address: String, freqDests: [Destination]) {
        self.name = name
        self.address = address
        self.freqDests = freqDests
    }
    
    func addFreqDest(destination dest: Destination) {
        if (freqDests == nil) {
            freqDests = []
        }
        freqDests.append(dest)
    }
}
