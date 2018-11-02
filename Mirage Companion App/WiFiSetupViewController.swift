//
//  WiFiSetupViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/29/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreBluetooth

class WiFiSetupViewController: UIViewController {
    
    var origViewController: UIViewController!
    
    // Central Core Bluetooth Manager
    var centralManager: CBCentralManager!
    
    // Core Bluetooth Mirage Peripherals
    var miragePeripheral: CBPeripheral!
    
    // Core Bluetooth Mirage Characteristics
    var wifiStatChrc: CBCharacteristic!
    var wifiSSIDChrc: CBCharacteristic!
    var wifiPASSChrc: CBCharacteristic!
    
    // IBOutlets
    @IBOutlet weak var wifiSSIDTextField: UITextField!
    @IBOutlet weak var wifiPASSTextField: UITextField!
    @IBOutlet weak var sendWiFiInfo: UIButton!
    
    // Values for SSID and PASS TextFields
    var ssidValue = ""
    var passValue = ""
    
    // WiFi Status Value
    var wifiConnected: Bool = false
    var shouldReceiveUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign Delegates
        wifiSSIDTextField.delegate = self
        wifiPASSTextField.delegate = self
        miragePeripheral.delegate = self
        
        // Enable Notifications for WiFi Status Characteristic
        miragePeripheral.setNotifyValue(true, for: wifiStatChrc)
        
        print(wifiStatChrc)
        print(wifiSSIDChrc)
        print(wifiPASSChrc)
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func sendWiFiInfo(_ sender: Any) {
        if (ssidValue == "" || passValue == "") {
            // Tell user to enter information
            print("No information")
        } else {
            print("Trying to send ssid")
            let ssidData = ssidValue.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            miragePeripheral.writeValue(ssidData!, for: wifiSSIDChrc, type: .withResponse)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
    }
}



// MARK: - Extensions

extension WiFiSetupViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error writing to characteristic: error")
            return
        }
        
        if (characteristic == wifiSSIDChrc) {
            print("Trying to write characteristic")
            let passData = passValue.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            miragePeripheral.writeValue(passData!, for: wifiPASSChrc, type: .withResponse)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error enabling notification for wifiStatus")
            // Should show alert
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error receiving notification for characteristic: error")
            return
        }
        
        if (characteristic == wifiStatChrc) {
            guard let characteristicData = wifiStatChrc!.value, let byte = characteristicData.first else { return }
            if (byte != 0 && shouldReceiveUpdate) {
                (origViewController as! WelcomeScreenViewController).animateDisplayTogether()
                shouldReceiveUpdate = false
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
}

extension WiFiSetupViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == wifiSSIDTextField) {
            ssidValue = textField.text ?? ""
        } else {
            passValue = textField.text ?? ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == wifiSSIDTextField) {
            wifiPASSTextField.becomeFirstResponder()
        }
        return true
    }
}
