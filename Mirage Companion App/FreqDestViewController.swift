//
//  FreqDestViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/7/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class FreqDestViewController: UIViewController {
    
    @IBOutlet weak var destinationsTable: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var destinationEditorView: UIView!
    @IBOutlet weak var unfocusView: UIView!

    
    var myChild: DestinationEditorViewController?
    
    var destinations: [Destination] = []
    
    var originViewController: SetupProfileViewController?
    
    var selectedDestination = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // Do any additional setup after loading the view.
        destinationsTable.delegate = self
        destinationsTable.dataSource = self
        destinationsTable.tableFooterView = UIView()
        
        unfocusView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        hideEditor()
        
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        originViewController?.destinations = self.destinations
        MirageUser.user.freqDests = destinations
        self.navigationController?.popViewController(animated: true)
    }
    
    func showEditor() {
        unfocusView.isHidden = false
        destinationEditorView.isHidden = false
        
    }
    
    func hideEditor() {
        unfocusView.isHidden = true
        destinationEditorView.isHidden = true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension FreqDestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            tableView.cellForRow(at: indexPath)?.isSelected = false
            // Add destination
            showEditor()
            if (myChild != nil) {
                myChild!.willBeShown(with: nil)
            }
        } else {
            // Edit destination
            tableView.cellForRow(at: indexPath)?.isSelected = false
            showEditor()
            if (myChild != nil) {
                self.selectedDestination = indexPath.row - 1
                myChild!.willBeShown(with: destinations[indexPath.row - 1])
            }
        }
    }
}

extension FreqDestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDestinationCell") as! AddDestinationTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell") as! DestinationTableViewCell
            cell.titleLabel.text = destinations[indexPath.row - 1].name
            cell.addressLabel.text = destinations[indexPath.row - 1].address
            return cell
        }
    }
}
