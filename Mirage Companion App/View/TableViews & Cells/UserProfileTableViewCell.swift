//
//  UserProfileTableViewCell.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/6/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
