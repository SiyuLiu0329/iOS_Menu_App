//
//  EditorItemTableViewHeaderCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class EditorItemTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var priceField: TextInputView!
    @IBOutlet weak var numberField: TextInputView!
    @IBOutlet weak var nameField: TextInputView!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        itemImageView.layer.cornerRadius = 5
        itemImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(itemName name: String?, itemNumber number: Int?, itemPrice price: Double?) {
        nameField.setTitle("Item Name:")
        numberField.setTitle("Number (#):")
        numberField.inputTextFiled.keyboardType = .numberPad
        priceField.setTitle("Price ($):")
        priceField.inputTextFiled.keyboardType = .numberPad
        
        nameField.inputTextFiled.text = (name == nil) ? "" : name!
        numberField.inputTextFiled.text = (number == nil) ? "" : "\(number!)"
        priceField.inputTextFiled.text = (price == nil) ? "" : "\(price!)"
        
    }
}
