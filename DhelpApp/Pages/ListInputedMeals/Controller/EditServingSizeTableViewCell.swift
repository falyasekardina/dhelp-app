//
//  EditServingSizeTableViewCell.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 12/04/21.
//

import UIKit

class EditServingSizeTableViewCell: UITableViewCell, UITextFieldDelegate {

    var dataIntakes: Intake?
    var a = ""
    
    static let identifier = "EditServingSizeTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "EditServingSizeTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var sizeText: UITextField!
    
    var delegate: EditInputViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sizeText.delegate = self
        sizeText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(textField.text ?? "")")
        return true
    }
    
}

extension EditServingSizeTableViewCell {
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.servingSizeData(servingSize: textField.text!)
    }
}
