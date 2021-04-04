//
//  DailyIntakeTypeCollectionViewCell.swift
//  DhelpApp
//
//  Created by Reza Harris on 04/04/21.
//

import UIKit

class DailyIntakeTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mealLogo: UIImageView!
    @IBOutlet weak var totalLbl: UILabel!
    
    func setup(with dailyInTake: DailyInTake) {
        titleLbl.text = dailyInTake.title
        mealLogo.image = dailyInTake.mealLogo
        totalLbl.text = dailyInTake.total
    }
}
