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
        let userID = data["id"] as? Int,
        let address = data["address"] as? String,
        let freqDests = data["freqDests"] as? [[String : Any]],
        let newsArray = data["news"] as? [String] else { return nil }
    var freqDestinations: [Destination] = []
    for dict in freqDests {
        guard let destName = dict["name"] as? String,
            let destAddress = dict["address"] as? String
            else { return nil }
        let destination = Destination(name: destName, address: destAddress)
        freqDestinations.append(destination)
    }
    
    return User(id: userID, name: userName, address: address, freqDests: freqDestinations, news: newsArray)
}

func getDictFromUser(user: User) -> [String : Any] {
    var userDict: [String : Any] = [:]
    
    userDict.updateValue(String(user.id), forKey: "id")
    userDict.updateValue(user.name, forKey: "name")
    userDict.updateValue(user.address, forKey: "address")
    userDict.updateValue(getDictFromDestinations(dests: user.freqDests), forKey: "freqDest")
    userDict.updateValue(user.newsCategories, forKey: "news")
    return userDict

}

func getDictFromDestinations(dests: [Destination?]) -> [String : [[String : String]]] {
    var encodedDests: [[String : String]] = []
    for dest in dests {
        let dict = ["name": dest!.name, "address": dest!.address]
        encodedDests.append(dict)
    }
    return ["freqDests":encodedDests]
}
