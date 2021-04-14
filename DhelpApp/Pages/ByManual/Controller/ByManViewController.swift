//
//  ByManViewController.swift
//  DhelpApp
//
//  Created by Falya Aqiela Sekardina on 07/04/21.
//

import UIKit
import CoreData

class ByManViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var addFoodTable: UITableView!
    @IBOutlet weak var mealTime: UITextField!
    @IBOutlet weak var foodNameInput: UITextField!
    @IBOutlet weak var caloriesTxt: UITextField!
    @IBOutlet weak var carboTxt: UITextField!
    @IBOutlet weak var sugarTxt: UITextField!
    @IBOutlet weak var servingSizeTxt: UITextField!
    
//    var delegate: TransitionPage?
    
    var timePicker = UIPickerView()
    
    let timeOption = ["Breakfast","Lunch","Dinner","Snack"]
    
    var arrayData  = [""]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var intakes: [Intake]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFoodTable.isScrollEnabled = false
        addFoodTable.delegate = self
        addFoodTable.dataSource = self
        mealTime.inputView = timePicker
        timePicker.delegate = self
        fetchData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        timeOption.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return timeOption[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        arrayData[0] = timeOption[row]
        addFoodTable.reloadData()
    }
    
    @objc func doneTapped() {
        let calorieVal = Int64(caloriesTxt.text ?? "") ?? 0
        let carboVal = Double(carboTxt.text ?? "") ?? 0.0
        let sugarVal = Double(sugarTxt.text ?? "") ?? 0.0
        let servingSizeManual = servingSizeTxt.text ?? ""

        let newIntake = Intake(context: self.context)
        newIntake.name = foodNameInput.text
        newIntake.calories = calorieVal
        newIntake.carbs = carboVal
        newIntake.sugar = sugarVal
        newIntake.mealtime = arrayData[0]
        newIntake.servingsize = 0.0
        newIntake.manualsize = servingSizeManual
        newIntake.createdat = Date()

        do {
            try self.context.save()
        } catch {
            print("Error: \(error)")
        }
        
//        delegate?.moveToListPage(mealType: arrayData[0])
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ByManViewController: UITableViewDelegate, UITableViewDataSource {
    struct ListOfFields {
        static var fieldName = [
            "Food Name",
            "Calories",
            "Carbs",
            "Sugar",
            "Serving Size"
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionIndex : Int = 0
        if section == 0
        {
            sectionIndex = 1
        }
        else if section == 1
        {
            sectionIndex = 5
        }
        else if section == 2
        {
            sectionIndex = intakes?.count ?? 0
        }
        return sectionIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellTime = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath)
            cellTime.textLabel?.text = "Time"
            if arrayData[0] == "" {
                cellTime.detailTextLabel?.text = "Required"
            }
            else {
                cellTime.detailTextLabel?.text = arrayData[0]
            }
            
            return cellTime
        }
        else if indexPath.section == 1 {
            let cellDetail = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
            cellDetail.textLabel?.text = ListOfFields.fieldName[indexPath.row]
            if indexPath.row == 0 {
                cellDetail.detailTextLabel?.text = ""
            }
            else if indexPath.row == 1 {
                cellDetail.detailTextLabel?.text = "kcal"
            }
            else if indexPath.row == 2 {
                cellDetail.detailTextLabel?.text = "gr"
            }
            else if indexPath.row == 3 {
                cellDetail.detailTextLabel?.text = "gr"
            }
            else if indexPath.row == 4 {
                cellDetail.detailTextLabel?.text = ""
            }
            
            return cellDetail
        } else if indexPath.section == 2 {
            let cellDetail = tableView.dequeueReusableCell(withIdentifier: "historyInput", for: indexPath)
            cellDetail.textLabel?.text = intakes?[indexPath.row].name
            cellDetail.detailTextLabel?.text = "\(intakes![indexPath.row].sugar) gr"
            return cellDetail
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            foodNameInput.text = intakes![indexPath.row].name
            caloriesTxt.text = "\(Int(intakes![indexPath.row].calories))"
            carboTxt.text = "\(intakes![indexPath.row].carbs)"
            sugarTxt.text = "\(intakes![indexPath.row].sugar)"
            servingSizeTxt.text = intakes![indexPath.row].manualsize
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle : String?
        if section == 0
        {
            headerTitle = "Time"
        }
        if section == 1
        {
            headerTitle = "Detail"
        }
        if section == 2
        {
            headerTitle = "History"
        }
        return headerTitle
    }

    //Below method wil return number of sections
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func fetchData() {
        self.intakes = [Intake]()
        do {
            let request = Intake.fetchRequest() as NSFetchRequest<Intake>
            let data = try context.fetch(request)
            
            for dt in data {
                if dt.manualsize != "" {
                    intakes?.append(dt)
                }
            }
            
            DispatchQueue.main.async {
                self.addFoodTable.reloadData()
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

extension ByManViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Add Food"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
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
