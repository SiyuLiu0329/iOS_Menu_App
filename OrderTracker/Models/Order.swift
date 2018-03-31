//
//  Order.swift
//  OrderTracker
//
//  Created by Siyu Liu on 31/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

struct Order: Codable {
    
    var itemCollections: [[MenuItem]] = []
    var tableNumber = 0
    var orderTotalPrice: Double = 0
    var orderNumber: Int
    var orderFinished = false
    var cardSales: Double = 0
    var cashSales: Double = 0
    var numberOfItemsInOrder: Int {
        var num = 0
        for item in itemCollections[0] {
            num += item.quantity
        }
        return num
    }
    
    init(orderNumber number: Int) {
        self.orderNumber = number
        itemCollections.append([])
        itemCollections.append([])
    }
}
