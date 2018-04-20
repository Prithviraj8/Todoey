//  ViewController.swift
//  Todoey
//
//  Created by ts krishna on 03/04/18.
//  Copyright © 2018 Prithviraj. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
         let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory , in: .userDomainMask))
        
     //   print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy eggoes"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demorgorgan"
//        itemArray.append(newItem3)
        
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]   {//? refers to optional type.
//            itemArray = items
//
//        }
        // Do any additional setup after loading the view, typically from a nib.

        
    }

 //MARK  - Table Datasouce Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        //Creating a reusable cell.Here we use the global variable (L) tableView
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator ==>
        //Value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        //==================OR============ the next few if statements.
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        
        //Toggling the done property for the checkmark i.e. we're toggling the checkmark.
        //We're checking the done property of each element that is selected
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()

            
        
         ///// =================OR==================
//        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//
//        }

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Action", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //print(textField.text)
            
           // let newItem = Item()    -----we used this when we were using the Item class.
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            newItem.parentCategory = self.selectedCategory
            self.saveItems()
}
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
       // let encoder = PropertyListEncoder()

        do {
//            let data = try encoder.encode(itemArray) //Use of try handles the exception thrown by NSEncoder (PropertListEncoder)
//            try data.write(to: dataFilePath!)
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            try context.save()
            
        } catch {
            print("Error saving context , \(error)")
        }
        
        //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
        
        tableView.reloadData()//Reloads the app and the array and add the new item.
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        if  let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch {
//                print("Error \(error)")
//            }
//
//    }
//let request: NSFetchRequest<Item> = Item.fetchRequest() we don't have to inittialze a request anymore because we are calling in within the function parameters.
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
        request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
  //      request.predicate = compoundPredicate
        
        do{
            itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }

    }
    
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        print(predicate)
        
        request.predicate = predicate
        
        let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)
        //request.sortDescriptors = [sortDescriptor]
        
//        do{
//            itemArray = try context.fetch(request)
//        }catch {
//            print("Error fetching data from context \(error)")
//        }
        
       // tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
    
}
















