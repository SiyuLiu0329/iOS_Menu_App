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
    static let menuItemCollectionViewBackgroundColour = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let detailViewControllerBackgoundColour = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    static let navigationControllerBackButtonColour = UIColor.white
    
    struct AttributedText {
        static let navigationControllerTitleAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .light)
        ]
    }
    
    static func getColour(withSeed number: Int) -> UIColor {
        var colour: UIColor
        let nColour = 7
        if number % nColour == 0 {
            colour = UIColor.darkGray
        } else if number % nColour == 1 {
            colour = UIColor(red: 104/255, green: 81/255, blue: 116/255, alpha: 1)
        } else if number % nColour == 2 {
            colour = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        } else if number % nColour == 3 {
            colour = UIColor(red: 24/255, green: 61/255, blue: 97/255, alpha: 1)
        } else if number % nColour == 4 {
            colour = UIColor(red: 152/255, green: 80/255, blue: 60/255, alpha: 1)
        } else if number % nColour == 5 {
            colour = UIColor(red: 78/255, green: 97/255, blue: 114/255, alpha: 1)
        } else {
            colour = UIColor(red: 88/255, green: 35/255, blue: 53/255, alpha: 1)
        }
        
        return colour
    }
    
    struct Util {
        static func twoDecimalPriceText(_ price: Double) -> String {
            return String(format: "$%.2f", price)
        }
    }
}
