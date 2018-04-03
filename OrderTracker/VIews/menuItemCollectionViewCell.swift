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
    func quickBillItem(atCell cell: MenuItemCollectionViewCell)
}

class MenuItemCollectionViewCell: UICollectionViewCell {
    weak var delegate: ItemCellDelegate?
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var tenderButton: UIButton!
    @IBOutlet weak var itemNumber: UILabel!
    @IBAction func addItemButtonPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.itemAdded(atCell: self)
        }
    }
    @IBAction func showItemDetail(_ sender: Any) {
        // item added -> update parent view
        if delegate != nil {
            delegate!.showDetailFor(collectionViewCell: self)
        }
    }
    
    func configure(withItem item: MenuItem) {
        layer.cornerRadius = 5
        clipsToBounds = true
        itemImageView.image = UIImage(named: item.imageURL)
        backgroundColor = UIColor(red: CGFloat(item.colour.r), green: CGFloat(item.colour.g), blue: CGFloat(item.colour.b), alpha: 1)
        itemName.text = item.name
        itemNumber.text = "\(item.number)"
        itemNumber.textColor = UIColor(red: CGFloat(item.colour.r), green: CGFloat(item.colour.g), blue: CGFloat(item.colour.b), alpha: 1)
        tenderButton.setTitle(Scheme.Util.twoDecimalPriceText(item.unitPrice), for: .normal)
    }
    
    @IBAction func tenderButtonPressed(_ sender: Any) {
        if delegate != nil {
            delegate?.quickBillItem(atCell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemName.sizeToFit()
        itemName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tenderButton.layer.cornerRadius = 5
        tenderButton.clipsToBounds = true
        tenderButton.layer.maskedCorners = [.layerMinXMinYCorner]
        tenderButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        itemNumber.layer.cornerRadius = 15
        itemNumber.clipsToBounds = true
        itemNumber.backgroundColor = .white
        
    }
}
