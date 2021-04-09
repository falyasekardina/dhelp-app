//
//  CustomTableViewCell.swift
//  DhelpApp
//
//  Created by Graciela gabrielle Angeline on 09/04/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"
    
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelSugar: UILabel!
    @IBOutlet weak var labelCarbo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib()->UINib{
        return UINib(nibName: "CustomTableViewCell", bundle: nil)
    }

}
