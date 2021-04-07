//
//  FirstViewController.swift
//  D-Help
//
//  Created by Dion Lamilga on 04/04/21.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var DateOfBirth: UITextField!
    @IBOutlet weak var Sex: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var ActivityLevel: UITextField!
    
    let datePicker = UIDatePicker()
    
    let sexOption = ["Male","Female","Other"]
    var sexPicker = UIPickerView()
    
    let levelOption = ["Sedentary (Never/Rarely Exercise)","Moderately (Exercise 1-2x / Week)","Vigorously Exercise 3-5x / Week)","Extremely Exercise 6-7x / Week)"]
    let levelPicker = UIPickerView()
    
    let hello = "hello world"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //activity picker
        levelPicker.delegate = self
        levelPicker.dataSource = self
        
        ActivityLevel.inputView = levelPicker
        levelPicker.tag = 2
        
        //sex picker
        sexPicker.delegate = self
        sexPicker.dataSource = self
        
        Sex.inputView = sexPicker
        sexPicker.tag = 1
        
        //date picker
        creatDatepicker()
        DateOfBirth.textColor = .black
        
        //button
        buttonSubmit.layer.cornerRadius = 25.0
    }
    func creatToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func creatDatepicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        DateOfBirth.inputView = datePicker
        DateOfBirth.inputAccessoryView = creatToolbar()
    }

    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.DateOfBirth.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}

extension FirstViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return sexOption.count
        case 2:
            return levelOption.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return sexOption[row]
        case 2:
            return levelOption[row]
        default:
            return "Not Found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            Sex.text = sexOption[row]
            Sex.resignFirstResponder()
        case 2:
            ActivityLevel.text = levelOption[row]
            ActivityLevel.resignFirstResponder()
        default:
            return
        }
    }
    
}

