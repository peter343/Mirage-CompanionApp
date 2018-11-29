//
//  SelectUserViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/6/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class SelectUserViewController: UIViewController {

    var errorMessage: String = ""
    var users: [Int : User] = [:]

    @IBOutlet weak var userTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTable.delegate = self
        userTable.dataSource = self
        userTable.tableFooterView = UIView()
        
        users = SystemInfo.shared().getUsers()
//        users = [0: User(id: 0, name: "Andrew", address: "427 S. Chauncey Ave. West Lafayette, IN 47906", freqDests: [Destination(name: "Work", address: "6849 Hollingsworth Dr. Indianapolis, IN 46268")], news: ["Business"])]
    }

    
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditProfile") {
            let dest = segue.destination as? NameSetupViewController
            dest?.editingProfile = true
            dest?.user = users[(self.userTable.indexPathForSelectedRow?.row)!]
        }
    }
}

extension SelectUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditProfile", sender: self.users[indexPath.row])
    }
}

extension SelectUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserProfileTableViewCell = self.userTable.dequeueReusableCell(withIdentifier: "ProfileCell") as! UserProfileTableViewCell
        
        cell.userName.text = self.users[indexPath.row]?.name
        
        return cell
    }
    
    
}
