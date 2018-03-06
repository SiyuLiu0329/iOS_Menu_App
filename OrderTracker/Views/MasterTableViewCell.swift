//
//  MasterTableViewCell.swift
//  OrderTracker
//
//  Created by macOS on 4/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var itemNumber: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var overlay: UIImageView!
    @IBOutlet weak var unSelectedColourView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unSelectedColourView.backgroundColor = DesignConfig.masterTableViewUnselectedColour
    }
}
