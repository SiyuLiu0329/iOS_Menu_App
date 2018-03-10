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
    
    func configure(imageUrl url: String) {
        itemImageView.image = UIImage(named: url)
    }
}
