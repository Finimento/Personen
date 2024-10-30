//
//  ViewController.swift
//  Personen
//
//  Created by Mike Finimento on 16.10.24.
//

import UIKit

class ViewController: UIViewController {
    
    
    var persons = Person.loadPersons()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Personen.plist")
    
    //MARK: -Outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: -UserDefaults
    
    //let defaults = UserDefaults.standard
    //let personsArrayKey = "PersonsArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        //if let _persons = defaults.array(forKey: personsArrayKey) as? [Person]{
        //    persons = _persons
        //}
        
        loadPersons()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        title = "Personen"
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    //MARK: - Edit persons row
    override func setEditing(_ editing: Bool, animated: Bool) {
        //print("Aufruf1")
        super.setEditing(
            !isEditing,
            animated: true
        )
        tableView.setEditing(
            !tableView.isEditing,
            animated: true
        )
    }
    
    //MARK: - Add new persons
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Neue Person Hinzufügen",
            message: "Bitte gebe den Namen ein",
            preferredStyle: UIAlertController.Style.alert
        )
        let action = UIAlertAction(title: "Person hinzugügen", style: .default) {(action) in
            //print("Neue Person hinzufügen")
            if textField.text == "" || textField.text == nil {
                return
            } else {
                self.persons.insert(Person(name: textField.text!), at: 0)
                
                //self.defaults.set(self.persons, forKey: self.personsArrayKey)
                
                self.savePersons()
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .left)
            }
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Name"
            print("Hallo2")
            textField = alertTextField
        }
        alert.addAction(action)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    //MARK: - Save Persons
    func savePersons(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(persons)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error \(error)")
        }
    }
    
    //MARK: - Load Persons
    func loadPersons(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                persons = try decoder.decode([Person].self, from: data)
            } catch{
                print("Error \(error)")
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentPerson = persons[indexPath.row]
        
        cell.textLabel?.text = currentPerson.name
        
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    
    //MARK: - Edit TableView
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedPerson = persons[sourceIndexPath.row]
        persons.remove(at: sourceIndexPath.row)
        persons.insert(selectedPerson, at: destinationIndexPath.row)
        savePersons()
    }
    
    //MARK: - Delete Rows
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            savePersons()
        }
    }
}
