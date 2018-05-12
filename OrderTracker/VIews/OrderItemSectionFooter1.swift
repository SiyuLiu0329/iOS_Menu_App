//
//  OrderItemSectionFooter1.swift
//  OrderTracker
//
//  Created by Siyu Liu on 26/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderItemSectionFooter1: UICollectionReusableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Scheme.navigationBarColour
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
        sendSubview(toBack: blurEffectView)
    }
}
