//
//  SelectUserViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/6/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class SelectUserViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var userTable: UITableView!
    
    var userNames: [String] = []
    
    let cellID = "ProfileCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userTable.delegate = self
        userTable.dataSource = self
        userTable.tableFooterView = UIView()
        
        if (MirageUser.loadUser()) {
            userNames.append(MirageUser.user.name ?? "No name")
        }
        
        
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension SelectUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected user: \((tableView.cellForRow(at: indexPath) as! UserProfileTableViewCell).userName.text)")
        
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        self.performSegue(withIdentifier: "EditProfile", sender: nil)
        
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//    }
}

extension SelectUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserProfileTableViewCell = self.userTable.dequeueReusableCell(withIdentifier: cellID) as! UserProfileTableViewCell
        
        cell.userName.text = self.userNames[indexPath.row]
        
        return cell
    }
    
    
}
