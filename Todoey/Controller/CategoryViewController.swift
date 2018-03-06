//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yosef Shachnovsky on 28/02/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoriesArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadadCategories()

    }
    //MARK tabel view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
         cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
        
    }
    
    //MARK data malipulation methods
    
    func save(_ category: Category) -> Void {
        do{
            try realm.write {
                realm.add(category)
            }
        }
        
        catch{
            print("eror saving items")
        }
    }
    
    func loadadCategories(){
        
        do{
            categoriesArray = realm.objects(Category.self)
        }
        catch{
            print("error requesting data")
        }
    }
    //MARK add new categories

    
    @IBAction func AddCategoryBtnPressed(_ sender: UIBarButtonItem) {
        print("in add btn")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // when the user clicks
            
            var newCategory = Category()
            
            newCategory.name = textField.text!
            
            
            self.save(newCategory)
            
            self.tableView.reloadData()
            
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new category"
            print(self)
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
