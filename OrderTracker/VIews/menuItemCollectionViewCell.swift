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
    func itemAdded(atCell cell: MenuItemCollectionViewCell)
}

class MenuItemCollectionViewCell: UICollectionViewCell {
    weak var delegate: ItemCellDelegate?
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemNumber: UILabel!
    @IBAction func showItemDetail(_ sender: Any) {
        // item added -> update parent view
        if delegate != nil {
            delegate!.showDetailFor(collectionViewCell: self)
        }
    }
    
    func configure(imgUrl url: String, cellColour colour: UIColor, itemName name: String, itemNumber number: Int) {
        layer.cornerRadius = 5
        clipsToBounds = true
        itemImageView.image = UIImage(named: url)
        backgroundColor = colour
        itemName.text = name
        itemNumber.text = "\(number)"
        itemNumber.textColor = colour
    }
    
    func animate_selected() {
        
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        if delegate != nil {
            delegate!.itemAdded(atCell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemName.sizeToFit()
        itemName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        addButton.layer.cornerRadius = 5
        addButton.clipsToBounds = true
        addButton.layer.maskedCorners = [.layerMinXMinYCorner]
        addButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        itemNumber.layer.cornerRadius = 15
        itemNumber.clipsToBounds = true
        itemNumber.backgroundColor = .white
        
    }
}
