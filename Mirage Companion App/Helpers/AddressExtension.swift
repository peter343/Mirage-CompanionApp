//
//  AddressExtension.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/2/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension AddressSetupViewController {
    
    func setupViewForAddress(address: String) {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
        let matches = detector.matches(in: address, options: [], range: NSRange(location: 0, length: address.utf16.count))
        
        var resultsArray =  [[NSTextCheckingKey : String]]()
        // put matches into array of Strings
        for match in matches {
            if match.resultType == .address,
                let components = match.addressComponents {
                resultsArray.append(components)
            } else {
                print("no components found")
            }
        }
        
        if (resultsArray[0][NSTextCheckingKey.street] != nil) {
            StreetField.text = resultsArray[0][NSTextCheckingKey.street]
        }
        if (resultsArray[0][NSTextCheckingKey.city] != nil) {
            CityField.text = resultsArray[0][NSTextCheckingKey.city]
        }
        if (resultsArray[0][NSTextCheckingKey.state] != nil) {
            StateField.text = resultsArray[0][NSTextCheckingKey.state]
        }
        if (resultsArray[0][NSTextCheckingKey.zip] != nil) {
            ZipField.text = resultsArray[0][NSTextCheckingKey.zip]
        }
    }
    
    func getAddressFromView() -> String? {
        var address = ""
        guard StreetField.text != "", CityField.text != "", StateField.text != "", ZipField.text != "" else {
            return nil
        }
        address = StreetField.text! + " " + CityField.text! + ", " + StateField.text! + " " + ZipField.text!
        return address
    }
}

extension AddressSetupViewController: UITextFieldDelegate {
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        // TODO: Do something with this info
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField) {
        case StreetField:
            textField.resignFirstResponder()
            CityField.becomeFirstResponder()
            break
        case CityField:
            textField.resignFirstResponder()
            StateField.becomeFirstResponder()
            break
        case StateField:
            textField.resignFirstResponder()
            ZipField.becomeFirstResponder()
            break
        case ZipField:
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "") {
            return true
        }
        switch (textField) {
        case StateField:
            return !((StateField.text?.count)! > 1)
        case ZipField:
            return !((ZipField.text?.count)! > 4)
        default:
            return true
        }
    
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
//                address += " " + (place.locality ?? "")
//                address += ", " + (place.administrativeArea ?? "")
//                address += " " + (place.postalCode ?? "")
//                self.addressField.text = address
                self.StreetField.text = address
                self.CityField.text = place.locality ?? ""
                self.StateField.text = place.administrativeArea ?? ""
                self.ZipField.text = place.postalCode ?? ""
                self.locationManager.showsBackgroundLocationIndicator = false
                self.activityView!.dismiss(animated: true, completion: nil)
                self.doneGettingLocation = true
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
                self.doneGettingLocation = false
                return
            }
            completion(placemark, nil)
        }
    }
    
//    func checkAddress(address: String, completion: @escaping (Bool) -> Void) {
//        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
//            guard let placemarks = placemarks, error == nil else {
//                completion(false)
//                return
//            }
//            
//            
//        }
//        
//    }
}
