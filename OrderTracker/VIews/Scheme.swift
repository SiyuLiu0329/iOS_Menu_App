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
    static let editorThemeColour = UIColor(red: 0/255, green: 140/255, blue: 220/255, alpha: 1)
    struct AttributedText {
        static let navigationControllerTitleAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .light)
        ]
    }
    
    static let clientOrderCollectionViewCellColour =  UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let clientOrderCollectionViewCellHeaderViewColour = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    
    
    
    struct Util {
        static func twoDecimalPriceText(_ price: Double) -> String {
            return String(format: "$%.2f", price)
        }
        
        static func randomString(length: Int) -> String {
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)
            var randomString = ""
            for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            return randomString
        }
    }
    
}
