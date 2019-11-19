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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print (dataFilePath)
        
        loadItem()
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
        
        saveItem()
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
                    //self.defaults.set(self.itemArray, forKey: "TodoArray")
                    
                    self.saveItem()
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
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        } catch {
            print ("Error encoding tiem array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItem() {
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([Item].self, from: data)
        
        } catch {
            print ("error in decoding from data: \(error)")
        }
    }
}

