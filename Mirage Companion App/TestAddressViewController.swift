//
//  TestAddressViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/29/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class TestAddressViewController: UIViewController {

    @IBOutlet weak var StreetField: UITextField!
    @IBOutlet weak var CityField: UITextField!
    @IBOutlet weak var StateField: UITextField!
    @IBOutlet weak var ZipField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StreetField.delegate = self
        CityField.delegate = self
        StateField.delegate = self
        ZipField.delegate = self
        
        setupViewForAddress(address: "427 S Chauncey Ave West Lafayette, IN 47906")
        // Do any additional setup after loading the view.
    }
    
    func setupViewForAddress(address: String) {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
        let matches = detector.matches(in: address, options: [], range: NSRange(location: 0, length: address.utf16.count))
        
        var resultsArray =  [[NSTextCheckingKey : String]]()
        // put matches into array of Strings
        for match in matches {
            if match.resultType == .address,
                let components = match.addressComponents {
                resultsArray.append(components)
            } else {
                print("no components found")
            }
        }
        if (resultsArray[0][NSTextCheckingKey.street] != nil) {
            StreetField.text = resultsArray[0][NSTextCheckingKey.street]
        }
        if (resultsArray[0][NSTextCheckingKey.city] != nil) {
            CityField.text = resultsArray[0][NSTextCheckingKey.city]
        }
        if (resultsArray[0][NSTextCheckingKey.state] != nil) {
            StateField.text = resultsArray[0][NSTextCheckingKey.state]
        }
        if (resultsArray[0][NSTextCheckingKey.zip] != nil) {
            ZipField.text = resultsArray[0][NSTextCheckingKey.zip]
        }
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

extension TestAddressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField) {
        case StreetField:
            textField.resignFirstResponder()
            CityField.becomeFirstResponder()
            break
        case CityField:
            textField.resignFirstResponder()
            StateField.becomeFirstResponder()
            break
        case StateField:
            textField.resignFirstResponder()
            ZipField.becomeFirstResponder()
            break
        case ZipField:
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "") {
            return true
        }
        switch (textField) {
        case StateField:
            return !((StateField.text?.count)! > 1)
        case ZipField:
            print(ZipField.text?.count)
            return !((ZipField.text?.count)! > 4)
        default:
            return true
        }
    }
    
}
