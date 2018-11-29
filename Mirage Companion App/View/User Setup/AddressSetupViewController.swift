//
//  AddressSetupViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/27/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreLocation

class AddressSetupViewController: UIViewController {

    var locationManager: CLLocationManager = CLLocationManager()
    var user: User!
    var activityView: ActivityViewController?
    var doneGettingLocation: Bool = false
    
    
//    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var StreetField: UITextField!
    @IBOutlet weak var CityField: UITextField!
    @IBOutlet weak var StateField: UITextField!
    @IBOutlet weak var ZipField: UITextField!
    @IBOutlet weak var currentLocation: UIButton!
    var authorized: Bool = false
    var useCurrLoc: Bool = false
    
    var editingProfile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addressField.delegate = self
        StreetField.delegate = self
        CityField.delegate = self
        StateField.delegate = self
        ZipField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (editingProfile) {
//            addressField.text = user.address
            doneGettingLocation = true
        }
    }
    
    @IBAction func useCurrLocationPressed(_ sender: Any) {
        if (!authorized) {
            locationManager.requestWhenInUseAuthorization()
        }
        getUserLocation()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
//        user.address = (addressField.text ?? "")
        performSegue(withIdentifier: "AddressToFreqDest", sender: nil)
    }
    @IBAction func cancelPressed(_ sender: Any) {
    
    }
    
    func getUserLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            switch (CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                activityView = ActivityViewController(message: "Calculating Address...")
                self.doneGettingLocation = false
                self.present(activityView!, animated: true, completion: nil)
                locationManager.showsBackgroundLocationIndicator = true
                locationManager.requestLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // TODO: Replace with check if valid location
        return (doneGettingLocation || user.address != "")
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! FreqDestViewController
        dest.user = self.user
        dest.editingProfile = self.editingProfile
//        dest.userFile = self.userFile
    }
}
