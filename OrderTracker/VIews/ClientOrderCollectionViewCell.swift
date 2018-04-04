//
//  ClientOrderCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 4/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ClientOrderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerViewTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = Scheme.clientOrderCollectionViewCellColour
        headerView.backgroundColor = Scheme.clientOrderCollectionViewCellColour
    }
    
    func configure(loadingOrder order: Order) {
        headerViewTitle.text = "Order \(order.orderNumber)"
    }

}
