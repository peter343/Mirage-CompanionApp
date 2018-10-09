//
//  WelcomeScreenViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/30/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreBluetooth

class WelcomeScreenViewController: UIViewController {
    
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
    
    // IBOutlets
    @IBOutlet weak var setupProfileButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var mirageIcon: UIImageView!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var statusMessage: UILabel!
    
    
    var setupProfileTransform: CGAffineTransform!
    var editProfileTransform: CGAffineTransform!
    var mirageIconTransform: CGAffineTransform!
    var welcomeMessageTransform: CGAffineTransform!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // If there exists a profile, we can edit a profile
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        editProfileButton.isEnabled = MirageUser.userExistsOnDisk()
        
        setupProfileTransform = setupProfileButton.transform
        editProfileTransform = editProfileButton.transform
        mirageIconTransform = mirageIcon.transform
        welcomeMessageTransform = welcomeMessage.transform
        
        animateDisplayAway()
        
    }
    
    // IBActions
    @IBAction func setupButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SetupProfile", sender: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SelectProfile", sender: nil)
    }
    
    func animateDisplayTogether() {
        UIView.animate(withDuration: 0.75, delay: 1.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.mirageIcon.transform = self.mirageIconTransform
            self.setupProfileButton.transform = self.setupProfileTransform
            self.editProfileButton.transform = self.editProfileTransform
            self.welcomeMessage.transform = self.welcomeMessageTransform
            self.statusMessage.transform = self.statusMessage.transform.translatedBy(x: 0, y: self.view.frame.height)
            }, completion: nil)
    }
    
    private func animateDisplayAway() {
        
        UIView.animate(withDuration: 0, animations: { () -> Void in
            self.mirageIcon.transform = self.mirageIcon.transform.translatedBy(x: 0, y: (self.view.center.y - self.mirageIcon.center.y - (self.mirageIcon.frame.height / 2)))
            self.statusMessage.transform = self.statusMessage.transform.translatedBy(x: 0, y: (self.view.center.y - self.statusMessage.center.y - (self.statusMessage.frame.height/2)))
            self.setupProfileButton.transform = CGAffineTransform(translationX: -(self.view.frame.width), y: 0)
            self.editProfileButton.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.welcomeMessage.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        })
    }
    
    
    

    
    // MARK: - Navigation

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
             wifiSetup.origViewController = self
         } else {
         // Do any setup for next view
         }
     }
    

}

// MARK: - Extensions

extension WelcomeScreenViewController: CBCentralManagerDelegate {
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

extension WelcomeScreenViewController: CBPeripheralDelegate {
    
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
            self.animateDisplayTogether()
        } else {
            usleep(1000000)
            self.statusMessage.text = "Setting up WiFi..."
            self.performSegue(withIdentifier: "EnterWiFiSetup", sender: nil)
            
        }
    }
}
