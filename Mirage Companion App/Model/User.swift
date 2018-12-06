//
//  User.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/9/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation

/// A User object contains all necessary properties for creating a user on the Mirage system
class User: NSObject, Codable {
    
    /// User's ID in the Mirage System
    public var id: Int
    /// User's name
    public var name: String
    /// User's address
    public var address: String
    /// User's frequent destinations
    public var freqDests: [Destination]
    /// User's preferred news categories
    public var newsCategories: [String]
    /// If the user has connected their Google Calendar
    public var googleConnected: String
    
    init(id: Int, name: String, address: String, freqDests: [Destination], news: [String], googleConn: String) {
        self.id = id
        self.name = name
        self.address = address
        self.freqDests = freqDests
        self.newsCategories = news
        self.googleConnected = googleConn
    }
    
    func addFreqDest(destination dest: Destination) {
        if (freqDests == nil) {
            freqDests = []
        }
        freqDests.append(dest)
    }
}
