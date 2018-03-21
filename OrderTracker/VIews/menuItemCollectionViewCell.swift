//
//  menuItemCollectionViewCell.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
protocol ItemCellDelegate: class {
    func showDetailFor(collectionViewCell cell: MenuItemCollectionViewCell)
}

class MenuItemCollectionViewCell: UICollectionViewCell {
    weak var delegate: ItemCellDelegate?
    @IBOutlet weak var itemImageView: UIImageView!
    @IBAction func showItemDetail(_ sender: Any) {
        // item added -> update parent view
        if delegate != nil {
            delegate!.showDetailFor(collectionViewCell: self)
        }
    }
    
    func configure(imgUrl url: String, cellColour colour: UIColor) {
        layer.cornerRadius = 5
        clipsToBounds = true
        itemImageView.image = UIImage(named: url)
        backgroundColor = colour
    }
    
    func animate_selected() {
        
    }
}
