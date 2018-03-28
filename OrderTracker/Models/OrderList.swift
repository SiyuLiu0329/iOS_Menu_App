//
//  OrderList.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

struct Order {
    var pendingItems: [MenuItem] = []
    var paidItems: [MenuItem] = []
    var tableNumber = 0
    var orderTotalPrice: Double = 0
    var orderNumber: Int
    var numItems: Int = 0
    var orderFinished = false
    
    init(orderNumber number: Int) {
        self.orderNumber = number
    }
    
    mutating func tenderAllPendingItems(withPaymentType paymentType: PaymentStatus) {
        for i in 0..<pendingItems.count {
            pendingItems[i].paymentStatus = paymentType
        }
        paidItems.append(contentsOf: pendingItems)
        pendingItems.removeAll()
    }
}

class OrderList {
    var allOrders: [Order] = []
    
    var isLatestOrderEmpty: Bool {
        return allOrders.last!.pendingItems.isEmpty
    }
    
    var isLoadedOrderEmpty: Bool {
        return loadedOrder!.pendingItems.isEmpty
    }
    
    var menuItems: [Int: MenuItem] = [:]
    var currentOrderNumber = 1
    private var loadedOrder: Order?
    // Order
    
    init() {
        resetTamplateItem(itemNumber: 0)
    }
    
    func getTotalNumberOfItemsInLoadedOrder() -> Int {
        return loadedOrder!.numItems
    }
    
    func getTotalPriceOfPendingItemsInLoadedOrder() -> Double {
        var totalPrice: Double = 0
        for item in loadedOrder!.pendingItems {
            totalPrice += item.totalPrice
        }
        return totalPrice
    }

    func resetTamplateItem(itemNumber number: Int) {
        menuItems = resetToDefault(forItem: number, in: menuItems)
    }
    
    func toggleOptionValue(at optionIndex: Int, inPendingItem itemNumber: Int) {
        menuItems[itemNumber]!.toggleSelectetState(ofOption: optionIndex)
    }
    
    func getValue(ofOption optionIndex: Int, inPendingItem itemNumber: Int) -> Bool {
        return menuItems[itemNumber]!.options[optionIndex].value
    }
    
    func getOptions(inItem itemNumber: Int) -> [Option] {
        return menuItems[itemNumber]!.options
    }
    
    func newOrder() {
        allOrders.append(Order(orderNumber: currentOrderNumber))
        currentOrderNumber += 1
    }
    
    func loadOrder(withIndex index: Int) {
        loadedOrder = allOrders[index]
    }
    
    func saveLoadedOrder(withIndex index: Int) {
        guard let order = loadedOrder else { return }
        allOrders[index] = order
    }
    
    
    func deletePendingItemInLoadedOrder(withIndex index: Int) {
        loadedOrder!.numItems -= loadedOrder!.pendingItems[index].quantity
        loadedOrder!.pendingItems.remove(at: index)
    }
    
    func clearLoadedOrder() {
        loadedOrder!.pendingItems = []
        loadedOrder!.numItems = 0
    }
    
    func addItemToLoadedOrder(number itemNumber: Int) -> Int? {
        guard let item = menuItems[itemNumber] else { return nil }
        var matchFound = false
        loadedOrder!.numItems += 1
        for i in 0 ..< loadedOrder!.pendingItems.count {
            if item == loadedOrder!.pendingItems[i] {
                matchFound = true
                loadedOrder!.pendingItems[i].quantity += 1
                return i
            }
        }
        
        if !matchFound {
            loadedOrder!.pendingItems.append(item)
        }
        
        
        return loadedOrder!.pendingItems.count - 1
    }


    func getNumberOfSelectedOptions(forPendingItemInLoadedOrder index: Int) -> Int {
        var nSelected = 0
        let item = loadedOrder!.pendingItems[index]
        for option in item.options {
            if option.value {
                nSelected += 1
            }
        }
        return nSelected
    }
    
    func getNumberOfSelectedOptions(forPaidItemInLoadedOrder index: Int) -> Int {
        var nSelected = 0
        let item = loadedOrder!.paidItems[index]
        for option in item.options {
            if option.value {
                nSelected += 1
            }
        }
        return nSelected
    }
    
    func getPaidItemsInLoadedOrder() -> [MenuItem] {
        return loadedOrder!.paidItems
    }
    
    func getItemInPaidItems(withIndexInLoadedOrder index: Int) -> MenuItem {
        return loadedOrder!.paidItems[index]
    }
    
    func getItemInPendingItems(withIndexInLoadedOrder index: Int) -> MenuItem {
        return loadedOrder!.pendingItems[index]
    }
    
    func getPendingItemsInLoadedOrder() -> [MenuItem] {
        return loadedOrder!.pendingItems
    }
    
    func discardLastestOrder() {
        allOrders.removeLast()
        currentOrderNumber -= 1
    }
    
    func tenderAllPendingItems(withPaymentType paymentType: PaymentStatus) {
        loadedOrder!.tenderAllPendingItems(withPaymentType: paymentType)
    }
    
    // tender
    func tenderAllItemsInLoadedOrder(usingPaymentMethod paymentMethod: PaymentStatus) {
        for i in 0..<loadedOrder!.pendingItems.count {
            loadedOrder!.pendingItems[i].paymentStatus = paymentMethod
        }
    }
}
