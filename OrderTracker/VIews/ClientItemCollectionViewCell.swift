//
//  ClientItemCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 4/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ClientItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var optionTextView: UITextView!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius =  3
        clipsToBounds = true
        itemNumberLabel.backgroundColor = .white
        itemNumberLabel.layer.cornerRadius = 17.5
        itemNumberLabel.clipsToBounds = true
        optionTextView.backgroundColor = .clear
        optionTextView.textColor = .white
        optionTextView.isUserInteractionEnabled = false
    }
    
    func configure(withItem item: MenuItem) {
        let colour = UIColor(red: CGFloat(item.colour.r), green: CGFloat(item.colour.g), blue: CGFloat(item.colour.b), alpha: 1)
        backgroundColor = colour
        itemNumberLabel.textColor = colour
        nameLabel.text = item.name
        itemNumberLabel.text = "\(item.number)"
        
        var optionText = ""
        for option in item.options {
            if option.value {
                optionText += "• " + option.description + "\n"
            }
        }
        
        optionTextView.text = optionText
    }

}
