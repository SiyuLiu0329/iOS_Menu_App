//
//  SBCVCCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 1/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SBCVCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var isSelectedForBilling = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.6
    }
    
    func configure(_ selected: Bool, price p: Double) {
        isSelectedForBilling = selected
        if selected {
            backgroundColor = Scheme.splitBillSelectedColour
            icon.image = #imageLiteral(resourceName: "person_selected")
            priceLabel.textColor = .white
        } else {
            backgroundColor = .white
            icon.image = #imageLiteral(resourceName: "person")
            priceLabel.textColor = .darkGray
        }
        priceLabel.text = Scheme.Util.twoDecimalPriceText(p)
    }
   
    
}
