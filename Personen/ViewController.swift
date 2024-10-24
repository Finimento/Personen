//
//  ViewController.swift
//  Personen
//
//  Created by Mike Finimento on 16.10.24.
//

import UIKit

class ViewController: UIViewController {
    
    var persons = ["Klaus", "Maren", "Niklas", "Max", "Hermann", "Klaudia"]

    //MARK: -Outlet
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let alert = UIAlertController(
            title: "Neue Person Hinzufügen",
            message: "Bitte gebe den Namen ein",
            preferredStyle: UIAlertController.Style.alert
        )
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = persons[indexPath.row]
        
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
    }
    
    //MARK: - Delete Rowsf
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
