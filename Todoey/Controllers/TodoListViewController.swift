//
//  ViewController.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/15/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Monday"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Tuesday"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Wednesday"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "TodoArray") as? [Item] {
            itemArray = items
        }
        
    }

    //MARK: - Tableview Datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let message = itemArray[indexPath.row].title
        cell.textLabel?.text = message
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("cell \(indexPath.row): \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            print ("Success")
            if alert.textFields != nil {
                for item in alert.textFields! {
                    print (item.text!)
                    
                    let newEntry = Item()
                    newEntry.title = item.text!
                    self.itemArray.append(newEntry)
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

