//
//  User+CoreDataProperties.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/30/18.
//  Copyright © 2018 Mirage. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension User {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String
    @NSManaged public var address: String?
    @NSManaged public var frequentDestinations: NSObject?
    
    @objc func saveUser() {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let container = appDelegate.persistentContainer
        
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    @objc func getUser() -> User? {
        
        
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let container = appDelegate.persistentContainer
        
        do {
            let result = try container.viewContext.fetch(User.createFetchRequest())
            if result.isEmpty {
                return nil
            } else {
                if (result.count > 1) {
                    print("fetched more than 1 user")
                }
                return result.first
            }
        } catch {
            print("Error fetching user")
            return nil
        }
        
    }
    
    @objc func userInfo() -> [String: Any]? {
        var userInfoDict: [String : Any] = ["name" : "",
                                            "address" : "",
                                            "frequentDest" : [String]()]
        
//        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//        let container = appDelegate.persistentContainer
        
        let loadedUser = getUser()
        if loadedUser == nil {
            return nil
        }
        
        userInfoDict.updateValue(loadedUser!.name, forKey: "name")
        userInfoDict.updateValue(loadedUser!.address ?? "", forKey: "address")
        userInfoDict.updateValue(loadedUser!.frequentDestinations ?? [""], forKey: "frequentDest")
        
        return userInfoDict
    }
    
    
}
