//
//
//  ViewController.swift
//  Todoey
//
//  Created by Suraj on 9/26/18.
//  Copyright © 2018 GrafiOffshore Nepal. All rights reserved.
//
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
       let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilepath!)
        loadItems()
        
    }
    
    // Mark - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
       let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
          saveItem()
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }

    //Mark - Tableview Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) 
        
      
    }
    
    //Mark - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var  textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen pnce the user clicks the add item on our UI Alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
    //MARK - Model data manupulation
    
    func saveItem(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilepath!)
            
        } catch {
            print("Error")
        }
    }
    
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilepath!){
            
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error \(error)")
            }
            
        }
    }
    

}

