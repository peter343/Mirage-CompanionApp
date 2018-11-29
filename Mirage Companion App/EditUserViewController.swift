//
//  EditUserViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 11/4/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController {

    var userToEdit: User!
    var userNumber: Int!
    var userDict: [String : Any]!
    
    @IBOutlet weak var profileTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //userDict = getDictFromUser(user: userToEdit)
        profileTable.delegate = self
        profileTable.dataSource = self
//        profileTable.backgroundColor = UIColor.clear
//        profileTable.backgroundView = nil
        userDict = ["id" : 0,"name" : "Andrew","address" : "427 S. Chauncey Ave. West Lafayette, IN 47906","freqDest" :[Destination(name: "Work", address: "6849 Hollingsworth Dr. Indianapolis, IN 46268")],"news" : ["Business"]]
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

extension EditUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Name"
        case 1:
            return "Address"
        case 2:
            return "Facial Calibration"
        case 3:
            return "Frequent Destinations"
        case 4:
            return "News Categories"
        default:
            return nil
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch (indexPath.section) {
        case 2, 4:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch (indexPath.section) {
        case 3:
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                var temp = self.userDict["freqDest"] as! [Destination]
                temp.remove(at: indexPath.row)
                self.userDict.updateValue(temp, forKey: "freqDest")
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
                let cell = tableView.cellForRow(at: indexPath) as! EditDestinationTableViewCell
                cell.title.becomeFirstResponder()
            }
            return [edit, delete]
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0, 1:
            let cell = tableView.cellForRow(at: indexPath) as! EditProfileTableViewCell
            cell.CellTextField.becomeFirstResponder()
        case 2:
            // Handle face recalibration
            break
        case 3:
            let cell = tableView.cellForRow(at: indexPath) as! EditDestinationTableViewCell
            cell.title.becomeFirstResponder()
        case 4:
            // Handle news changes
            break
        default:
            break
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
}

extension EditUserViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return (userDict["freqDest"] as! [Destination]).count
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: indexPath) as! EditProfileTableViewCell
            cell.CellTextField.text = userDict["name"] as? String
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: indexPath) as! EditProfileTableViewCell
            cell.CellTextField.text = userDict["address"] as? String
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecalibrateCell", for: indexPath) as! RecalibrateFaceTableViewCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! EditDestinationTableViewCell
            cell.title.text = (userDict["freqDest"] as! [Destination])[indexPath.row].name
            cell.address.text = (userDict["freqDest"] as! [Destination])[indexPath.row].address
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! EditNewsTableViewCell
            cell.newsDescription.text = String((userDict["news"] as! [String]).count) + " news categories"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: indexPath) as! EditProfileTableViewCell
            cell.CellTextField.text = "Not a valid cell"
            return cell
        }
    }
    
    
}
