//
//  ColourSchemes.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

struct Scheme {
    static let collectionViewBackGroundColour = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let navigationBarColour = UIColor.clear
    static let detailViewControllerBackgoundColour = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    
    struct AttributedText {
        static let navigationControllerTitleAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .light)
        ]
    }
}
