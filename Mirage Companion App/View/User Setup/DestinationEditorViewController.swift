//
//  DestinationEditorViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/7/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class DestinationEditorViewController: UIViewController {
    
    @IBOutlet weak var destNameLabel: UITextField!
    @IBOutlet weak var destAddressLabel: UITextField!
    var myParent: FreqDestViewController?
    var editingDest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        destNameLabel.delegate = self
        destAddressLabel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myParent = self.parent as? FreqDestViewController
        myParent?.myChild = self
    }
    
    func willBeShown(with destination: Destination?) {
        if (destination != nil) {
            editingDest = true
            self.destNameLabel.text = destination?.name
            self.destAddressLabel.text = destination?.address
        }
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        //TODO: Check inputs
        if (editingDest) {
            myParent?.destinations[(myParent?.selectedDestination)!].name = self.destNameLabel.text ?? ""
            myParent?.destinations[(myParent?.selectedDestination)!].address = self.destAddressLabel.text ?? ""
            myParent?.destinationsTable.reloadData()
        } else {
            let newDest = Destination(name: self.destNameLabel.text!, address: self.destAddressLabel.text!)
            myParent?.destinations.append(newDest)
            myParent?.destinationsTable.reloadData()
        }
        myParent?.hideEditor()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        myParent?.hideEditor()
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

extension DestinationEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case destNameLabel:
            textField.resignFirstResponder()
            destAddressLabel.becomeFirstResponder()
            break
        case destAddressLabel:
            textField.resignFirstResponder()
            break
        default:
            textField.resignFirstResponder()
            break
        }
        return true
    }
}
