//
//  Items.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

enum ItemType {
    // different options for each type
    case type1
    case type2
    case type3
}

struct MenuItem {
    var number: Int
    var price: Double
    var name: String
    var comment: String?
    var imageURL: String
    var tableNumber: Int?
    var itemType: ItemType
    var quantity: Int {
        willSet {
            totalPrice = Double(newValue) * price
        }
    }
    var totalPrice: Double
    var options: [Option] = []
    
    init(named name: String, numbered number: Int, itemType type: ItemType, pricedAt price: Double, image imageName: String) {
        self.name = name
        self.number = number
        self.price =  price
        self.imageURL = imageName
        self.quantity = 0
        self.totalPrice = 0
        self.itemType = type
        addDefaultOptions()
    }
    
    mutating private func addDefaultOptions() {
        switch itemType {
        case .type1:
            options.append(Option(of: "No Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "No Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "No Chive", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Noodles", selected: false, pricedAt: 2.00, imageAt: ""))
            options.append(Option(of: "Extra Meat", selected: false, pricedAt: 3.00, imageAt: ""))
            options.append(Option(of: "Extra Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Chive", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Vegies", selected: false, pricedAt: 0.00, imageAt: ""))
            
            
        case .type2:
            options.append(Option(of: "No Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "No Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "No Chive", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Noodles", selected: false, pricedAt: 2.00, imageAt: ""))
            options.append(Option(of: "Extra Meat", selected: false, pricedAt: 3.00, imageAt: ""))
            options.append(Option(of: "Wonton Noodle Soup", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Chive", selected: false, pricedAt: 0.00, imageAt: ""))
            options.append(Option(of: "Extra Vegies", selected: false, pricedAt: 0.00, imageAt: ""))
            
        case .type3:
            options.append(Option(of: "Half Serving", selected: false, pricedAt: -5.5, imageAt: ""))
        }
    }
    
    mutating func addOption(_ option: Option) {
        options.append(option)
    }
}
