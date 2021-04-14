//
//  ServingSizeTableViewCell.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 07/04/21.
//

import UIKit

class ServingSizeTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "ServingSizeTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "ServingSizeTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var sizeText: UITextField!
    
    var delegate: InputManualViewControllerDelegate?
    
    var isiServing1 = false
    
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

extension ServingSizeTableViewCell {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            isiServing1 = false
        }else{
            isiServing1 = true
        }
        
        delegate?.servingSizeData(servingSize: textField.text!, isiServing: isiServing1)
    }
}
