//
//  SetupProfileViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/1/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var freqDestTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Assign Delegates
        nameTextField.delegate = self
        addressTextField.delegate = self
        freqDestTextField.delegate = self
    
    }
    
    // IBAction
    @IBAction func saveProfile(_ sender: UIButton) {
        MirageUser.saveUser()
        self.performSegue(withIdentifier: "setupToWelcome", sender: nil)
    }
    
    @IBAction func goToGoogle(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.google.com/device")!)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension SetupProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
            addressTextField.becomeFirstResponder()
            break
        case addressTextField:
            addressTextField.resignFirstResponder()
            freqDestTextField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            MirageUser.user.name = nameTextField.text
            break
        case addressTextField:
            MirageUser.user.address = addressTextField.text
            break
        case freqDestTextField:
            MirageUser.user.addFreqDest(dest: freqDestTextField.text)
            break
        default:
            break
        }
    }
    
}
