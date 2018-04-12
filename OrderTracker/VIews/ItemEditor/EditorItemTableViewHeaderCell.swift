//
//  EditorItemTableViewHeaderCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class EditorItemTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        itemImageView.layer.cornerRadius = 5
        itemImageView.clipsToBounds = true
        nameField.placeholder = "Item name"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
