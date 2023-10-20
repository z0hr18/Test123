//
//  RealmController.swift
//  CoreDataApp
//
//  Created by Samxal Quliyev  on 20.10.23.
//

import UIKit
import RealmSwift

class TodoListRealm: Object {
    @Persisted var title: String = ""
}

class RealmController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var items = [TodoListRealm]()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = realm.configuration.fileURL {
            print(url)
        }
        
        fetchItems()
    }
    
    func fetchItems() {
        let data = realm.objects(TodoListRealm.self)
        items.removeAll()
        items.append(contentsOf: data)
        table.reloadData()
    }
    
    func saveItem(text: String) {
        let item = TodoListRealm()
        item.title = text
        do {
            try realm.write {
                realm.add(item)
//                fetchItems()
                items.append(item)
//                table.reloadData()
                table.insertRows(at: [IndexPath(row: items.count-1, section: 0)], with: .fade)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
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

extension RealmController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
}
