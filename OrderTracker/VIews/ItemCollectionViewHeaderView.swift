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
    @IBOutlet weak var tenderButton: UIButton!
    @IBAction func tenderButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var clearButton: UIButton!
    @IBAction func clearButtonPressed(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Scheme.navigationBarColour
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
        sendSubview(toBack: blurEffectView)
        
        clearButton.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        tenderButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.4)
        
        tenderButton.layer.cornerRadius = 5
        tenderButton.clipsToBounds = true
        tenderButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        clearButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        clearButton.layer.cornerRadius = 5
        clearButton.clipsToBounds = true
        
    }
}
