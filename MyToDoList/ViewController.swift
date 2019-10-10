//
//  ViewController.swift
//  MyToDoList
//
//  Created by Feruza Atahodjaeva on 10/10/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
   
    var items = [Items]()
    var names = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New List", message: "Add New Item", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            (action) in
            let textField = alert.textFields![0]
            self.saveName(name: textField.text!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return items.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let item = items[indexPath.row]
        
        cell!.textLabel!.text = item.value(forKey: "name") as! String
        
        return cell!
        
       }
    
    func saveName(name:String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Items(entity: Items.entity(), insertInto: context)
        
        item.setValue(name, forKey: "name")
        do {
            try context.save()
            items.append(item)
        }
        catch let error as NSError {
        print("Don't save error!\(error.userInfo)")
    }
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let result = try context.fetch(Items.fetchRequest())
            items = result as! [Items]
            
        } catch let error as NSError {
            print("Don't save erro!\(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            context.delete(items[indexPath.row])
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                 items = try context.fetch(Items.fetchRequest())
            } catch let error as NSError {
                print("Don't save erro!\(error.userInfo)")
            }
            
            tableView.reloadData()
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "List of Items"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }


}

