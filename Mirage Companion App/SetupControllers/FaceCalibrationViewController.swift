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
    var calibrationFile: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startPressed(_ sender: Any) {
        
        // TODO: Send bluetooth signal to Pi to start facial calibration
        DispatchQueue.main.async {
            self.startCalibration() { completed in
                if (completed) {
                    //self.doSegue()
                    //self.performSegue(withIdentifier: "CalibrationToAddress", sender: nil)
                }
            }
        }
        doSegue()
    }
    
    func doSegue() {
      performSegue(withIdentifier: "CalibrationToAddress", sender: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func startCalibration(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://" + ipAddr + ":5000/setup/newuser/" + calibrationFile)
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                let response = String(data: data, encoding: .utf8)
                print(response ?? "No valid response")
                if (response == "Done") {
                    completion (true)
                } else {
                    completion (false)
                }
            }
            task.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! AddressSetupViewController
        dest.user = self.user
        dest.userFile = self.calibrationFile
    }
    

}
