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
    
    mutating func tender(pendingItem index: Int, withPaymentMethod paymentMethod: PaymentStatus) -> Int {
        var pendingItem = itemCollections[0].items[index]
        pendingItem.paymentStatus = paymentMethod
        itemCollections[0].items.remove(at: index)
        for i in 0..<itemCollections[1].items.count {
            if pendingItem == itemCollections[1].items[i] {
                itemCollections[1].items[i].quantity += pendingItem.quantity
                print(i)
                return i
            }
        }
        // no match found if reaches this point
        itemCollections[1].items.append(pendingItem)
        return itemCollections[1].items.count - 1
    }
    
    mutating func tenderAllPendingItems(withPaymentType paymentType: PaymentStatus) -> [Int] {
        var res: [Int] = []
        let pendingItems = itemCollections[0].items
        for i in 0..<pendingItems.count {
            var item = pendingItems[i]
            var matchFound = false
            item.paymentStatus = paymentType
            for j in 0..<itemCollections[1].items.count {
                if item == itemCollections[1].items[j] {
                    itemCollections[1].items[j].quantity += item.quantity
                    res.append(j)
                    matchFound = true
                    break
                }
                // no item found if the reaches here
            }
            if !matchFound {
                res.append(itemCollections[1].items.count)
                itemCollections[1].items.append(item)
            }
            
        }
        itemCollections[0].items.removeAll()
        
        return res
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
    
    func getPriceOfPendingItem(withIndex index: Int) -> Double {
        return loadedOrder!.itemCollections[0].items[index].totalPrice
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
        for i in 0 ..< loadedOrder!.itemCollections[0].items.count {
            if item == loadedOrder!.itemCollections[0].items[i] {
                loadedOrder!.itemCollections[0].items[i].quantity += 1
                return i
            }
        }
        loadedOrder!.itemCollections[0].items.append(item)
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
    
    func tender(pendingItem index: Int, withPaymentMethod paymentMethod: PaymentStatus) -> Int {
        return loadedOrder!.tender(pendingItem: index, withPaymentMethod: paymentMethod)
    }
    
    func quickTenderTemplateItem(numbered number: Int, withPaymentMethod paymentMethod: PaymentStatus) -> Int {
        var item = menuItems[number]!
        item.paymentStatus = paymentMethod
        for i in 0..<loadedOrder!.itemCollections[1].items.count {
            if item == loadedOrder!.itemCollections[1].items[i] {
                loadedOrder!.itemCollections[1].items[i].quantity += 1
                return i
            }
        }
        loadedOrder!.itemCollections[1].items.append(item)
        return loadedOrder!.itemCollections[1].items.count - 1
    }
    
    func discardLastestOrder() {
        allOrders.removeLast()
        currentOrderNumber -= 1
    }
    
    func tenderAllPendingItems(withPaymentType paymentType: PaymentStatus) -> [Int] {
        return loadedOrder!.tenderAllPendingItems(withPaymentType: paymentType)
    }
    
}
