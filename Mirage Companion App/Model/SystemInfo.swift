//
//  SystemInfo.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/2/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation


/// SystemInfo class contains all methods and variables needed to keep track of the connected Mirage Smart Mirror.
/// The variables within SystemInfo are meant to be static across the entire app, therefore, the only way to access them is through the shared() variable.
class SystemInfo {
    
    private static var systemInfo: SystemInfo = {
        let instance = SystemInfo()
        return instance
    }()
    
    private static var numberOfUsers: Int?
    private static var isConnected: Bool = false
    private static var ipAddress: String? = "10.0.1.16"
    private static var users: [Int : User] = [:]
    
    
    private init () {}
    
    func getNumUsers() -> Int? { return SystemInfo.numberOfUsers }
    func getConnection() -> Bool { return SystemInfo.isConnected }
    func getIPAddress() -> String? { return SystemInfo.ipAddress }
    func getUsers() -> [Int : User] { return SystemInfo.users }
    
    func setNumUsers(num: Int?) { SystemInfo.numberOfUsers = num }
    func setConnectionStatus(connected: Bool) { SystemInfo.isConnected = connected }
    func setIPAddress(ip: String?) { SystemInfo.ipAddress = ip }
    func setUsers(users: [Int:User]?) { SystemInfo.users = (users ?? [:])}
    
    /// The shared static variable used to access the variables and methods of SystemInfo across entire app
    class func shared() -> SystemInfo {
        return systemInfo
    }
    
    /// Load all information from Mirage. Usually done once phone is connected to Mirage and WiFi connectivity is established. Can be called to update the information on the phone after user is added or updated.
    func loadSystemInfo() {
        DispatchQueue.main.async {
            self.loadNumUsers() { num in
                self.setNumUsers(num: num)
                for i in 0 ..< num {
                    self.getUser(userNum: i) { _ in
                        // Do nothing
                    }
                }
            }
        }
        
    }
    
    
    /// Get the number of users in the currently connected Mirage system.
    /// - Parameter completion: Completion handler.
    /// - Returns: The number of users in the currently connected Mirage system.
    func loadNumUsers(completion: @escaping (Int) -> Void) {
        let url = URL(string: "http://" + (SystemInfo.shared().getIPAddress() ?? "") + ":5000/user/getnum")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error: No description")
                completion(0)
                return
            }
            let response = String(data: data, encoding: .utf8)
            completion(Int(response ?? "0") ?? 0)
        }
        task.resume()
    }
    
    /// Get the specified user from the Mirage system
    /// - Parameters:
    ///     - userNum: The id of the user to retrieve.
    ///     - completion: Boolean completion handler
    /// - Returns: True or False depending on if the user information is successfully retrieved
    func getUser(userNum: Int, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://" + (SystemInfo.shared().getIPAddress() ?? "") + ":5000/user/get/\(userNum)")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error: No description")
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonData = jsonData as? [String : Any] {
                    if let user = getUserFromJSON(json: jsonData) {
                        var tempUsers = SystemInfo.shared().getUsers()
                        tempUsers.updateValue(user, forKey: userNum)
                        SystemInfo.shared().setUsers(users: tempUsers)
                        completion(true)
                    }
                    completion(false)
                }
                completion(false)
                
            } catch {
                print("Unable to read User as JSON")
                return
            }
        }
        task.resume()
    }
    
    struct userInfo: Codable {
        var user_info: User
    }
    
    /// Sends the specified User object to the Mirage system
    /// - Parameters:
    ///     - user: The user to send to the Mirage system
    ///     - completion: Boolean completion handler
    /// - Returns: True or False depending on if the information was sent successfuly
    func sendUser(user: User, completion: @escaping (Bool) -> Void) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userInfo(user_info: user))
            let url = URL(string: "http://" + (SystemInfo.shared().getIPAddress() ?? "") + ":5000/user/add")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No error description")
                        completion(false)
                        return
                    }
                    let response = String(data: data, encoding: .utf8)
                    print(response ?? "No valid response")
                    if (response == "User successfully added") {
                        print("User saved")
                        completion(true)
                    }
                
            }
            task.resume()
        } catch {
            print("Error encoding User to JSON")
            completion(false)
        }
    }
    
    
//    func sendUser(user: User, completion: @escaping (Bool) -> Void) {
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(user)
//            let jsonString = String(data: data, encoding: .utf8)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            let url = URL(string: "http://" + (ipAddress ?? "") + ":5000/user/add/user" + String(numberOfUsers ?? 0) + "/\(jsonString!)")
//            var request = URLRequest(url: url!)
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//                guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No error description")
//                    completion(false)
//                    return
//                }
//                let response = String(data: data, encoding: .utf8)
//                print(response ?? "No valid response")
//                if (response == "User successfully added") {
//                    print("User saved")
//                    completion(true)
//                }
//            }
//            task.resume()
//        } catch {
//            print("Error encoding User to JSON")
//            completion(false)
//        }
//    }
    
    /// Starts the Google Authorization process for the user to complete. Sends a signal to the Mirage system which will display a code for the user to enter
    /// - Parameter completion: Boolean completion handler
    /// - Returns: True or False depending on if the authorization process has started, not necessarily if the user decided to authorize or not.
    func startGoogleAuth(completion: @escaping (Bool) -> Void) {
      
        let url = URL(string: "http://" + (SystemInfo.shared().getIPAddress() ?? "") + ":5000/user/authorize/google/user" + String(SystemInfo.shared().getNumUsers() ?? 0))
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No error description")
                completion(false)
                return
            }
            let response = String(data: data, encoding: .utf8)
            print(response ?? "No valid response")
            if (response == "Success") {
                print("Authorization started. Waiting for user to authorize")
                completion(true)
            }
        }
        task.resume()
    }
    
    /// Notifies the Mirage system to start facial calibration.
    /// - Parameter completion: Boolean completion handler
    /// - Returns: True or False dependent on whether or not the facial calibration process has completed or not.
    func startCalibration(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://" + (SystemInfo.shared().getIPAddress() ?? "") + ":5000/setup/newuser/" + "user" + String(SystemInfo.shared().getNumUsers() ?? 0))
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let response = String(data: data, encoding: .utf8)
            print(response ?? "No valid response")
            if (response == "Done") {
                completion (true)
            } else {
                completion (false)
            }
        }
        task.resume()
    }
    
    /// Replaces the user with the same ID in the Mirage system with the one specified.
    /// - Parameters:
    ///     - user: User information to send to the Mirage system.
    ///     - completion: Boolean completion handler.
    /// - Returns: True or False dependent on whether or not the user in the system was successfully updated
    func updateUser(user: User, completion: @escaping (Bool) -> Void) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userInfo(user_info: user))
            let url = URL(string: "http://" + (SystemInfo.shared().getIPAddress() ?? "") + ":5000/user/update")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No error description")
                    completion(false)
                    return
                }
                let response = String(data: data, encoding: .utf8)
                print(response ?? "No valid response")
                if (response == "User successfully updated") {
                    print("User updated")
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
            task.resume()
        } catch {
            print("Error encoding User to JSON")
            completion(false)
        }
    }
//    func updateUser(user: User, completion: @escaping (Bool) -> Void) {
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(user)
//            let jsonString = String(data: data, encoding: .utf8)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            let url = URL(string: "http://" + (ipAddress ?? "") + ":5000/user/update/\(user.id)/\(jsonString!)")
//            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//                guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No error description")
//                    completion(false)
//                    return
//                }
//                let response = String(data: data, encoding: .utf8)
//                print(response ?? "No valid response")
//                if (response == "User successfully updated") {
//                    print("User saved")
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//
//            }
//            task.resume()
//        } catch {
//            print("Error encoding User to JSON")
//            completion(false)
//        }
//    }
}
