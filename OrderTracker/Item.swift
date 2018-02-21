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
    // decides which properties will be displayed and toggled
    var extraMeatAvailable: Bool = true
    var extraNoodlesAvailable: Bool = true
    
    var extraCorianderAvailable: Bool = true
    var extraSpringOnionAvailable: Bool = true
    
    var noCorianderAvailable: Bool = true
    var noSpringOnionAvailable: Bool = true
    
    var mildAvailable: Bool = true
    
    // change prices using property inspectors
    var extraMeat: Bool = false
    var extraNoodles: Bool = false
    
    var extraCoriander: Bool = false
    var extraSpringOnion: Bool = false
    
    var noCoriander: Bool = false
    var noSpringOnion: Bool = false
    
    var mild: Bool = false
    

}
