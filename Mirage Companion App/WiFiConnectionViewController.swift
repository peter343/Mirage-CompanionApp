//
//  WiFiConnectionViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/24/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreBluetooth

class WiFiConnectionViewController: UIViewController {
    
    var centralManager: CBCentralManager!
    var miragePeripheral: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (centralManager != nil) {
            print("passed")
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
