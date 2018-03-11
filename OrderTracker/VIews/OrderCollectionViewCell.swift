//
//  orderCollectionViewCell.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    func configure() {
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}
