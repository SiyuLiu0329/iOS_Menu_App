//
//  OrderList.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

struct Order {
    var items: [MenuItem] = []
    var tableNumber = 0
    var orderTotalPrice: Double = 0
    var orderNumber: Int
    
    init(orderNumber number: Int) {
        self.orderNumber = number
    }
}

class OrderList {
    var allOrders: [Order] = []
    var menuItems: [Int: MenuItem] = [:]
    var currentOrderNumber = 1
    
    init() {
        resetTamplateItem(itemNumber: 0)
    }

    func resetTamplateItem(itemNumber number: Int) {
        menuItems = resetToDefault(forItem: number, in: menuItems)
    }
    
    func newOrder() {
        allOrders.append(Order(orderNumber: currentOrderNumber))
        currentOrderNumber += 1
    }
    
    func addItem(number itemNumber: Int, toOrder orderNumber: Int) {
        if orderNumber > currentOrderNumber || orderNumber < 1 {
            fatalError()
        }
        
        guard let item = menuItems[itemNumber] else { return }
        var matchFound = false
        for i in 0 ..< allOrders[orderNumber - 1].items.count {
            if item == allOrders[orderNumber - 1].items[i] {
                matchFound = true
                allOrders[orderNumber - 1].items[i].quantity += 1
                break
            }
        }
        
        if !matchFound {
            allOrders[orderNumber - 1].items.append(item)
        }
        
        resetTamplateItem(itemNumber: itemNumber)
        print(allOrders[orderNumber - 1].items.count)
    }
    
    func discardLastestOrder() {
        allOrders.removeLast()
        currentOrderNumber -= 1
    }
}
