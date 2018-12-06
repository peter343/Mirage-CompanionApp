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
//    var userFile: String = ""
    var editingProfile: Bool = false
    var activityView: ActivityViewController?
    var googleConnected: String = "False"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func connectCalendarPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.google.com/device")!)
        SystemInfo.shared().startGoogleAuth() { authorized in
            if (authorized) {
                self.user.googleConnected = "True"
                self.googleConnected = "True"
                SystemInfo.shared().sendUser(user: self.user) { saved in
                    if (saved) {
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        // Alert unable to save
                        
                    }
                }
            } else {
                // Alert unable to authorize
                self.googleConnected = "False"
            }
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if (!userSaved) {
            if (editingProfile) {
                print("Updating profile")
                activityView = ActivityViewController(message: "Updating your profile...")
                self.present(activityView!, animated: true, completion: nil)
                self.user.googleConnected = googleConnected
                SystemInfo.shared().updateUser(user: self.user) { completed in
                    print(completed)
                    if (completed) {
                        DispatchQueue.main.async {
                            self.activityView!.dismiss(animated: true, completion: nil)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            } else {
                print("Adding Profile")
                activityView = ActivityViewController(message: "Setting up your profile...")
                self.present(activityView!, animated: true, completion: nil)
                self.user.googleConnected = googleConnected
                SystemInfo.shared().sendUser(user: self.user) { completed in
                    print(completed)
                    if (completed) {
                        DispatchQueue.main.async {
                            self.activityView!.dismiss(animated: true, completion: nil)
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        } else {
//            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        print("Going back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
