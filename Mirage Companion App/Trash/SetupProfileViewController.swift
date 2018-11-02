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
   // @IBOutlet weak var freqDestTextField: UITextField!
    @IBOutlet weak var addFreqDest: UIButton!
    @IBOutlet weak var numDestLabel: UILabel!
    
    var name: String? = ""
    var address: String? = ""
    var destinations: [Destination]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Assign Delegates
        nameTextField.delegate = self
        addressTextField.delegate = self
       // freqDestTextField.delegate = self
        //numDestLabel.text = ""
    
    }
    
    // IBAction
    @IBAction func saveProfile(_ sender: UIButton) {
//        let user = User(name: name ?? "", address: address ?? "", freqDests: destinations ?? [], news: [])
//        
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(user)
//            let jsonString = String(data: data, encoding: .utf8)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            let url = URL(string: "http://10.0.0.140:5000/user/add/\(jsonString!)")
//            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//                guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No error description")
//                    return
//                }
//                let response = String(data: data, encoding: .utf8)
//                print(response ?? "No valid response")
//            }
//            task.resume()
//        } catch {
//            print("Error encoding User to JSON")
//        }
////        MirageUser.saveUser()
//        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func goToGoogle(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.google.com/device")!)
    }
    
    @IBAction func addFreqDest(_ sender: Any) {
        self.performSegue(withIdentifier: "addFreqDest", sender: nil)
    }
    
    @IBAction func cancelNewProfile(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
//    func jsonSerializeDestinations(dests: [Destination]) -> [[String : Any]]? {
//        if (JSONSerialization.isValidJSONObject(dests)) {
//            let jsonDests = try? JSONSerialization.data(withJSONObject: dests, options: )
//        } else {
//            print("Destinations is invalid JSON")
//            return nil
//        }
//    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "addFreqDest") {
            let vc = segue.destination as! FreqDestViewController
            vc.originViewController = self
        }
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
            //freqDestTextField.becomeFirstResponder()
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
            self.name = nameTextField.text
            break
        case addressTextField:
            MirageUser.user.address = addressTextField.text
            self.address = addressTextField.text
            break
        //case freqDestTextField:
        //    MirageUser.user.addFreqDest(dest: freqDestTextField.text)
          //  break
        default:
            break
        }
    }
    
}
