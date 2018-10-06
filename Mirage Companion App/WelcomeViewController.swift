//
//  WelcomeViewController.swift
//  Mirage Companion App
//
//  Created by Andrew Peterson on 9/29/18.
//  Copyright © 2018 Mirage. All rights reserved.
//

import UIKit
import CoreData

let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

class WelcomeViewController: UIViewController {
    
    // Core Data variables
    var user: NSManagedObject?
    var context: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var mirageUser = User()
    var container: NSPersistentContainer!
    
    
    // IBOutlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign Delegates
        nameField.delegate = self
        addressField.delegate = self
        
        // Check if user exists on disk
        if (MirageUser.userExistsOnDisk()) {
            
        }
        
        // Load user from Core Data
        request.returnsObjectsAsFaults = false
        
        user = mirageUser.getUser()
//        container = NSPersistentContainer(name: "Mirage-Companion-App")
        
        
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        container = appDelegate.persistentContainer
//        context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
//        user = NSManagedObject(entity: entity!, insertInto: context)
//
//        do {
//            let result = try context.fetch(request)
//            let fetchedUser = try context.fetch(request) as! [NSManagedObject]
//
//            if fetchedUser.isEmpty {
//                // Do Introduction
//            } else {
//                for data in result as! [NSManagedObject] {
//                    nameField.text = data.value(forKey: "name") as? String
//                    addressField.text = data.value(forKey: "address") as? String
//                }
//            }
//        } catch {
//            print("Failed!")
//        }
    }
    
    // IBActions
    @IBAction func savePressed(_ sender: Any) {
        mirageUser.saveUser()
//        do {
//            try context.save()
//            appDelegate.saveContext()
//            print("Saving worked? \(testSave())")
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
    }
    
    func testSave() -> Bool {
        do {
            let result = try context.fetch(request)
            let test: User = result.first as! User
            if (test.name == nil) {
                return false
            } else if (test.address == nil) {
                return false
            } else {
                return true
            }
        } catch {
            print("Failed!")
            return false
        }
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

extension WelcomeViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == nameField) {
            user?.setValue(textField.text, forKey: "name")
        } else {
            user!.setValue(textField.text, forKey: "address")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
