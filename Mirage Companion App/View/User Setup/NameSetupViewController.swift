//
//  NameSetupViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/27/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class NameSetupViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    var user: User?
    var name: String = ""
    var numberUsers: Int = 0
    var editingProfile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        
        if (editingProfile) {
            nameField.text = user?.name
            name = user!.name
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: "NameToCalibration", sender: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (editingProfile) {
            self.user!.name = self.name
        } else {
            self.user = User(id: SystemInfo.shared().getNumUsers() ?? 0, name: self.name, address: "", freqDests: [], news: [], googleConn: "False")
        }

        let dest = segue.destination as! FaceCalibrationViewController
        dest.user = self.user!
        dest.editingProfile = self.editingProfile
    }
}

extension NameSetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Do something with this info
        self.name = textField.text ?? ""
    }
    
}
