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
    var itemArray: [String] = []
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: USER_DEFAULTS_DATA_KEY) as? [String] {
            itemArray = items
        }// Do any additional setup after loading the view, typically from a nib.
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
    
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath)  {
                print(cell)
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    
    @IBAction func addItemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // when the user clicks
            print("success")
            print(textField.text)
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: self.USER_DEFAULTS_DATA_KEY)
            
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
    
}

