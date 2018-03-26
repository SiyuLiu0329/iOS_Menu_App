//
//  ItemCollectionViewHeaderView.swift
//  OrderTracker
//
//  Created by Mac on 14/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionViewHeaderView: UICollectionReusableView {
    @IBOutlet weak var headerTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Scheme.navigationBarColour
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
        sendSubview(toBack: blurEffectView)
    }
    
    func configureHeader(title t: String) {
        headerTitleLabel.text = t
    }
}
