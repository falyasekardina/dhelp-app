//
//  ListInputMealViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 07/04/21.
//

import UIKit
import CoreData

class ListInputMealViewController: UIViewController {
    
    var getTitle = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var intakes: [Intake]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Fecth Data
        fetchData()
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
        return intakes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.intakes![indexPath.row].name
        cell.detailTextLabel?.text = "\(self.intakes![indexPath.row].sugar) gr"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            self.deleteTapped(indexData: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func deleteTapped(indexData: Int){
        let alertController = UIAlertController(title: "Action Sheet", message: "Are you sure want to delete this ingredient?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
            let note = self.intakes![indexData]
            self.context.delete(note)
            do {
                try self.context.save()
            } catch {
                print("Error: \(error)")
            }
            
            self.fetchData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
    
    func fetchData() {
        do {
            let request = Intake.fetchRequest() as NSFetchRequest<Intake>
            let meals = try context.fetch(request)
            self.intakes = [Intake]()

            for dt in meals {
                if (dt.mealtime == getTitle && getDayFormater(dateData: dt.createdat!) == getDayFormater(dateData: currentDate)) {
                    self.intakes.append(dt)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getDayFormater(dateData: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let newFormat = dateFormater.string(from: dateData)
        return newFormat
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
