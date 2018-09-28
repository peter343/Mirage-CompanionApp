//
//  ViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/22/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreBluetooth

let wifiStatusService = CBUUID.init(string: "c30b8a67-d1a2-40e3-a407-9f126001b6cc")
let wifiStatChrcUUID = CBUUID.init(string: "43ec4c0c-6d53-44a6-ae81-a6e6518269d4")
let wifiSSIDChrcUUID = CBUUID.init(string: "1249e241-7624-4158-acd5-86226f7637c8")
let wifiPASSChrcUUID = CBUUID.init(string: "290d03b7-6e73-4e1e-ab70-ac8997cc0506")

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

// MARK: - Central Manager Delegate

extension ViewController: CBCentralManagerDelegate {
    
    // Core Bluetooth State
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
            // TODO: Notify user BT is off
        // TODO: Disable buttons
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [wifiStatusService])
        }
    }
    
    // Called when centralManager scans for peripherals with wifiStatusService
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        miragePeripheral = peripheral
        miragePeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(miragePeripheral, options: nil)
    }
    
    // Callback when connection is successful
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        disconnectButton.isEnabled = true
        miragePeripheral.discoverServices([wifiStatusService])
    }
}

// MARK: - Peripheral Delegate
extension ViewController: CBPeripheralDelegate {
    
    // Lists all discovered services from peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {return}
        for service in services {
            print(service)
            switch service.uuid {
            case wifiStatusService:
                print("Getting Characteristics for WiFiStatusService")
                peripheral.discoverCharacteristics(nil, for: service)
                break
            default:
                break
            }
        }
    }
    
    // Lists all characteristics discovered from service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        characteristics = service.characteristics
        if characteristics != nil {
            for characteristic in characteristics! {
                switch characteristic.uuid {
                case wifiStatChrcUUID:
                    let index = characteristics!.firstIndex(of: characteristic)
                    wifiStatChrc = characteristics![index!]
                    print("Got wifi Status Characteristic")
                    
                    miragePeripheral.readValue(for: wifiStatChrc)
                    
                    break
                case wifiSSIDChrcUUID:
                    let index = characteristics!.firstIndex(of: characteristic)
                    wifiSSIDChrc = characteristics![index!]
                    
                    sendWifiNameButton.isEnabled = true
                    // TODO: Call wifiSSIDChrc handler
                    print("Got wifi ssid Characteristic")
                    break
                case wifiPASSChrcUUID:
                    let index = characteristics!.firstIndex(of: characteristic)
                    wifiPASSChrc = characteristics![index!]
                    // TODO: Call wifiPASSChrc handler
                    print("Got wifi pass Characteristic")
                    break
                default:
                    break
                }
            }
            
        }
    
    }
    
    // Called when peripheral reads value from characteristic
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case wifiStatChrcUUID:
            if wifiIsConnected() {
                // Skip to next view
            } else {
                // Enable buttons and allow user to input data
            }
            
            break
        default:
            break
        }
    }
    
    // Called when peripheral writes value to characteristic
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering service: error")
            return
        }
        print("Message sent to " + characteristic.uuid.uuidString)
        
        if (characteristic.uuid == wifiSSIDChrcUUID) {
            sendWifiPassButton.isEnabled = true
        }
    }
    
    private func wifiIsConnected() -> Bool {
        // TODO: Should handle this more gracefully
        guard let characteristicData = wifiStatChrc.value, let byte = characteristicData.first else { return false }
        return byte != 0
        
    }
    
    private func wifiSSIDChrcHandler() {
        
    }
    
    private func wifiPASSChrcHandler() {
        
    }
    
}

