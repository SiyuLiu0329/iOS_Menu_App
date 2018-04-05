//
//  Items.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

enum ItemType: Int, Codable {
    
    // different options for each type
    case type1
    case type1veg
    case type2
    case type3
}

enum PaymentStatus: Int, Codable {
    case paid
    case notPaid
}

struct MenuItem: Equatable, Codable {
    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool {
        guard lhs.number == rhs.number else { return false }
        return true
    }
    
    struct themeColour: Codable {
        var r: Double
        var g: Double
        var b: Double
        init(red r: Double, green g: Double, blue b: Double) {
            self.r = r
            self.g = g
            self.b = b
        }
    }
    
    var colour: themeColour
    var number: Int
    var unitPrice: Double
    var name: String
    var comment: String?
    var imageURL: String
    var orderIndex: Int?
    var tableNumber: Int?
    var indexInOrder: Int?
    var itemType: ItemType
    var paymentStatus: PaymentStatus = .notPaid
    var served = false
    var quantity: Int
    
    var totalPrice: Double {
        return unitPrice * Double(quantity)
    }
    var options: [Option] = []
    
    init(named name: String, numbered number: Int, itemType type: ItemType, pricedAt price: Double, image imageName: String) {
        self.name = name
        self.number = number
        self.unitPrice =  price
        self.imageURL = imageName
        self.quantity = 1
        self.itemType = type
        let rgb = Scheme.getColour(withSeed: number)
        colour = themeColour(red: rgb.r, green: rgb.g, blue: rgb.b)
        addDefaultOptions()
    }
    
    mutating private func addDefaultOptions() {
        options = addDefaultOptionsUtl(for: itemType)
    }
    
    mutating func addOption(_ option: Option) {
        options.append(option)
    }
    
    mutating func changePaymentStatus(to status: PaymentStatus) {
        paymentStatus = status
    }
    
    mutating func toggleSelectetState(ofOption index: Int) {
        options[index].value = !options[index].value
        unitPrice += (options[index].value) ? options[index].price : -options[index].price
    }
}
