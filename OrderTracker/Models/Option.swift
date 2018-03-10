//
//  Option.swift
//  OrderTracker
//
//  Created by macOS on 22/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation



struct Option: Equatable {
    static func ==(lhs: Option, rhs: Option) -> Bool {
        return lhs.description == rhs.description &&
        lhs.value == rhs.value &&
        lhs.imageURL == rhs.imageURL &&
        lhs.price == rhs.price
    }
    
    var description: String
    var value: Bool
    var imageURL: String
    var price: Double
    
    init(of decription: String, selected value: Bool, pricedAt price: Double, imageAt url: String) {
        self.description = decription
        self.value = value
        self.imageURL = url
        self.price = price
    }
    
}
