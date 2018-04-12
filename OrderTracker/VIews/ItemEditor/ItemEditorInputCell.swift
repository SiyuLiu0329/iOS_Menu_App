//
//  ItemEditorInputCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ItemEditorInputCell: UITableViewCell {
    @IBOutlet weak var colourPreview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        colourPreview.layer.cornerRadius = 5
        colourPreview.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setColour(_ colour: UIColor) {
        colourPreview.backgroundColor = colour
    }
    
}
