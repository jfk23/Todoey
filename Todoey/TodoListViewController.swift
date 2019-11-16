//
//  ViewController.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/15/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Monday", "Tuesday", "Wednesday"]
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoArray") as? [String] {
            itemArray = items
        }
        
    }

    //MARK: - Tableview Datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let message = itemArray[indexPath.row]
        cell.textLabel?.text = message
        
        return cell
    }
    
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("cell \(indexPath.row): \(itemArray[indexPath.row])")
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            print ("Success")
            if alert.textFields != nil {
                for item in alert.textFields! {
                    print (item.text!)
                    self.itemArray.append(item.text!)
                    self.defaults.set(self.itemArray, forKey: "TodoArray")
                    self.tableView.reloadData()
                }
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print("alert pop-up!")
        }
        
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

