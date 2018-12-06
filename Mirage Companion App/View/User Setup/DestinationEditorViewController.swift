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
//    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var myParent: FreqDestViewController?
    var editingDest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        destNameLabel.delegate = self
        destAddressLabel.delegate = self
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
    
//    @objc func keyboardNotification(notification: Notification) {
//        if let userInfo = notification.userInfo {
//            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let endFrameY = endFrame?.origin.y ?? 0
//            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
//            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
//            if endFrameY >= UIScreen.main.bounds.size.height {
//                self.keyboardHeightLayoutConstraint?.constant = 0.0
//            } else {
//                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
//            }
//            UIView.animate(withDuration: duration,
//                           delay: TimeInterval(0),
//                           options: animationCurve,
//                           animations: { self.view.layoutIfNeeded() },
//                           completion: nil)
//        }
//    }
    
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
