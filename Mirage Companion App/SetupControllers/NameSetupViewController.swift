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
    var user: User!
    var name: String = ""
    var filename = ""
    var numberUsers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.getNumUsers() { num in
                self.numberUsers = num
                self.filename = "user" + String(num)
            }
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: "NameToCalibration", sender: filename)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getNumUsers(completion: @escaping (Int) -> Void) {
        let url = URL(string: "http://" + ipAddr + ":5000/user/getnum")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error: No description")
                completion(0)
                return
            }
            let response = String(data: data, encoding: .utf8)
            print("Done")
            completion(Int(response ?? "0") ?? 0)
        }
        task.resume()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return filename != ""
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        self.user = User(id: numberUsers, name: self.name, address: "", freqDests: [], news: [])
        let dest = segue.destination as! FaceCalibrationViewController
        dest.user = self.user
        dest.calibrationFile = filename
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
//        self.user = User(id: numberUsers, name: self.name, address: "", freqDests: [], news: [])
    }
    
}
