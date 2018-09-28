//
//  ViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/22/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
   
    // Central Core Bluetooth Manager
    var centralManager: CBCentralManager!
    
    // Core Bluetooth Mirage Peripherals
    var miragePeripheral: CBPeripheral!
    
    // Core Bluetooth Mirage Characteristics
    var wifiStatChrc: CBCharacteristic!
    var wifiSSIDChrc: CBCharacteristic!
    var wifiPASSChrc: CBCharacteristic!
    var characteristics: [CBCharacteristic]?
    
    // View Outlets
    @IBOutlet weak var wifiNameField: UITextField!
    @IBOutlet weak var wifiPassField: UITextField!
    @IBOutlet weak var sendWifiNameButton: UIButton!
    @IBOutlet weak var sendWifiPassButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Disable send and disconnect buttons until bluetooth has been connected
        sendWifiNameButton.isEnabled = false
        sendWifiPassButton.isEnabled = false
        disconnectButton.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Buttons
    @IBAction func sendWifiName(_ sender: Any) {
        let nameData = wifiNameField.text?.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
        miragePeripheral.writeValue(nameData!, for: wifiSSIDChrc, type: .withResponse)
    }
    
    @IBAction func sendWifiPass(_ sender: Any) {
        let passData = wifiPassField.text?.data(using: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
        miragePeripheral.writeValue(passData!, for: wifiPASSChrc, type: .withResponse)
    }
    
    @IBAction func disconnectFromPi(_ sender: Any) {
        centralManager.cancelPeripheralConnection(miragePeripheral)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        let WiFiController = segue.destination as! WiFiConnectionViewController
        WiFiController.centralManager = self.centralManager
        WiFiController.miragePeripheral = self.miragePeripheral
     }
}
