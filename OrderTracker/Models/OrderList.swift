//
//  OrderList.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

enum PaymentMethod {
    case card
    case cash
    case mix
}



class OrderList {
    var loadedItemCollections: [[MenuItem]] {
        return loadedOrder!.itemCollections
    }
    
    func getPendingItemsInLoadedOrder() -> [MenuItem] {
        return loadedOrder!.itemCollections[0]
    }
    
    var allOrders: [Order] = []
    
    var isLatestOrderEmpty: Bool {
        return allOrders.last!.itemCollections[0].isEmpty
    }
    
    var isLoadedOrderEmpty: Bool {
        return loadedOrder!.itemCollections[0].isEmpty
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
        for item in loadedOrder!.itemCollections[0] {
            totalPrice += item.totalPrice
        }
        return totalPrice
    }
    
    func getPriceOfPendingItem(withIndex index: Int) -> Double {
        return loadedOrder!.itemCollections[0][index].totalPrice
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
        loadedOrder!.itemCollections[0].remove(at: index)
    }
    
    func clearPendingItemsLoadedOrder() {
        loadedOrder!.itemCollections[0] = []
    }
    
    func getNumberOfPendingItemsInLoadedOrder() -> Int {
        return loadedOrder!.numberOfItemsInOrder
    }
    
    func pendItemToLoadedOrder(number itemNumber: Int) -> Int? {
        guard let item = menuItems[itemNumber] else { return nil }
        for i in 0 ..< loadedOrder!.itemCollections[0].count {
            if item == loadedOrder!.itemCollections[0][i] {
                loadedOrder!.itemCollections[0][i].quantity += 1
                return i
            }
        }
        loadedOrder!.itemCollections[0].append(item)
        return loadedOrder!.itemCollections[0].count - 1
    }
    
    func getNumberOfSelectedOptions(inCollection collectionIndex: Int, forItem index: Int) -> Int {
        var nSelected = 0
        let item = loadedOrder!.itemCollections[collectionIndex][index]
        for option in item.options {
            if option.value {
                nSelected += 1
            }
        }
        return nSelected
    }
    
    func billAllPendingItems(withPaymentMethod method: PaymentMethod) {
        for var item in loadedOrder!.itemCollections[0] {
            item.paymentStatus = .paid
            if method == .card {
                loadedOrder!.cardSales += item.totalPrice
            } else if method == .cash {
                loadedOrder!.cashSales += item.totalPrice
            }
            
            if loadedOrder!.itemCollections[1].isEmpty {
                loadedOrder!.itemCollections[1].append(item)
                continue
            }
            
            var matchFound = false
            for i in 0..<loadedOrder!.itemCollections[1].count {
                if item == loadedOrder!.itemCollections[1][i] {
                    loadedOrder!.itemCollections[1][i].quantity += item.quantity
                    matchFound = true
                    break
                }
                
            }
            
            if !matchFound {
                loadedOrder!.itemCollections[1].append(item)
            }
        }
        loadedOrder!.itemCollections[0].removeAll()
        print(loadedOrder!.cardSales, loadedOrder!.cashSales)
    }
    
    func quickBillPendingItem(withIndex index: Int, withPaymentMethod method: PaymentMethod) -> (Int, Bool) {
        var item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        item.paymentStatus = .paid
        
        if method == .card {
            loadedOrder!.cardSales += item.totalPrice
        } else if method == .cash {
            loadedOrder!.cashSales += item.totalPrice
        } else {
            fatalError()
        }
        // move this item to paid items
        for i in 0..<loadedOrder!.itemCollections[1].count {
            if item == loadedOrder!.itemCollections[1][i] {
                loadedOrder!.itemCollections[1][i].quantity += item.quantity
                return (i, false)
            }
        }
        loadedOrder!.itemCollections[1].insert(item, at: 0)
        
        return (0, true)
    }
    
    func quickBillTemplateItem(withNumber number: Int, withPaymentMethod method: PaymentMethod)  -> (Int, Bool) {
        var item = menuItems[number]!
        item.paymentStatus = .paid
        if method == .card {
            loadedOrder!.cardSales += item.totalPrice
        } else if method == .cash {
            loadedOrder!.cashSales += item.totalPrice
        } else {
            fatalError()
        }
        
        for i in 0..<loadedOrder!.itemCollections[1].count {
            if item == loadedOrder!.itemCollections[1][i] {
                loadedOrder!.itemCollections[1][i].quantity += item.quantity
                return (i, false)
            }
        }
        loadedOrder!.itemCollections[1].insert(item, at: 0)
        
        return (0, true)
    }
    
    func discardLastestOrder() {
        allOrders.removeLast()
        currentOrderNumber -= 1
    }

    
}
