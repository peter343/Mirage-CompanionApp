//
//  SelectUserViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/6/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

//typealias QueryResult = ([User]?, String) -> ()
//typealias JSONDictionary = [String : Any]

class SelectUserViewController: UIViewController {
    
    let defaultsession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage: String = ""
    var users: [Int : User] = [:]

    // IBOutlets
    @IBOutlet weak var userTable: UITableView!
    
//    var userNames: [String] = []
    
    let cellID = "ProfileCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userTable.delegate = self
        userTable.dataSource = self
        userTable.tableFooterView = UIView()
        
        users = SystemInfo.shared().getUsers()
        users = [0: User(id: 0, name: "Andrew", address: "427 S. Chauncey Ave. West Lafayette, IN 47906", freqDests: [Destination(name: "Work", address: "6849 Hollingsworth Dr. Indianapolis, IN 46268")], news: ["Business"])]
    }

    
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "EditProfile") {
            let dest = segue.destination as? NameSetupViewController
            dest?.editingProfile = true
            dest?.user = users[(self.userTable.indexPathForSelectedRow?.row)!]
//            let vc = segue.destination as? EditProfileViewController
//            vc!.userToEdit = (sender as? [Int : User])?.first?.value
//            vc!.userNumber = (sender as? [Int : User])?.first?.key
        }
        
    }
    

}

extension SelectUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)s
        self.performSegue(withIdentifier: "EditProfile", sender: self.users[indexPath.row])
    }
}

extension SelectUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserProfileTableViewCell = self.userTable.dequeueReusableCell(withIdentifier: cellID) as! UserProfileTableViewCell
        
        cell.userName.text = self.users[indexPath.row]?.name
        
        return cell
    }
    
    
}
