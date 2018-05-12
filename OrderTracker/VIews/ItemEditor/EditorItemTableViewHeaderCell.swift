//
//  EditorItemTableViewHeaderCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol EditorItemTableViewHeaderDelegate: class {
    func onEditImagePressed()
}

class EditorItemTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var priceField: TextInputView!
    @IBOutlet weak var numberField: TextInputView!
    @IBOutlet weak var nameField: TextInputView!
    @IBOutlet weak var itemImageView: UIImageView!
    weak var delegate: EditorItemTableViewHeaderDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        itemImageView.layer.cornerRadius = 5
        itemImageView.clipsToBounds = true
    }
    
    @IBAction func onEditPressed(_ sender: Any) {
        if delegate != nil {
            delegate?.onEditImagePressed()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        numberField.isUserInteractionEnabled = false
        numberField.inputTextField.alpha = 0.3
    }
    
    func configure(itemName name: String?, itemNumber number: Int?, itemPrice price: Double?, textInputViewDelegate: TextFieldDelegate?) {
        nameField.setTitle("Item Name:")
        numberField.setTitle("Number (#):")
        numberField.inputTextField.keyboardType = .numberPad
        priceField.delegate = textInputViewDelegate
        numberField.delegate = textInputViewDelegate
        nameField.delegate = textInputViewDelegate
        priceField.setTitle("Price ($):")
        priceField.inputTextField.keyboardType = .numberPad
        
        nameField.inputTextField.text = (name == nil) ? "" : name!
        numberField.inputTextField.text = (number == nil) ? "" : "\(number!)"
        priceField.inputTextField.text = (price == nil) ? "" : "\(price!)"
        
    }
}
