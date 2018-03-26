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
    
    var isLatestOrderEmpty: Bool {
        return allOrders.last!.items.isEmpty
    }
    
    var isLoadedOrderEmpty: Bool {
        return loadedOrder!.items.isEmpty
    }
    
    var menuItems: [Int: MenuItem] = [:]
    var currentOrderNumber = 1
    private var loadedOrder: Order?
    // Order
    
    init() {
        resetTamplateItem(itemNumber: 0)
    }
    
    func getTotalNumberOfItemsInLoadedOrder() -> Int {
        var quantity = 0
        for item in loadedOrder!.items {
            quantity += item.quantity
        }
        return quantity
    }
    
    func getTotalPriceOfLoadedOrder() -> Double {
        var totalPrice: Double = 0
        for item in loadedOrder!.items {
            totalPrice += item.totalPrice
        }
        return totalPrice
    }

    func resetTamplateItem(itemNumber number: Int) {
        menuItems = resetToDefault(forItem: number, in: menuItems)
    }
    
    func toggleOptionValue(at optionIndex: Int, inItem itemNumber: Int) {
        menuItems[itemNumber]!.toggleSelectetState(ofOption: optionIndex)
    }
    
    func getValue(ofOption optionIndex: Int, inItem itemNumber: Int) -> Bool {
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
    
    func getNumberOfItemsInLoadedOrder() -> Int {
        return loadedOrder!.items.count
    }
    
    func getItemNamedInLoadedOrder(withIndex index: Int) -> String {
        return loadedOrder!.items[index].name
    }
    
    func getItemNumberInLoadedOrder(withIndex index: Int) -> Int {
        return loadedOrder!.items[index].number
    }
    
    func getItemQuantityInLoadedOrder(withIndex index: Int) -> Int {
        return loadedOrder!.items[index].quantity
    }
    
    func deleteItemInLoadedOrder(withIndex index: Int) {
        loadedOrder!.items.remove(at: index)
    }
    
    func getItemInLoadedOrder(atIndex index: Int) -> MenuItem {
        return loadedOrder!.items[index]
    }
    
    func addItemToLoadedOrder(number itemNumber: Int) -> Int? {
        guard let item = menuItems[itemNumber] else { return nil }
        var matchFound = false
        for i in 0 ..< loadedOrder!.items.count {
            if item == loadedOrder!.items[i] {
                matchFound = true
                loadedOrder!.items[i].quantity += 1
                return i
            }
        }
        
        if !matchFound {
            loadedOrder!.items.append(item)
        }
        return loadedOrder!.items.count - 1
    }


    func getNumberOfSelectedOptions(forItemInLoadedOrder index: Int) -> Int {
        var nSelected = 0
        let item = loadedOrder!.items[index]
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
}
