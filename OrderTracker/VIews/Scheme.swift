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
    static let billViewColour = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    static let billViewCashSelectedColour = UIColor(red: 131/255, green: 37/255, blue: 97/255, alpha: 1)
    static let billViewCardSelectedColour = UIColor(red: 0, green: 51/255, blue: 102/255, alpha: 1)
    static let splitBillSelectedColour = UIColor(red: 37/255, green: 154/255, blue: 67/255, alpha: 1)
    struct AttributedText {
        static let navigationControllerTitleAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .light)
        ]
    }
    
    static let clientOrderCollectionViewCellColour =  UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let clientOrderCollectionViewCellHeaderViewColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    
    static func getColour(withSeed number: Int) -> (r: Double, g: Double, b: Double) {
        let nColour = 7
        var r: Double = 0
        var g: Double = 0
        var b: Double = 0
        if number % nColour == 0 {
            r = 80
            g = 80
            b = 80
        } else if number % nColour == 1 {
            r = 104
            g = 81
            b = 116
        } else if number % nColour == 2 {
            r = 34
            g = 139
            b = 34
        } else if number % nColour == 3 {
            r = 24
            g = 61
            b = 97
        } else if number % nColour == 4 {
            r = 152
            g = 80
            b = 60
        } else if number % nColour == 5 {
            r = 78
            g = 97
            b = 114
        } else {
            r = 88
            g = 35
            b = 53
            
        }
        
        return (r/255, g/255, b/255)
    }
    
    struct Util {
        static func twoDecimalPriceText(_ price: Double) -> String {
            return String(format: "$%.2f", price)
        }
    }
}
