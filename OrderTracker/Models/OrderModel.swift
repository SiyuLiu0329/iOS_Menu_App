//
//  orderModel.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum PaymentMethod {
    case card
    case cash
    case mix
}

class OrderModel {
    var session: MCSession?
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
                let json = try Data.init(contentsOf: file)
                let order = try decoer.decode(Order.self, from: json)
                allOrders.append(order)
                currentOrderNumber += 1
            }
            allOrders = allOrders.sorted(by: { $0.orderNumber < $1.orderNumber })
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
        sendMessageToClient(type: .newEmptyOrderCreatedByServer) // notify client an order has be created
    }
    
    func loadOrder(withIndex index: Int) {
        loadedOrder = allOrders[index]
        allOrders[index].isBeingEdited = true
    }
    
    func deletePendingItemInLoadedOrder(withIndex index: Int) {
        let item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        notifyClientOfItemDeletion(item)
        
    }
    
    func clearPendingItemsLoadedOrder() {
        loadedOrder!.itemCollections[0] = []
    }
    
    func getNumberOfPendingItemsInLoadedOrder() -> Int {
        return loadedOrder!.numberOfItemsInOrder
    }
    
    func pendItemToLoadedOrder(_ itemToAdd: MenuItem) -> Int? {
        var item = itemToAdd
        item.orderIndex = loadedOrder!.orderNumber - 1
        item.indexInOrder = loadedOrder!.itemCollections[0].count + loadedOrder!.itemCollections[1].count //arrival index
        sendItemsToClient(menuItems: [item]) // send when an item is added
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
    
    // billing single items
    func quickBillTemplateItem(_ itemToAdd: MenuItem, withPaymentMethod method: PaymentMethod)  -> Int {
        var item = itemToAdd
        item.orderIndex = loadedOrder!.orderNumber - 1
        item.indexInOrder = loadedOrder!.itemCollections[0].count + loadedOrder!.itemCollections[1].count //arrival index
        sendItemsToClient(menuItems: [item]) // send
        let index = insertItemToPaidItems(item, paymentMethod: method)
        return index
        
    }
    
    func quickBillPendingItem(withIndex index: Int, withPaymentMethod method: PaymentMethod) -> Int {
        let item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        let index = insertItemToPaidItems(item, paymentMethod: method)
        sendItemsToClient(menuItems: [item]) // send
        return index
    }
    
    func discardLastestOrder() {
        allOrders.removeLast()
//        sendOrderThroughSession(nil, usingProtocolType: .discardLastOrder)
        currentOrderNumber -= 1
    }
    
    
    func splitBill(templateItem itemToAdd: MenuItem, cashSales cash: Double, cardSales card: Double) -> Int {
        var item = itemToAdd
        item.orderIndex = loadedOrder!.orderNumber - 1
        item.indexInOrder = loadedOrder!.itemCollections[0].count + loadedOrder!.itemCollections[1].count //arrival index
        let index = splitBill(menuItem: item, cashSales: cash, cardSales: card) // send
        return index

    }
    
    func splitBill(pendingItemIndex index: Int, cashSales cash: Double, cardSales card: Double) -> Int {
        let item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        let index = splitBill(menuItem: item, cashSales: cash, cardSales: card) // send
        return index
    }
    
    private func splitBill(menuItem itemToAdd: MenuItem, cashSales cash: Double, cardSales card: Double) -> Int {
        var item = itemToAdd
        item.paymentStatus = .paid
        loadedOrder!.cardSales += card
        loadedOrder!.cashSales += cash
        sendItemsToClient(menuItems: [itemToAdd]) // only one item needs to be sent?
        for i in 0..<loadedItemCollections[1].count {
            if item == loadedItemCollections[1][i] {
                loadedOrder!.itemCollections[1].insert(item, at: i)
                return i
            }
        }
        
        loadedOrder!.itemCollections[1].insert(item, at: 0)
        
        return 0
    }
    
    // all pending items
    func billAllPendingItems(withPaymentMethod method: PaymentMethod) {
        for item in loadedOrder!.itemCollections[0] {
            let _ = insertItemToPaidItems(item, paymentMethod: method)
        }
        loadedOrder!.itemCollections[0].removeAll()
//        sendAllItems(inOrder: loadedOrder!) // update all
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
        
//        sendAllItems(inOrder: loadedOrder!) // send order
    }
    
    func saveLoadedOrder(withIndex index: Int) {
        guard let order = loadedOrder else { return }
        loadedOrder!.isBeingEdited = false
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
//        sendAllItems(inOrder: loadedOrder!) // send all
        loadData()
    }
    
    func getQuantityOfPendingItem(withIndex index: Int) -> Int {
        return loadedItemCollections[0][index].quantity
    }
    
}

extension OrderModel {
    
    func sendAllItems(inOrder order: Order) {
        var items: [MenuItem] = []
        items.append(contentsOf: order.itemCollections[0])
        items.append(contentsOf: order.itemCollections[1])
        sendItemsToClient(menuItems: items)
    }

    private func sendItemsToClient(menuItems items: [MenuItem], withMessage message: MessageType = MessageType.serverToClientItemUpdate) {
        guard let sess = session else { return }
        do {
            let data = try JSONEncoder().encode(CommunicationProtocol(containingItems: items, numberOfOrders: currentOrderNumber - 1, ofMessageType: message))
            try sess.send(data, toPeers: sess.connectedPeers, with: .reliable)
        } catch {}
    }
    
    func sendMessageToClient(type messageType: MessageType) {
        guard let sess = session else { return }
        do {
            let data = try JSONEncoder().encode(CommunicationProtocol(containingItems: nil, numberOfOrders: nil, ofMessageType: messageType))
                
            try sess.send(data, toPeers: sess.connectedPeers, with: .reliable)
        } catch {}
    }
    
    private func compile(_ orders: [Order]) -> [MenuItem] {
        var items: [MenuItem] = []
        for order in orders {
            items.append(contentsOf: order.itemCollections[0])
            items.append(contentsOf: order.itemCollections[1])
        }
        return items
    }
    
    func sendInitialOrdersToClient() {
        let items = compile(allOrders)
        sendItemsToClient(menuItems: items)
    }
    
    private func notifyClientOfItemDeletion(_ item: MenuItem) {
        sendItemsToClient(menuItems: [item], withMessage: .serverDidDeleteItem)
    }
}
