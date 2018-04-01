//
//  SBCVCCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 1/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SBCVCCollectionViewCell: UICollectionViewCell {
    var isSelectedForBilling = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.6
        layer.cornerRadius = 5
        clipsToBounds = true
    }

}
