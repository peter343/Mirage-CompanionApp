//
//  EditDestinationTableViewCell.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/4/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class EditDestinationTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var address: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title.delegate = self
        address.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension EditDestinationTableViewCell: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
//        if (textField == title) {
//            address.becomeFirstResponder()
//        }
//    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == title) {
            address.becomeFirstResponder()
        }
        return true
    }
    
}
