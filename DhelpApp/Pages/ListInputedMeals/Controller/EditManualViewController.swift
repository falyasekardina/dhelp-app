//
//  EditManualViewController.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 13/04/21.
//

import UIKit
import CoreData

class EditManualViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var addFoodTable: UITableView!
    @IBOutlet weak var mealTime: UITextField!
    @IBOutlet weak var foodNameInput: UITextField!
    @IBOutlet weak var servingSizeTxt: UITextField!
    @IBOutlet weak var caloriesTxt: UITextField!
    @IBOutlet weak var carboTxt: UITextField!
    @IBOutlet weak var sugarTxt: UITextField!
    
    var delegate: TransitionPageDelegate?
    
    var dataIntakes: Intake?
    
    var intakes: [Intake]?
    
    var savedata: Int?
    
    var timePicker = UIPickerView()
       
    let timeOption = ["Breakfast","Lunch","Dinner","Snack"]
    
    var arrayData  = [""]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addFoodTable.delegate = self
        addFoodTable.dataSource = self
        mealTime.inputView = timePicker
        timePicker.delegate = self
        addFoodTable.isScrollEnabled = false
        
        fetchdata()
        
        guard let data = dataIntakes else {return}
        guard let name = data.name else {return}
        guard let size = data.manualsize else {return}
        
        foodNameInput.text = "\(name)"
        caloriesTxt.text = "\(dataIntakes!.calories)"
        sugarTxt.text = "\(dataIntakes!.sugar)"
        servingSizeTxt.text = "\(size)"
        carboTxt.text = "\(dataIntakes!.carbs)"
        
        foodNameInput.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        caloriesTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        sugarTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        servingSizeTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        carboTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        mealTime.isEnabled = false
        foodNameInput.isEnabled = false
        caloriesTxt.isEnabled = false
        carboTxt.isEnabled = false
        sugarTxt.isEnabled = false
        servingSizeTxt.isEnabled = false
        addFoodTable.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
        foodNameInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        caloriesTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        carboTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sugarTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        servingSizeTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField){
        validateView()
    }
    
    func validateView(){
        if foodNameInput.text != "" && caloriesTxt.text != "" && carboTxt.text != "" && sugarTxt.text != "" && servingSizeTxt.text != ""{
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return timeOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        arrayData[0] = timeOption[row]
        mealTime.resignFirstResponder()
        addFoodTable.reloadData()
    }
    
    @objc func editTapped(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        mealTime.isEnabled = true
        foodNameInput.isEnabled = true
        caloriesTxt.isEnabled = true
        carboTxt.isEnabled = true
        sugarTxt.isEnabled = true
        servingSizeTxt.isEnabled = true
        addFoodTable.isUserInteractionEnabled = true
        
        foodNameInput.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        caloriesTxt.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        sugarTxt.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        servingSizeTxt.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        carboTxt.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @objc func doneTapped() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        let calorieVal = Int64(caloriesTxt.text ?? "") ?? 0
        let carboVal = Double(carboTxt.text ?? "") ?? 0.0
        let sugarVal = Double(sugarTxt.text ?? "") ?? 0.0
        let servingSizeManual = servingSizeTxt.text ?? ""

        let newIntake = self.intakes![savedata!]
        newIntake.name = foodNameInput.text
        newIntake.calories = calorieVal
        newIntake.carbs = carboVal
        newIntake.sugar = sugarVal
        newIntake.mealtime = arrayData[0]
        newIntake.servingsize = 0.0
        newIntake.manualsize = servingSizeManual
        newIntake.createdat = Date()
        
        foodNameInput.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        caloriesTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        sugarTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        servingSizeTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        carboTxt.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        mealTime.isEnabled = false
        foodNameInput.isEnabled = false
        caloriesTxt.isEnabled = false
        carboTxt.isEnabled = false
        sugarTxt.isEnabled = false
        servingSizeTxt.isEnabled = false
        addFoodTable.isUserInteractionEnabled = false

        do {
            try self.context.save()
        } catch {
            print("Error: \(error)")
        }
        
//        delegate?.moveToListPage(mealType: arrayData[0])
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchdata(){
        do{
        let request = Intake.fetchRequest() as NSFetchRequest<Intake>
            self.intakes = try context.fetch(request)
            for (index, dt) in self.intakes!.enumerated() {
                if dt.id == dataIntakes?.id {
                    savedata = index
                }
            }
        } catch {
            
        }
    }
    
}

extension EditManualViewController: UITableViewDelegate, UITableViewDataSource{
    
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
            sectionIndex = 2
        }
        return sectionIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellTime = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath)
            cellTime.textLabel?.text = "Time"
            if arrayData[0] == "" {
                cellTime.detailTextLabel!.text = self.dataIntakes!.mealtime
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
        }
        
        return UITableViewCell()
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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
}

extension EditManualViewController{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Add Food"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
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

