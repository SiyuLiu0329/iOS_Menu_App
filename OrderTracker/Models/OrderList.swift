//
//  OrderList.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
typealias ItemCollection = (collectionName: String, items: [MenuItem])

struct Order {
   
    var itemCollections: [ItemCollection] = []
    var tableNumber = 0
    var orderTotalPrice: Double = 0
    var orderNumber: Int
    var orderFinished = false
    
    
    init(orderNumber number: Int) {
        self.orderNumber = number
        itemCollections.append(("Pending", []))
        itemCollections.append(("Paid", []))
    }
    
    mutating func tenderAllPendingItems(withPaymentType paymentType: PaymentStatus) {
        for i in 0..<itemCollections[0].items.count {
            itemCollections[0].items[i].paymentStatus = paymentType
        }
        itemCollections[1].items.append(contentsOf: itemCollections[0].items)
        itemCollections[0].items.removeAll()
    }
}

class OrderList {
    var loadedItemCollections: [ItemCollection] {
        return loadedOrder!.itemCollections
    }
    
    var allOrders: [Order] = []
    
    var isLatestOrderEmpty: Bool {
        return allOrders.last!.itemCollections[0].items.isEmpty
    }
    
    var isLoadedOrderEmpty: Bool {
        return loadedOrder!.itemCollections[0].items.isEmpty
    }
    
    var menuItems: [Int: MenuItem] = [:]
    var currentOrderNumber = 1
    private var loadedOrder: Order?
    // Order
    
    init() {
        resetTamplateItem(itemNumber: 0)
    }
    
    func getTotalPriceOfPendingItemsInLoadedOrder() -> Double {
        var totalPrice: Double = 0
        for item in loadedOrder!.itemCollections[0].items {
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
        loadedOrder!.itemCollections[0].items.remove(at: index)
    }
    
    func clearPendingItemsLoadedOrder() {
        loadedOrder!.itemCollections[0].items = []
    }
    
    func pendItemToLoadedOrder(number itemNumber: Int) -> Int? {
        guard let item = menuItems[itemNumber] else { return nil }
        var matchFound = false
        for i in 0 ..< loadedOrder!.itemCollections[0].items.count {
            if item == loadedOrder!.itemCollections[0].items[i] {
                matchFound = true
                loadedOrder!.itemCollections[0].items[i].quantity += 1
                return i
            }
        }
        
        if !matchFound {
            loadedOrder!.itemCollections[0].items.append(item)
        }
        
        
        return loadedOrder!.itemCollections[0].items.count - 1
    }
    
    func getNumberOfSelectedOptions(inCollection collectionIndex: Int, forItem index: Int) -> Int {
        var nSelected = 0
        let item = loadedOrder!.itemCollections[collectionIndex].items[index]
        for option in item.options {
            if option.value {
                nSelected += 1
            }
        }
        return nSelected
    }
    
    
    
    func discardLastestOrder() {
        allOrders.removeLast()
        currentOrderNumber -= 1
    }
    
    func tenderAllPendingItems(withPaymentType paymentType: PaymentStatus) {
        loadedOrder!.tenderAllPendingItems(withPaymentType: paymentType)
    }
    
}
