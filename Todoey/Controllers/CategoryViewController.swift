//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ts krishna on 18/04/18.
//  Copyright © 2018 Prithviraj. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var CategoryArray: Results<Category>?
    
   // var defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL)

        loadCategories()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return CategoryArray?.count ?? 1   //This way of using ? , is called the Nil Coalesing Operator. If the the count is nil then the coalesing operator will return 1 row and the default text for that is the the tableView function below.
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" , for: indexPath)

        //let category = CategoryArray[indexPath.row].name
        
        cell.textLabel?.text = CategoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    

    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = CategoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let CategoryArray = realm.objects(Category.self)
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do{
//           CategoryArray = try context.fetch(request)
//        }catch {
//            print("Error fetching data from context \(error)")
//        }
//        
         tableView.reloadData()

    }
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
         
            let newCategory = Category()
            newCategory.name = textField.text!
           // self.CategoryArray.append(newCategory)
            //The resuls datatype is an auto updating container therefore we don't need to append anything .
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)

        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new Category"
            
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}



















