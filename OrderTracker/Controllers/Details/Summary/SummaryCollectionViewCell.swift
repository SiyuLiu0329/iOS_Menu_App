//
//  summaryCollectionViewCell.swift
//  OrderTracker
//
//  Created by macOS on 27/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!
    var cellLabel: UILabel!
    var originalCentre: CGPoint!
    
    func setUpCell() {
        originalCentre = center
        layer.cornerRadius = 20
        layer.masksToBounds = true
        backgroundColor = UIColor.white
    }
    
}
