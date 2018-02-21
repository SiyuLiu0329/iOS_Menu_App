//
//  Items.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

struct MenuItem {
    var number: Int
    var price: Double
    var name: String
    var comment: String?
    var imageURL: String
    var tableNumber: Int?
    var quantity: Int {
        willSet {
            totalPrice = Double(newValue) * price
        }
    }
    var totalPrice: Double
    
    init(named name: String, numbered number: Int, pricedAt price: Double, image imageName: String) {
        self.name = name
        self.number = number
        self.price =  price
        self.imageURL = imageName
        self.quantity = 0
        self.totalPrice = 0
    }
    
    // change prices using property inspectors
    var extraMeat: Bool = false
    var extraNoodles: Bool = false
    
    var extraCoriander: Bool = false
    var extraSpringOnion: Bool = false
    
    var noCoriander: Bool = false
    var noSpringOnion: Bool = false
    
    var mild: Bool = false
    

}
