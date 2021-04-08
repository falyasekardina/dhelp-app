//
//  ListInputMealViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 07/04/21.
//

import UIKit

class ListInputMealViewController: UIViewController {
    
    var getTitle = ""
    
    let names = [
        "Gilang Adrian",
        "Michael Tanakoman",
        "Michelle Tanakoman",
        "Aqshal Wibisono"
    ]
    
    let angka = [18, 24, 50, 40]
    
 //   @IBOutlet weak var addFoodBtnStyling: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    
//    @IBAction func addFoodBtn(_ sender: UIButton) {
//        let optionMenu = UIAlertController(title: nil, message: "Please choose your input preferences", preferredStyle: .actionSheet)
//        let byIngredients = UIAlertAction(title: "By Ingredient", style: .default) { action in
//            self.performSegue(withIdentifier: "byIngredientPage", sender: self)
//        }
//        let manualInput = UIAlertAction(title: "Manual Input", style: .default) { action in
//            print("Manual Input")
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        optionMenu.addAction(byIngredients)
//        optionMenu.addAction(manualInput)
//        optionMenu.addAction(cancelAction)
//        optionMenu.view.addSubview(UIView())
//        self.present(optionMenu, animated: false)
//    }
}

extension ListInputMealViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let array = angka.map{
            String($0)
        }
        
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = array[indexPath.row] + " gr"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            self.deleteTapped()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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

extension ListInputMealViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //addFoodBtnStyling.layer.cornerRadius = 15
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
