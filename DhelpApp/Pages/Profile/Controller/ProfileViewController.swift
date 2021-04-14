//
//  ProfileViewController.swift
//  DhelpApp
//
//  Created by Reza Harris on 01/04/21.
//

import UIKit

class ProfileViewController: UIViewController{

    @IBOutlet weak var tableProfile: UITableView!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    @IBOutlet weak var btnDob: UITextField!
    @IBOutlet weak var btnSex: UITextField!
    @IBOutlet weak var btnLevel: UITextField!
    
    var boolBtn = false
    var dob = ""
    var sex = ""
    var height = ""
    var weight = ""
    var act = ""
    
    var tableData = ""
    
    let sexOption = ["Male", "Female", "Other"]
    let levelOption = ["Sedentary (Never/Rarely Exercise)","Moderately (Exercise 1-2x / Week)","Vigorously (Exercise 3-5x / Week)","Extremely Exercise (6-7x / Week)"]
    
    var sexPicker = UIPickerView()
    var levelPicker = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataUser()
        
        tableProfile.isScrollEnabled = false
        tableProfile.allowsSelection = false
        
        btnDob.isHidden = true
        btnSex.isHidden = true
        btnLevel.isHidden = true
        
        txtHeight.isHidden = true
        txtWeight.isHidden = true
        tableData = "none"
        
        tableProfile.delegate = self
        tableProfile.dataSource = self
    
        sexPicker.tag = 1
        sexPicker.delegate = self
        sexPicker.dataSource = self
        
        levelPicker.tag = 2
        levelPicker.delegate = self
        levelPicker.dataSource = self
        
        createDatePicker()
        
        btnSex.inputView = sexPicker
        btnLevel.inputView = levelPicker
        
        txtWeight.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        txtHeight.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateView()
    }
    
    func validateView(){
        if tableData == "edit"{
            if txtWeight.text != "" && txtHeight.text != ""{
                btnEdit.isEnabled = true
            }else{
                btnEdit.isEnabled = false
            }
        }
    }
    
    func loadDataUser(){
        let defaults = UserDefaults.standard
        
        dob = defaults.object(forKey: "dataDob") as! String
        sex = defaults.object(forKey: "dataGender") as! String
        height = defaults.object(forKey: "dataHeight") as! String
        weight = defaults.object(forKey: "dataWeight") as! String
        act = defaults.object(forKey: "dataAct") as! String
        
    }
    
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        btnDob.inputView = datePicker
        btnDob.inputAccessoryView = createToolbar()
    }
    
    func createToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.btnDob.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        dob = dateFormatter.string(from: datePicker.date)
        tableProfile.reloadData()
    }
    
    @IBAction func btnEditTapped(sender: UIBarButtonItem){
        print("ini kepencet")
        if tableData == "none"{
            tableProfile.reloadData()
            tableData = "edit"

            sender.title = "Done"
            sender.style = .done
            
            btnDob.isHidden = false
            btnSex.isHidden = false
            btnLevel.isHidden = false

            txtHeight.isHidden = false
            txtHeight.text = height

            txtWeight.isHidden = false
            txtWeight.text = weight

            print(tableData)
            tableProfile.reloadData()
        }else if tableData == "edit"{
            tableProfile.reloadData()
            tableData = "none"
            
            sender.title = "Edit"
            
            btnDob.isHidden = true
            btnSex.isHidden = true
            btnLevel.isHidden = true
            
            btnDob.resignFirstResponder()
            btnSex.resignFirstResponder()
            btnLevel.resignFirstResponder()
            
            let defaults = UserDefaults.standard
            defaults.setValue(dob, forKey: "dataDob")
            defaults.setValue(sex, forKey: "dataGender")
            defaults.setValue(txtHeight.text, forKey: "dataHeight")
            defaults.setValue(txtWeight.text, forKey: "dataWeight")
            defaults.setValue(act, forKey: "dataAct")
            
            txtHeight.isHidden = true
            txtWeight.isHidden = true
            
            print(tableData)
            loadDataUser()
            tableProfile.reloadData()
        }
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return sexOption.count
        case 2:
            return levelOption.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return sexOption[row]
        case 2:
            return levelOption[row]
        default:
            return "Not Found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            sex = sexOption[row]
            btnSex.resignFirstResponder()
            tableProfile.reloadData()
        }else if pickerView.tag == 2{
            act = levelOption[row]
            btnLevel.resignFirstResponder()
            tableProfile.reloadData()
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableData == "edit"{
            switch indexPath.row {
            case 1:
                print("lol")
            default:
                print("hehe")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if tableData == "none"{
            if indexPath.row == 0{
                cell.textLabel?.text = "Date of Birth"
                cell.detailTextLabel?.text = dob
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.accessoryType = .none
            }else if indexPath.row == 1{
                cell.textLabel?.text = "Sex"
                cell.detailTextLabel?.text = sex
                cell.detailTextLabel?.resignFirstResponder()
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.accessoryType = .none
            }else if indexPath.row == 2{
                cell.textLabel?.text = "Height"
                cell.detailTextLabel?.text = "\(height) cm"
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }else if indexPath.row == 3{
                cell.textLabel?.text = "Weight"
                cell.detailTextLabel?.text = "\(weight) kg"
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }else if indexPath.row == 4{
                cell.textLabel?.text = "Activity Level"
                cell.detailTextLabel?.text = act
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.accessoryType = .none
            }
        }else if tableData == "edit"{
            if indexPath.row == 0{
                cell.textLabel?.text = "Date of Birth"
                cell.detailTextLabel?.text = dob
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.accessoryType = .disclosureIndicator
            }else if indexPath.row == 1{
                cell.textLabel?.text = "Sex"
                cell.detailTextLabel?.text = sex
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.accessoryType = .disclosureIndicator
            }else if indexPath.row == 2{
                cell.textLabel?.text = "Height"
                cell.detailTextLabel?.text = "cm"
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }else if indexPath.row == 3{
                cell.textLabel?.text = "Weight"
                cell.detailTextLabel?.text = "kg"
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }else if indexPath.row == 4{
                cell.textLabel?.text = "Activity Level"
                cell.detailTextLabel?.text = act
                cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.accessoryType = .disclosureIndicator
            }
        }
        return cell
    }
}

extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Profile"
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem?.title = "Edit"
        self.navigationItem.rightBarButtonItem?.style = .done
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
