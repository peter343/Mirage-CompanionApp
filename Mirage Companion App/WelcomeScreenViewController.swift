//
//  WelcomeScreenViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/30/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var setupProfileButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // If there exists a profile, we can edit a profile
        editProfileButton.isEnabled = MirageUser.userExistsOnDisk()
        
    }
    
    // IBActions
    @IBAction func setupButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SetupProfile", sender: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "EditProfile", sender: nil)
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
