//
//  FaceCalibrationViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/27/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class FaceCalibrationViewController: UIViewController {
    
    var user: User!
//    var calibrationFile: String!
    var num: Int = 0
    var editingProfile: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }
    
    @IBAction func startPressed(_ sender: Any) {
        
        // TODO: Send bluetooth signal to Pi to start facial calibration
//        SystemInfo.shared().startCalibration() { completed in
//            if (completed) {
//                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "CalibrationToAddress", sender: nil)
//                }
//            }
//        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! AddressSetupViewController
        dest.user = self.user
        dest.editingProfile = self.editingProfile
//        dest.userFile = self.calibrationFile
    }
    

}
