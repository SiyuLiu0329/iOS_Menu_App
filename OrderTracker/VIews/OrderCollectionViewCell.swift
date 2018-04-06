//
//  orderCollectionViewCell.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol OrderCollectionViewCellDelegate: class {
    func deleteOrder(_ sender: OrderCollectionViewCell)
}

class OrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.deleteOrder(self)
        }
    }
    
    @IBOutlet weak var label: UILabel!
    weak var delegate: OrderCollectionViewCellDelegate?
    func configure() {
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}
