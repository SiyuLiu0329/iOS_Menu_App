//
//  orderModel.swift
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

class OrderModel {
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
    
//    var menuItems: [Int: MenuItem] = [:]

    var currentOrderNumber = 1
    private var loadedOrder: Order?
    // Order
    
    init() {
        loadData()
    }
    
    private func loadData() {
        allOrders.removeAll()
        currentOrderNumber = 1
        let fileManager = FileManager()
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let decoer = JSONDecoder()
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for file in files {
//                print(file)
                let json = try Data.init(contentsOf: file)
                allOrders.append(try decoer.decode(Order.self, from: json))
                currentOrderNumber += 1
            }
        } catch let error {
            print(error)
        }
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
    
    func newOrder() {
        allOrders.append(Order(orderNumber: currentOrderNumber))
        currentOrderNumber += 1
    }
    
    func loadOrder(withIndex index: Int) {
        loadedOrder = allOrders[index]
    }
    
    func saveLoadedOrder(withIndex index: Int) {
        guard let order = loadedOrder else { return }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let fileManager = FileManager()
        var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            url = url.appendingPathComponent("\(order.orderNumber)" + ".json")
            let data = try encoder.encode(order)
            try data.write(to: url)
        } catch let error {
            fatalError("\(error)")
        }
        
//        allOrders[index] = order
        loadData()
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
    
    func pendItemToLoadedOrder(_ item: MenuItem) -> Int? {
        for i in 0..<loadedItemCollections[0].count {
            if item == loadedItemCollections[0][i] {
                loadedOrder!.itemCollections[0].insert(item, at: i)
                return i
            }
        }
        loadedOrder!.itemCollections[0].insert(item, at: 0)
        return 0
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
        for item in loadedOrder!.itemCollections[0] {
            let _ = insertItemToPaidItems(item, paymentMethod: method)
        }
        loadedOrder!.itemCollections[0].removeAll()
    }
    
    func quickBillPendingItem(withIndex index: Int, withPaymentMethod method: PaymentMethod) -> Int {
        let item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        return insertItemToPaidItems(item, paymentMethod: method)
    }
    
    private func insertItemToPaidItems(_ itemToAdd: MenuItem, paymentMethod method: PaymentMethod) -> Int {
        var item = itemToAdd
        item.paymentStatus = .paid
        if method == .card {
            loadedOrder!.cardSales += item.totalPrice
        } else if method == .cash {
            loadedOrder!.cashSales += item.totalPrice
        } else {
            fatalError()
        }
        for i in 0..<loadedItemCollections[1].count {
            if item == loadedItemCollections[1][i] {
                loadedOrder!.itemCollections[1].insert(item, at: i)
                return i
            }
        }
        
        loadedOrder!.itemCollections[1].insert(item, at: 0)
        
        return 0
    }
    
    func quickBillTemplateItem(_ item: MenuItem, withPaymentMethod method: PaymentMethod)  -> Int {
        return insertItemToPaidItems(item, paymentMethod: method)
    }
    
    func discardLastestOrder() {
        allOrders.removeLast()
        currentOrderNumber -= 1
    }
    
    func splitBill(templateItem item: MenuItem, cashSales cash: Double, cardSales card: Double) -> Int {
        return splitBill(menuItem: item, cashSales: cash, cardSales: card)

    }
    
    func splitBill(pendingItemIndex index: Int, cashSales cash: Double, cardSales card: Double) -> Int {
        let item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        return splitBill(menuItem: item, cashSales: cash, cardSales: card)
    }
    
    private func splitBill(menuItem itemToAdd: MenuItem, cashSales cash: Double, cardSales card: Double) -> Int {
        var item = itemToAdd
        item.paymentStatus = .paid
        loadedOrder!.cardSales += card
        loadedOrder!.cashSales += cash
        for i in 0..<loadedItemCollections[1].count {
            if item == loadedItemCollections[1][i] {
                loadedOrder!.itemCollections[1].insert(item, at: i)
                return i
            }
        }
        
        loadedOrder!.itemCollections[1].insert(item, at: 0)
        
        return 0
    }
    
    func splitBillAllPendingItems(cashSales cash: Double, cardSales card: Double) {
        loadedOrder!.cashSales += cash
        loadedOrder!.cardSales += card
        var matchFound = false
        for var item in loadedOrder!.itemCollections[0] {
            matchFound = false
            item.paymentStatus = .paid
            for i in 0..<loadedItemCollections[1].count {
                if item == loadedItemCollections[1][i] {
                    loadedOrder!.itemCollections[1].insert(item, at: i)
                    matchFound = true
                    break
                }
            }
            if !matchFound {
                loadedOrder!.itemCollections[1].insert(item, at: 0)
            }
        }
        loadedOrder!.itemCollections[0].removeAll()
    }
    
    func getQuantityOfPendingItem(withIndex index: Int) -> Int {
        return loadedItemCollections[0][index].quantity
    }

    
}
