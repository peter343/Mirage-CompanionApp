//
//  Helper.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/9/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation

func getUserFromJSON(json data: [String : Any]) -> User? {
    guard let userName = data["name"] as? String,
        let address = data["address"] as? String,
        let freqDests = data["freqDests"] as? [[String : Any]] else { return nil }
    var freqDestinations: [Destination] = []
    for dict in freqDests {
        guard let destName = dict["name"] as? String,
            let destAddress = dict["address"] as? String
            else { return nil }
        let destination = Destination(name: destName, address: destAddress)
        freqDestinations.append(destination)
    }
    
    return User(name: userName, address: address, freqDests: freqDestinations)
}
