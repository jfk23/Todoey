//
//  ViewController.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/15/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    //MARK: - Tableview Datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let message = todoItems?[indexPath.row].title {
            cell.textLabel?.text = message
            if let itemColor = UIColor(hexString: selectedCategory!.cellColor).darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(todoItems!.count))) {
            cell.backgroundColor = itemColor
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: itemColor, returnFlat: true)
            }
            
            
            
            cell.accessoryType = todoItems![indexPath.row].done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("cell \(indexPath.row): \(todoItems![indexPath.row])")
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item) delete method
                    item.done = !item.done
                }
            } catch {
                print ("error updating status: \(error)")
            }
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
        //saveItem()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            print ("Success")
            if alert.textFields != nil {
                for item in alert.textFields! {
                    print (item.text!)
                    
                    let newItem = Item()
                    newItem.title = item.text!
                    newItem.dateCreated = Date()
                    //let date = NSDate()
                    //newItem.dateCreated = date.timeIntervalSince1970
    
                    do{
                        try self.realm.write {
                            self.selectedCategory?.items.append(newItem)
                      }
                    } catch {
                        print("error occurs when saving: \(error)")
                    }
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
    
//    func saveItem() {
//        do {
//            try context.save()
//        } catch {
//            print ("Error saving an item to core data, \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    func loadItem() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let deletedItem = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(deletedItem)
                    //self.tableView.reloadData()
                }
            } catch {
                print ("error with deleting: \(error)")
            }

        }
    }
}

//MARK: - search bar delegate methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItem(with: request)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }


    }

}

