//
//  TableViewCell.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 07/04/21.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var dataPicker = ""
    
    let timePicker = UIPickerView()
    
    let timeOption = ["Breakfast","Lunch","Dinner","Snack"]

    static let identifier = "TableViewCell"
    
    var Makan = ""
    
    var delegate: InputManualViewControllerDelegate?
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var field: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        field.delegate = self
        timePicker.delegate = self
        timePicker.dataSource = self
        field.inputView = timePicker
        // Initialization code
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(textField.text ?? "")")
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension TableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
        field.text = timeOption[row]
        
        field.resignFirstResponder()
        
        delegate?.mealTimeSelected(mealTime: timeOption[row])
//        if field.text == "Dinner"{
//            field.text = "Dinner"
//        }
    }
    
}
