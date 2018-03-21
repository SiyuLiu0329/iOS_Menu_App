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
    case type1veg
    case type2
    case type3
}

enum PaymentStatus {
    case cash
    case card
    case notPaid
    
}

struct MenuItem: Equatable {
    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool {
        guard lhs.number == rhs.number else { return false }
        guard lhs.unitPrice == rhs.unitPrice else { return false }
        guard lhs.options.count == rhs.options.count else { return false }
        guard lhs.paymentStatus == rhs.paymentStatus else { return false }
        guard lhs.comment == rhs.comment else { return false }
        
        for i in 0 ..< lhs.options.count {
            guard lhs.options[i] == rhs.options[i] else { return false }
        }
        
        return true
    }
    var colour: UIColor = .darkGray
    var number: Int
    var unitPrice: Double {
        willSet {
            totalPrice = newValue * Double(quantity)
        }
    }
    var name: String
    var comment: String?
    var imageURL: String
    var tableNumber: Int?
    var itemType: ItemType
    var paymentStatus: PaymentStatus = .notPaid
    
    var quantity: Int {
        willSet {
            totalPrice = Double(newValue) * unitPrice
        }
    }
    
    var totalPrice: Double
    var options: [Option] = []
    
    init(named name: String, numbered number: Int, itemType type: ItemType, pricedAt price: Double, image imageName: String) {
        self.name = name
        self.number = number
        self.unitPrice =  price
        self.imageURL = imageName
        self.quantity = 1
        self.totalPrice = Double(quantity) * unitPrice
        self.itemType = type
        addDefaultOptions()
        
        //tmp
        colour = Scheme.getColour(withSeed: number)
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
}
