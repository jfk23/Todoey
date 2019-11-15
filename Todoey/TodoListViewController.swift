//
//  ViewController.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/15/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Monday", "Tuesday", "Wednesday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}

