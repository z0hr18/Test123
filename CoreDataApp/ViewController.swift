//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Samxal Quliyev  on 18.10.23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var items = [TodoList]()
    let context = AppDelegate().persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
    }
    
    func fetchItems() {
        do {
            items = try context.fetch(TodoList.fetchRequest())
            table.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveItem(text: String) {
        do {
            let model = TodoList(context: context)
            model.title = text
            try context.save()
            fetchItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(index: Int) {
        do {
            context.delete(items[index])
            try context.save()
//            fetchItems()
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func plusButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter new item", 
                                                message: "", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter new item.."
        }
        
        let okayButton = UIAlertAction(title: "Add", style: .default) { _ in
            //save data to db
            let text = alertController.textFields?[0].text ?? ""
            self.saveItem(text: text)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okayButton)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row) //items = 2
        tableView.deleteRows(at: [indexPath], with: .fade) // 2
        deleteItem(index: indexPath.row) //items = 2 => index0: item 5
//        items.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
