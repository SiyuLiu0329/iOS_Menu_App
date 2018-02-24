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
    }
    
    func getItem(numbered number: Int) -> MenuItem? {
        return menuItems[number]
    }
    
    func getSubTotal(ofItem number: Int) -> Double {
        guard let item = menuItems[number] else { return 0 }
        return item.totalPrice
    }
    
    func getQuantity(ofItem number: Int) -> Int {
        guard let item = menuItems[number] else { return 0 }
        return item.quantity
    }
    
    func getItemsInCurrentOrder() -> [MenuItem] {
        return currentOrder.items
    }
    
    func getTotalPrice() -> Double {
        return currentOrder.orderTotal
    }
    
    
    func resetTamplateItem(itemNumber number: Int) {
        menuItems = resetToDefault(forItem: number, in: menuItems)
    }
    
    func toggleOptionValue(ofOption optionNumber: Int, forItem itemNumber: Int) {
        menuItems[itemNumber]!.options[optionNumber].value = !menuItems[itemNumber]!.options[optionNumber].value
        
        if menuItems[itemNumber]!.options[optionNumber].value == true {
            menuItems[itemNumber]!.price += menuItems[itemNumber]!.options[optionNumber].price
        } else {
            menuItems[itemNumber]!.price -= menuItems[itemNumber]!.options[optionNumber].price
        }
    }
    
    func incrementQuantity(forItem number: Int, by amount: Int) {
        guard menuItems[number] != nil,
            menuItems[number]!.quantity >= -amount else { return }
        menuItems[number]!.quantity += amount
    }
}
