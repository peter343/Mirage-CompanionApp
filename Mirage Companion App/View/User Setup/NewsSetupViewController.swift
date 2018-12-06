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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsCats = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        newsCats = user.newsCategories
        
        businessSwitch.isOn = user.newsCategories.contains("business")
        entertainSwitch.isOn = user.newsCategories.contains("enterainment")
        healthSwitch.isOn = user.newsCategories.contains("health")
        scienceSwitch.isOn = user.newsCategories.contains("science")
        sportsSwitch.isOn = user.newsCategories.contains("sports")
        techSwitch.isOn = user.newsCategories.contains("technology")
        
    }
    
    @IBAction func switchSwitched(_ sender: UISwitch) {
        switch sender {
        case businessSwitch:
            if businessSwitch.isOn {
                newsCats.append("business")
            } else {
                if let index = newsCats.firstIndex(of: "business") {
                    newsCats.remove(at: index)
                }
            }

        case entertainSwitch:
            if entertainSwitch.isOn {
                newsCats.append("entertainment")
            } else {
                if let index = newsCats.firstIndex(of: "entertainment") {
                    newsCats.remove(at: index)
                }
            }
            
        case healthSwitch:
            if healthSwitch.isOn {
                newsCats.append("health")
            } else {
                if let index = newsCats.firstIndex(of: "health") {
                    newsCats.remove(at: index)
                }
            }

        case scienceSwitch:
            if scienceSwitch.isOn {
                newsCats.append("science")
            } else {
                if let index = newsCats.firstIndex(of: "science") {
                    newsCats.remove(at: index)
                }
            }

        case sportsSwitch:
            
            if sportsSwitch.isOn {
                newsCats.append("sports")
            } else {
                if let index = newsCats.firstIndex(of: "sports") {
                    newsCats.remove(at: index)
                }
            }

        case techSwitch:
            if techSwitch.isOn {
                newsCats.append("technology")
            } else {
                if let index = newsCats.firstIndex(of: "technology") {
                    newsCats.remove(at: index)
                }
            }

        default:
            break
        }
        newsCats.sort()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        user.newsCategories = newsCats
        
        performSegue(withIdentifier: "NewsToCalendar", sender: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        print("Going back")
        self.navigationController?.popViewController(animated: true)
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
    }
    

}
