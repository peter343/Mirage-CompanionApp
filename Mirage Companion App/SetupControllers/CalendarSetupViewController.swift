//
//  CalendarSetupViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/27/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class CalendarSetupViewController: UIViewController {

    var user: User!
    var userSaved: Bool = false
    var userFile: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func connectCalendarPressed(_ sender: Any) {
        // Need to send user's name so Amjad can setup a credentials file for that user
        // Once file is created we can go to google site, etc.
        UIApplication.shared.open(URL(string: "https://www.google.com/device")!)
        DispatchQueue.main.async {
            self.startGoogleAuth() { completed in
                if (!completed) {
                    print("Error authenticating user's google calendar")
                }
            }
        }
        
//        if (!userSaved) {
//            DispatchQueue.main.async {
//                self.sendUser() { completed in
//                    if (completed) {
//                        // Now we start google auth
//                    } else {
//                        // Error, cannot start google auth
//                    }
//                }
//            }
//        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if (!userSaved) {
            DispatchQueue.main.async {
                self.sendUser() { completed in
                    if (completed) {
                        
                    } else {
                        // Show error
                    }
                }
            }
        } else {
//            self.navigationController?.popToRootViewController(animated: true)
        }
        self.navigationController?.popToRootViewController(animated: true)
        
        
        // Todo: send info and pop back to home screen
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func sendUser(completion: @escaping (Bool) -> Void) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.user)
            let jsonString = String(data: data, encoding: .utf8)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: "http://" + ipAddr + ":5000/user/add/\(self.userFile)/\(jsonString!)")
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
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
                    self.userSaved = true
                }
            }
            task.resume()
        } catch {
            print("Error encoding User to JSON")
            completion(false)
        }
    }
    
    func startGoogleAuth(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://" + ipAddr + ":5000/user/authorize/google/\(self.userFile)")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
