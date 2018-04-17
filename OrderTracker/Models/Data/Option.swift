//
//  Option.swift
//  OrderTracker
//
//  Created by macOS on 22/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation



struct Option: Equatable, Codable {
    
    var description: String
    var value: Bool
    var price: Double
    
    init(of decription: String, selected value: Bool, pricedAt price: Double, imageAt url: String) {
        self.description = decription
        self.value = value
        self.price = price
    }
    
    init(of decription: String, selected value: Bool, pricedAt price: Double) {
         self.description = decription
        self.value = value
        self.price = price
    }
}
