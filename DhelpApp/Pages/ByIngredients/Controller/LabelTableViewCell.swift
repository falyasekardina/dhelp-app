//
//  LabelTableViewCell.swift
//  DhelpApp
//
//  Created by Dion Lamilga on 07/04/21.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelSugar: UILabel!
    @IBOutlet weak var labelCarbo: UILabel!
    
    static let identifier = "LabelTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "LabelTableViewCell", bundle: nil)
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
