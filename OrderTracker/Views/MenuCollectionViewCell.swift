//
//  MenuCollectionViewCell.swift
//  OrderTracker
//
//  Created by macOS on 7/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    
    var isItemSelected = false {
        willSet {
            if newValue == true {
                selectedView.alpha = 0
            } else {
                selectedView.alpha = 0.7
            }
        }
    }
    
    func configure(imageUrl url: String) {
        itemImageView.image = UIImage(named: url)
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}
