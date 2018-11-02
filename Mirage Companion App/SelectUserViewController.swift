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
    
    var userNames: [String] = []
    
    let cellID = "ProfileCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userTable.delegate = self
        userTable.dataSource = self
        userTable.tableFooterView = UIView()
        
        DispatchQueue.main.async {
            self.getNumUsers() { _ in
                //print(response)
            }
        }
    }

    
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func getNumUsers(completion: @escaping ([Int : User]) -> Void) {
        let url = URL(string: "http://" + ipAddr + ":5000/user/getnum")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error: No description")
                return
            }
            let response = String(data: data, encoding: .utf8)
            for i in 0 ..< Int(response ?? "0")! {
                self.getUser(userNum: i) { _ in
                    DispatchQueue.main.async {
                        self.userTable.reloadData()
                    }
                }
            }
            completion(self.users)
        }
        task.resume()
        
    }
    
    func getUser(userNum: Int, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "http://" + ipAddr + ":5000/user/get/\(userNum)")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Error: No description")
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonData = jsonData as? [String : Any] {
                    if let user = getUserFromJSON(json: jsonData) {
                        self.users.updateValue(user, forKey: userNum)
                        completion(true)
                    }
                    completion(false)
                }
                completion(false)
                
            } catch {
                print("Unable to read User as JSON")
                return
            }
        }
        task.resume()
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "EditProfile") {
            let vc = segue.destination as? EditProfileViewController
            vc!.userToEdit = (sender as? [Int : User])?.first?.value
            vc!.userNumber = (sender as? [Int : User])?.first?.key
        }
        
    }
    

}

extension SelectUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
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
