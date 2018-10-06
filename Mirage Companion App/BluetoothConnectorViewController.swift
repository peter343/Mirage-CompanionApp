//
//  BluetoothConnectorViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/29/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothConnectorViewController: UIViewController {
    
    // Central Core Bluetooth Manager
    var centralManager: CBCentralManager!
    
    // Core Bluetooth Mirage Peripherals
    var miragePeripheral: CBPeripheral?
    
    // Core Bluetooth Mirage Characteristics
    var wifiStatChrc: CBCharacteristic?
    var wifiSSIDChrc: CBCharacteristic?
    var wifiPASSChrc: CBCharacteristic?
    
    // WiFi Status Value
    var wifiConnected: Bool = false
    
    //var activityView = ActivityViewController(message: "Looking for Mirage...")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //activityView.view.frame.origin = CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        //view.addSubview(activityView.view)
       
    }
    
 
    
    // MARK: - Navigation
    
    // Check characteristics are not nil before entering WiFiSetup
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if (identifier == "SkipWiFiSetup") {
            return true
        }
        return miragePeripheral != nil && wifiSSIDChrc != nil && wifiPASSChrc != nil
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "EnterWiFiSetup") {
            let wifiSetup = segue.destination as! WiFiSetupViewController
            wifiSetup.centralManager = centralManager
            wifiSetup.miragePeripheral = miragePeripheral
            wifiSetup.wifiStatChrc = wifiStatChrc
            wifiSetup.wifiSSIDChrc = wifiSSIDChrc
            wifiSetup.wifiPASSChrc = wifiPASSChrc
        } else {
            // Do any setup for next view
        }
        
        
    }
}

// MARK: - Extensions

extension BluetoothConnectorViewController: CBCentralManagerDelegate {
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
        case .poweredOn:
            print("central.state is .poweredOn")
            
            if (centralManager.retrieveConnectedPeripherals(withServices: [wifiStatusService]).isEmpty) {
                centralManager.scanForPeripherals(withServices: [wifiStatusService], options: nil)
            } else {
                miragePeripheral = centralManager.retrieveConnectedPeripherals(withServices: [wifiStatusService])[0]
                miragePeripheral?.delegate = self
                centralManager.connect(miragePeripheral!, options: nil)
            }
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Found Mirage")
        miragePeripheral = peripheral
        miragePeripheral!.delegate = self
        centralManager.stopScan()
        centralManager.connect(miragePeripheral!, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Did connect")
        miragePeripheral!.discoverServices([wifiStatusService])
        //self.activityView.view.removeFromSuperview()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Could not connect: \(error?.localizedDescription ?? "No error")")
    }
}

extension BluetoothConnectorViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if (service.uuid == wifiStatusService) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            
            switch characteristic.uuid {
            case wifiStatChrcUUID:
                print("Found wifi Stat Chrc")
                wifiStatChrc = characteristic
            case wifiSSIDChrcUUID:
                print("Found wifi ssid Chrc")
                wifiSSIDChrc = characteristic
            case wifiPASSChrcUUID:
                print("Found wifi pass Chrc")
                wifiPASSChrc = characteristic
            default:
                break
            }
            
        }
        if (wifiStatChrc != nil) {
            miragePeripheral?.readValue(for: wifiStatChrc!)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let characteristicData = wifiStatChrc!.value, let byte = characteristicData.first else { return }
        wifiConnected = (byte != 0 ? true : false)
        if (wifiConnected) {
            self.performSegue(withIdentifier: "SkipWiFiSetup", sender: nil)
        } else {
            self.performSegue(withIdentifier: "EnterWiFiSetup", sender: nil)
        }
    }
}
