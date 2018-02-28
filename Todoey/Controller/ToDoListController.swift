//
//  ViewController.swift
//  Todoey
//
//  Created by Yosef Shachnovsky on 26/02/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import UIKit


class ToDoListController: UITableViewController {
    let USER_DEFAULTS_DATA_KEY = "ToDoListArrayKey"
    var itemArray: [ToDoItem] = []
    var defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        print(dataFilePath)
        
        
//        let item1 = ToDoItem(content: "nothing to do")
//        itemArray.append(item1)
//        let item3 = ToDoItem(content: "nothing to eat")
//        itemArray.append(item3)
//        let item2 = ToDoItem(content: "nothing to drink")
//        itemArray.append(item2)
        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
    }


//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

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
            self.itemArray.append(ToDoItem(content: textField.text!, isDone: false))
            
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }
        catch {
            print("error writing file")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([ToDoItem].self, from: data)
            }
            catch{
                print("error uploading data from plist file")
            }
        }
    }
    
}

