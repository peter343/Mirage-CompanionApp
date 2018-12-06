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
    var num: Int = 0
    var editingProfile: Bool = false
    @IBOutlet weak var nextButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nextButton?.isHidden = !editingProfile
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        print("Skipping Face Calibration")
        self.performSegue(withIdentifier: "CalibrationToAddress", sender: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        print("Going back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startPressed(_ sender: Any) {
        print("Starting face Calibration")
        SystemInfo.shared().startCalibration() { completed in
            if (completed) {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "CalibrationToAddress", sender: nil)
                }
            }
        }
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
    }
    

}
