//
//  ListInputMealsTableViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 05/04/21.
//

import UIKit

class ListInputMealsTableViewController: UITableViewController {
    
    var getTitle = ""
    
    let names = [
        "Gilang Adrian",
        "Michael Tanakoman",
        "Michelle Tanakoman",
        "Aqshal Wibisono"
    ]
    
    let angka = [18, 24, 50, 40]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let array = angka.map{
            String($0)
        }
        
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = array[indexPath.row] + " gr"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            self.deleteTapped()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func deleteTapped(){
        let alertController = UIAlertController(title: "Action Sheet", message: "Are you sure want to delete this ingredient?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
            print("Delete button tapped")
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
}

extension ListInputMealsTableViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = getTitle
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
