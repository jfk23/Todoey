//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/20/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeController {
//class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var catArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray?.count ?? 1
    }

//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
       // cell.delegate = self
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let message = catArray?[indexPath.row].name ?? "No Category added yet"
        cell.textLabel?.text = message
        cell.backgroundColor = UIColor(hexString: catArray?[indexPath.row].cellColor)


        return cell

    }
    
    //MARK: - data manipulation methods
    
    func save(category: Category) {
          do{
            try realm.write {
                realm.add(category)
            }
          } catch {
              print("error occurs when saving: \(error)")
          }
          tableView.reloadData()
      }
      
      func loadCategory() {
        
        catArray = realm.objects(Category.self)
        
          tableView.reloadData()
      }
    
    override func updateModel(at indexPath: IndexPath) {

        if let deletedCategory = catArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(deletedCategory)
                    //self.tableView.reloadData()
                }
            } catch {
                print ("error with deleting: \(error)")
            }

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
    
    //MARK: - Add new category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (alertaction) in
            if alert.textFields != nil {
                for item in alert.textFields! {
                    let newCategory = Category()
                    let randomColor = UIColor.randomFlat()
                    newCategory.name = item.text!
                    newCategory.cellColor = (randomColor?.hexValue()) ?? "#ffffff"
                    
                    self.save(category:newCategory)
                }
            }
        }
        
        alert.addTextField { (alertText) in
            alertText.placeholder = "ex) Shopping, Cleaning"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
  
    
     //MARK: - Tableview Delegate methods
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           //print ("cell \(indexPath.row): \(catArray[indexPath.row])")
           //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
           
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let path = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray?[path.row]
            //print ("let's print selected cell: \(catArray?[path.row])")
        } else {
            print ("What's going on???")
        }
    }
      
       // Override to support conditional editing of the table view.
       override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }
    
}


