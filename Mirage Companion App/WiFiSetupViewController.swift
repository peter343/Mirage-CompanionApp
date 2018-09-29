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
    @IBOutlet weak var sendSSIDButton: UIButton!
    @IBOutlet weak var sendPASSButton: UIButton!
    
    // Values for SSID and PASS TextFields
    var ssidValue = ""
    var passValue = ""
    
    // WiFi Status Value
    var wifiConnected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable Buttons
        sendSSIDButton.isEnabled = false
        sendPASSButton.isEnabled = false
        
        // Assign Delegates
        wifiSSIDTextField.delegate = self
        wifiPASSTextField.delegate = self
        
        // Enable Notifications for WiFi Status Characteristic
        miragePeripheral.setNotifyValue(true, for: wifiStatChrc)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func sendWiFiSSID(_ sender: Any) {
        
        let ssidData = ssidValue.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
        miragePeripheral.writeValue(ssidData!, for: wifiSSIDChrc, type: .withResponse)
    }
    
    @IBAction func sendWiFiPASS(_ sender: Any) {
        
        let passData = passValue.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
        miragePeripheral.writeValue(passData!, for: wifiPASSChrc, type: .withResponse)
    }
    
    
    
    
    // MARK: - Navigation
    
    // Check if WiFi has been connected yet
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return wifiConnected
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

// MARK: - Extensions

extension WiFiSetupViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error writing to characteristic: error")
            return
        }
        print("Message sent to " + characteristic.uuid.uuidString)
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
            wifiConnected = (byte != 0 ? true : false)
        }
    }
}

extension WiFiSetupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == wifiSSIDTextField) {
            sendSSIDButton.isEnabled = (string != "")
        } else {
            sendPASSButton.isEnabled = (string != "")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == wifiSSIDTextField) {
            ssidValue = textField.text ?? ""
        } else {
            passValue = textField.text ?? ""
        }
    }
}
