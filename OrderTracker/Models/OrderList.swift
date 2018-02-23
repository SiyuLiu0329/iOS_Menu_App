//
//  OrderList.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

class OrderList {
    struct CurrentOrder {
        var items: [MenuItem] = []
        var tableNumber = 0
        var orderTotal: Double = 0
    }
    
    var allOrders: [CurrentOrder] = []
    var menuItems: [Int: MenuItem] = [:]
    
    private var currentOrder: CurrentOrder = CurrentOrder()
    
    init() {
        resetTamplateItem(itemNumber: 0)
    }
    
    func addItem(itemNumber number: Int) {
        guard let tmpItem = menuItems[number] else { return }
        currentOrder.items.append(tmpItem)
        currentOrder.orderTotal += tmpItem.totalPrice
        resetTamplateItem(itemNumber: number)
        print(currentOrder)
    }
    
    private func newOrder() {
        currentOrder = CurrentOrder()
    }

    
    private func resetTamplateItem(itemNumber number: Int) {
        menuItems = resetToDefault(forItem: number, in: menuItems)

    }
    
    func toggleOptionValue(ofOption optionNumber: Int, forItem itemNumber: Int) {
        menuItems[itemNumber]!.options[optionNumber].value = !menuItems[itemNumber]!.options[optionNumber].value
    }
    
    func incrementQuantity(forItem number: Int, by amount: Int) {
        guard menuItems[number] != nil,
            menuItems[number]!.quantity >= -amount else { return }
        menuItems[number]!.quantity += amount
    }
}
