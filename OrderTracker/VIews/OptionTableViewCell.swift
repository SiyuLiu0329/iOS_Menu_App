  //
//  OptionTableViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 22/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var value: Bool! {
        willSet {
            if newValue {
                select()
            } else {
                deselecte()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        optionName.textColor = .white
        priceLabel.textColor = .white
        tintColor = .white
        
        backgroundColor = .clear
        optionName.font = UIFont.systemFont(ofSize: 17, weight: .light)
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
        selectedBackgroundView = UIView()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func select() {
        accessoryType = .checkmark
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }
    
    func deselecte() {
        accessoryType = .none
        backgroundColor = .clear
    }
    
}
