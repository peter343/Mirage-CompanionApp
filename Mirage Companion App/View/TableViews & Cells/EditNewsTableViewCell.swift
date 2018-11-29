//
//  EditNewsTableViewCell.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/4/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class EditNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsDescription: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
