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
    @IBOutlet weak var billButton: UIButton!
    @IBOutlet weak var itemNumber: UILabel!
    @IBAction func addItemButtonPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.itemAdded(atCell: self)
        }
    }
    
    func configure(withItem item: MenuItem) {
        layer.cornerRadius = 10
        clipsToBounds = true
        itemImageView.image = item.getImage()
        backgroundColor = UIColor(red: CGFloat(item.colour.r), green: CGFloat(item.colour.g), blue: CGFloat(item.colour.b), alpha: 1)
        itemName.text = item.name
        itemNumber.text = "\(item.number)"
        itemNumber.textColor = UIColor(red: CGFloat(item.colour.r), green: CGFloat(item.colour.g), blue: CGFloat(item.colour.b), alpha: 1)
        priceLabel.text = Scheme.Util.twoDecimalPriceText(item.unitPrice)
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func tenderButtonPressed(_ sender: Any) {
        if delegate != nil {
            delegate?.quickBillItem(atCell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemName.sizeToFit()
        itemName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        billButton.layer.cornerRadius = 15
        billButton.clipsToBounds = true
        billButton.layer.maskedCorners = [.layerMinXMinYCorner]
        billButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        itemNumber.layer.cornerRadius = 10
        itemNumber.clipsToBounds = true
        itemNumber.backgroundColor = .white
        
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        addButton.layer.maskedCorners = [.layerMaxXMinYCorner]
        addButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        
    }
}
