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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = userTable.indexPathForSelectedRow {
            userTable.deselectRow(at: index, animated: false)
        }
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
