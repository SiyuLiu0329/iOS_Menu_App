//
//  menuItemCollectionViewCell.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
protocol ItemCellDelegate: class {
    func incrementQuantity(_ sender: MenuItemCollectionViewCell)
}

class MenuItemCollectionViewCell: UICollectionViewCell {
    weak var delegate: ItemCellDelegate?
    @IBOutlet weak var itemImage: UIImageView!
    @IBAction func incrementQuantity(_ sender: Any) {
        // item added -> update parent view
        if delegate != nil {
            delegate!.incrementQuantity(self)
        }
    }
    
    func configure(imgUrl url: String) {
        itemImage.image = UIImage(named: url)
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}
