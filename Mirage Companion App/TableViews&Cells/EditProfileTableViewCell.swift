//
//  EditProfileTableViewCell.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/4/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var CellTextField: UITextField!
    var selectedBySwipe: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CellTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension EditProfileTableViewCell: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return selectedBySwipe
//    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
//    }
    
    
}
