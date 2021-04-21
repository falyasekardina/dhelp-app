//
//  EditLabelTableViewCell.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 12/04/21.
//

import UIKit

class EditLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelSugar: UILabel!
    @IBOutlet weak var labelKarbo: UILabel!
    
    static let identifier = "EditLabelViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "EditLabelTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
