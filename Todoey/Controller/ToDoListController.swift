//
//  ViewController.swift
//  Todoey
//
//  Created by Yosef Shachnovsky on 26/02/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import UIKit
import CoreData

class ToDoListController: UITableViewController {
    var itemArray: [ToDoItem] = []
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var toDoSearchBar: UISearchBar!
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoSearchBar.delegate = self
        
//        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
    }


    //MARK - TableViw Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].content
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark : .none
    
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        if let cell = tableView.cellForRow(at: indexPath)  {

            cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark : .none

            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        self.saveItems()
        
    }
    
    
    @IBAction func addItemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // when the user clicks
            print("success")
            print(textField.text!)
            
            
            var newItem = ToDoItem(context: self.context)
            
            newItem.content = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            // methods to save without DB:
//            self.itemArray.append(ToDoItem(content: textField.text!, isDone: false))
            
//            self.defaults.set(self.itemArray, forKey: self.USER_DEFAULTS_DATA_KEY)
            
            self.saveItems()

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
    
    func saveItems(){
//        let encoder = PropertyListEncoder()
        
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        }
        catch {
            print("error saving context")
        }
    }
    
    func loadItems(with request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
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
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        let predicate = NSPredicate(format: "content CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortD = NSSortDescriptor(key: "content", ascending: true)
        
        request.sortDescriptors = [sortD]
        
        loadItems(with: request)
        
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

