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
//                print(file)
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
    }
    
    func loadOrder(withIndex index: Int) {
        loadedOrder = allOrders[index]
        allOrders[index].isBeingEdited = true
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
        
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
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
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
    }
    
    func quickBillPendingItem(withIndex index: Int, withPaymentMethod method: PaymentMethod) -> Int {
        let item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        let index = insertItemToPaidItems(item, paymentMethod: method)
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
        return index
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
        let index = insertItemToPaidItems(item, paymentMethod: method)
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
        return index
        
    }
    
    func discardLastestOrder() {
        allOrders.removeLast()
        currentOrderNumber -= 1
    }
    
    func splitBill(templateItem item: MenuItem, cashSales cash: Double, cardSales card: Double) -> Int {
        let index = splitBill(menuItem: item, cashSales: cash, cardSales: card)
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
        return index

    }
    
    func splitBill(pendingItemIndex index: Int, cashSales cash: Double, cardSales card: Double) -> Int {
        let item = loadedOrder!.itemCollections[0][index]
        loadedOrder!.itemCollections[0].remove(at: index)
        let index = splitBill(menuItem: item, cashSales: cash, cardSales: card)
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
        return index
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
        
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
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
        
        sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
    }
    
    func getQuantityOfPendingItem(withIndex index: Int) -> Int {
        return loadedItemCollections[0][index].quantity
    }
    
}

extension OrderModel {
    func sendOrderBeforeChange(withIndex index: Int) {
        guard index < allOrders.count else { return }
        allOrders[index].isBeingEdited = false
        sendOrderThroughSession(allOrders[index], usingProtocolType: .serverToClientOrderUpdate)
    }
    
    func finishOrder(orderIndex index: Int) {
        if index == loadedOrder!.orderNumber - 1 && allOrders[index].isBeingEdited {
            loadedOrder!.markAllItemsAsServed()
            sendOrderThroughSession(loadedOrder!, usingProtocolType: .serverToClientOrderUpdate)
        } else {
            allOrders[index].markAllItemsAsServed()
            sendOrderThroughSession(allOrders[index], usingProtocolType: .serverToClientOrderUpdate)
        }
    }
    
    private func sendOrderThroughSession(_ order: Order, usingProtocolType type: MessageType) {
        guard let sess = session else { return }
        do {
            let message =  CommunicationProtocol(containingOrder: order, ofMessageType: type)
            let data = try JSONEncoder().encode(message)
            try sess.send(data, toPeers: sess.connectedPeers, with: .reliable)
        } catch let error {
            print(error)
        }
    }
    
    func sendInitialOrdersToClient() {
        for order in allOrders {
            sendOrderThroughSession(order, usingProtocolType: .serverToClientOrderUpdate)
        }
    }
}
