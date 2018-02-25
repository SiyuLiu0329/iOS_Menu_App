//
//  SummaryTableViewCell.swift
//  OrderTracker
//
//  Created by macOS on 25/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var title: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
