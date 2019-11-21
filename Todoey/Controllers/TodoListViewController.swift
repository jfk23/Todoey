//
//  ViewController.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/15/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItem()
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
                
                    let newEntry = Item(context: self.context)
                    newEntry.title = item.text!
                    newEntry.done = false
                    newEntry.parentCategory = self.selectedCategory
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
        do {
            try context.save()
        } catch {
            print ("Error saving an item to core data, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
         
        if request.sortDescriptors == nil {
        request.predicate = predicate
        }
//
        do {
            itemArray = try context.fetch(request)
        } catch
        {
            print ("error fetching data: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - search bar delegate methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request)
     
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

