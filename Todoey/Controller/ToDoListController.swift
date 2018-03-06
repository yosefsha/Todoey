//
//  ViewController.swift
//  Todoey
//
//  Created by Yosef Shachnovsky on 26/02/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListController: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArray: Results<ToDoItem>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var toDoSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoSearchBar.delegate = self
        
//        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
    }


    //MARK - TableViw Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        
    cell.textLabel?.text = itemArray?[indexPath.row].content ?? "no items in category"
    cell.accessoryType = (itemArray?[indexPath.row].isDone)! ? .checkmark : .none
    
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]{
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        
                        item.isDone = !(item.isDone)
                        
                        if let cell = tableView.cellForRow(at: indexPath)  {
                            
                            cell.accessoryType = (itemArray?[indexPath.row].isDone)! ? .checkmark : .none
                            
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
//                        currentCategory.items.append(item)
                    }
                }
                catch{
                    print("error saving data")
                }

        //        self.saveItems((itemArray?[indexPath.row])!)
            }
        }
    }
    
    
    @IBAction func addItemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // when the user clicks

            print("add item text: \(textField.text!)")
            
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
        
                        let newItem = ToDoItem()
                        
                        newItem.content = textField.text!
                        newItem.isDone = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)

                    }
                }
                catch{
                    print("error saving data")
                }
        
            }


            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            print(self)
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
//    func saveItems(_ item: ToDoItem){
//
//        do {
//
//            try realm.write {
//                try realm.add(item)
//            }        }
//        catch {
//            print("error saving context")
//        }
//    }
    
    func loadItems(){
        
        do{
            itemArray = try selectedCategory?.items.sorted(byKeyPath: "content", ascending: true)
        }
        catch{
            print("error requesting data")
        }
        
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([ToDoItem].self, from: data)
//            }
//            catch{
//                print("error uploading data from plist file")
//            }
//        }
    }
    
}

extension ToDoListController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("content CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
    }
}

