//
//  EditorItemTableViewHeaderCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class EditorItemTableViewHeaderCell: UITableViewCell {

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
    
    func configure() {
        nameField.setTitle("Item Name:")
        numberField.setTitle("Number:")
        numberField.inputTextFiled.keyboardType = .numberPad
    }
}
