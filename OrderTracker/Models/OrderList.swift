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
        var orderTotalPrice: Double = 0
    }
    
    var allOrders: [CurrentOrder] = []
    var menuItems: [Int: MenuItem] = [:]
    
    private var currentOrder: CurrentOrder = CurrentOrder()
    
    init() {
        resetTamplateItem(itemNumber: 0)
    }
    
    // functions for current item
    func addItem(itemNumber number: Int) {
        guard let tmpItem = menuItems[number] else { return }
        currentOrder.items.append(tmpItem)
        currentOrder.orderTotalPrice += tmpItem.totalPrice
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
    
    func toggleOptionValue(ofOption optionNumber: Int, forItem itemNumber: Int) {
        menuItems[itemNumber]!.options[optionNumber].value = !menuItems[itemNumber]!.options[optionNumber].value
        
        if menuItems[itemNumber]!.options[optionNumber].value == true {
            menuItems[itemNumber]!.unitPrice += menuItems[itemNumber]!.options[optionNumber].price
        } else {
            menuItems[itemNumber]!.unitPrice -= menuItems[itemNumber]!.options[optionNumber].price
        }
    }
    
    func incrementQuantity(forItem number: Int, by amount: Int) {
        guard menuItems[number] != nil,
            menuItems[number]!.quantity >= -amount else { return }
        menuItems[number]!.quantity += amount
    }
    
    func setQuantity(ofItem number: Int, to quantity: Int) {
        guard menuItems[number] != nil else { return }
        menuItems[number]!.quantity = quantity
    }
    
    
    // current order functions
    func getItemsInCurrentOrder() -> [MenuItem] {
        return currentOrder.items
    }
    
    func getItemInCurrentOrder(numberInOrder number: Int) -> MenuItem? {
        return currentOrder.items[number]
    }
    
    func getTotalPriceOfCurrentOrder() -> Double {
        return currentOrder.orderTotalPrice
    }
    
    func removeItemInCurrentOrder(numbered number: Int) {
        let priceToSubtract = currentOrder.items[number].totalPrice
        currentOrder.items.remove(at: number)
        currentOrder.orderTotalPrice -= priceToSubtract
    }
    
    func submitCurrentOrder(asTable number: Int, withPaymentStatus status: PaymentStatus) {
        guard !currentOrder.items.isEmpty else { return } // cannot submit empty orders
        for index in 0...currentOrder.items.count - 1 {
            currentOrder.items[index].changePaymentStatus(to: status)
        }
        
        currentOrder.tableNumber = number
        resetCurrentOrder()
    }
    
    
    private func resetCurrentOrder() {
        for item in currentOrder.items {
            if item.paymentStatus == .notPaid {
                return
            }
            
            print("\(item.name): \(item.unitPrice) X \(item.quantity) = \(item.totalPrice), paid with \(item.paymentStatus)")
        }
        
        print("all paid")
        currentOrder = CurrentOrder()
        
    }
    
    
    // others
    func resetTamplateItem(itemNumber number: Int) {
        menuItems = resetToDefault(forItem: number, in: menuItems)
    }
    

}
