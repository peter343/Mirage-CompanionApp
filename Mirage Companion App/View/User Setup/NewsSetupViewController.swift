//
//  NewsSetupViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 10/27/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit

class NewsSetupViewController: UIViewController {
    
    var user: User!
    var newsCats: [String] = []
    var editingProfile: Bool = false
    
    @IBOutlet weak var businessSwitch: UISwitch!
    @IBOutlet weak var entertainSwitch: UISwitch!
    @IBOutlet weak var healthSwitch: UISwitch!
    @IBOutlet weak var scienceSwitch: UISwitch!
    @IBOutlet weak var sportsSwitch: UISwitch!
    @IBOutlet weak var techSwitch: UISwitch!
    
//    var userFile: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        newsCats = ["business", "entertainment", "health", "science", "sports", "technology"]
    }
    
    @IBAction func switchSwitched(_ sender: UISwitch) {
        switch sender {
        case businessSwitch:
            if let index = newsCats.firstIndex(of: "business") { newsCats.remove(at: index) }
            else { newsCats.append("business") }
        case entertainSwitch:
            if let index = newsCats.firstIndex(of: "entertainment") { newsCats.remove(at: index) }
            else { newsCats.append("entertainment") }
        case healthSwitch:
            if let index = newsCats.firstIndex(of: "health") { newsCats.remove(at: index) }
            else { newsCats.append("health") }
        case scienceSwitch:
            if let index = newsCats.firstIndex(of: "science") { newsCats.remove(at: index) }
            else { newsCats.append("science") }
        case sportsSwitch:
            if let index = newsCats.firstIndex(of: "sports") { newsCats.remove(at: index) }
            else { newsCats.append("sports") }
        case techSwitch:
            if let index = newsCats.firstIndex(of: "technology") { newsCats.remove(at: index) }
            else { newsCats.append("technology") }
        default:
            break
        }
        newsCats.sort()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        user.newsCategories = newsCats
        performSegue(withIdentifier: "NewsToCalendar", sender: nil)
    }
    @IBAction func cancelPressed(_ sender: Any) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! CalendarSetupViewController
        dest.user = self.user
        dest.editingProfile = self.editingProfile
//        dest.userFile = self.userFile
    }
    

}
