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
    var userFile: String = ""
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var currentLocation: UIButton!
    var authorized: Bool = false
    var useCurrLoc: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func useCurrLocationPressed(_ sender: Any) {
        if (!authorized) {
            locationManager.requestWhenInUseAuthorization()
        }
        getUserLocation()

    }
    
    @IBAction func nextPressed(_ sender: Any) {
        user.address = (addressField.text ?? "")
        
        // TODO: Add info to user object
        performSegue(withIdentifier: "AddressToFreqDest", sender: nil)
    }
    @IBAction func cancelPressed(_ sender: Any) {
    }
    
    func getUserLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            switch (CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! FreqDestViewController
        dest.user = self.user
        dest.userFile = self.userFile
    }
 

}

extension AddressSetupViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        print(userLocation)
        geocode(location: userLocation) { placemark, error in
            guard let place = placemark, error == nil else { return }
            DispatchQueue.main.async {
                var address = "" + (place.subThoroughfare ?? "")
                address += " " + (place.thoroughfare ?? "")
                address += " " + (place.locality ?? "")
                address += ", " + (place.administrativeArea ?? "")
                address += " " + (place.postalCode ?? "")
                self.addressField.text = address
                self.locationManager.showsBackgroundLocationIndicator = false
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Called when location manager is unable to get location one-shot
        print(error.localizedDescription)
    }
    
    func geocode(location: CLLocation, completion: @escaping (CLPlacemark?, CLError?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, (error as! CLError))
                return
            }
            completion(placemark, nil)
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print(status.rawValue)
//        if status.rawValue >= 4 {
//            authorized = true
//        }
//    }
}

extension AddressSetupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Do something with this info
    }
}
