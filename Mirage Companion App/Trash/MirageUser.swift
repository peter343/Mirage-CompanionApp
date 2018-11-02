//
//  MirageUser.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/30/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation

class MirageUser: NSObject {
    
    static var docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let arcURL: URL = docDir.appendingPathComponent("mirageUser")
    
    static var user: MirageUser = {
        let instance = MirageUser()
        return instance
    }()
    
    struct UserKeys {
        static let nameKey = "name"
        static let addressKey = "address"
        static let freqDestsKey = "freqDests"
    }
    
    var name: String?
    var address: String?
    var freqDests: [Destination]?
    
    override init() {
        // Do nothing for now
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: UserKeys.nameKey) as? String
        let address = aDecoder.decodeObject(forKey: UserKeys.addressKey) as? String
        let freqDests = aDecoder.decodeObject(forKey: UserKeys.freqDestsKey) as? [Destination]

        self.init()

        self.name = name
        self.address = address
        self.freqDests = freqDests
    }
    
    // Helper for Frequent Destinations
    func addFreqDest(dest: Destination) {
        if (freqDests == nil) {
            freqDests = []
        }
        
        freqDests!.append(dest)
        
    }
}



extension MirageUser: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: UserKeys.nameKey)
        aCoder.encode(self.address, forKey: UserKeys.addressKey)
        aCoder.encode(self.freqDests, forKey: UserKeys.freqDestsKey)
    }

    static func saveUser() {
        let savedData = NSKeyedArchiver.archiveRootObject(user, toFile: arcURL.path)
        if (savedData) {
            print("Successfully saved user to disk")
        } else {
            print("Unable to save user to disk")
        }
    }
    
    static func loadUser() -> Bool {
        guard let loadedUser = NSKeyedUnarchiver.unarchiveObject(withFile: arcURL.path) as? MirageUser else { return false }
        user = loadedUser
        return true
    }
    
    static func userExistsOnDisk() -> Bool {
        return FileManager().fileExists(atPath: arcURL.path)
    }

}
