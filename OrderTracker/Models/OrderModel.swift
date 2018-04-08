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
    var currentOrderNumber = 1
    var allOrders: [Order] = []
    
    func getPendingItemsIn(order orderIndex: Int) -> [MenuItem] {
        return allOrders[orderIndex].itemCollections[0]
    }
    
    var isLatestOrderEmpty: Bool {
        return allOrders.last!.itemCollections[0].isEmpty
    }
    
    func refund(paidItem itemIndex: Int, inOrder orderIndex: Int) {
        allOrders[orderIndex].itemCollections[1][itemIndex].refunded = !allOrders[orderIndex].itemCollections[1][itemIndex].refunded
    }
    
    
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
                
            }
            allOrders = allOrders.sorted(by: { $0.orderNumber < $1.orderNumber })
            if !allOrders.isEmpty {
                currentOrderNumber = allOrders.last!.orderNumber + 1
            }
        } catch let error {
            print(error)
        }
    }
    
    
    func getTotalPriceOfPendingItems(inOrder orderIndex: Int) -> Double {
        var totalPrice: Double = 0
        for item in allOrders[orderIndex].itemCollections[0] {
            totalPrice += item.totalPrice
        }
        return totalPrice
    }
    
    func newOrder() {
        allOrders.append(Order(orderNumber: currentOrderNumber))
        sendMessageToClient(type: .addEmptyOrder)
        currentOrderNumber += 1
        sendMessageToClient(type: .newEmptyOrderCreatedByServer) // notify client an order has be created
    }
    
    
    func loadOrder(withIndex index: Int) {
        allOrders[index].isBeingEdited = true
    }
    
    func deletePendingItem(inOrder orderIndex: Int, item itemIndex: Int) {
        let item = allOrders[orderIndex].itemCollections[0][itemIndex]
        allOrders[orderIndex].itemCollections[0].remove(at: itemIndex)
        notifyClientOfItemDeletion(item)
        
    }
    
    func clearPendingItems(inOrder orderIndex: Int) {
        for item in allOrders[orderIndex].itemCollections[0] {
            sendItemsToClient(menuItems: [item], withMessage: .serverDidDeleteItem)
        }
        allOrders[orderIndex].itemCollections[0] = []
    }
    
    func getNumberOfPendingItems(inOrder orderIndex: Int) -> Int {
        return allOrders[orderIndex].numberOfItemsInOrder
    }
    
    func pendItemToOrder(_ orderIndex: Int, item itemToAdd: MenuItem) -> Int {
        var item = itemToAdd
        item.orderIndex = allOrders[orderIndex].orderNumber - 1
        item.itemHash = Scheme.Util.randomString(length: 8)
        sendItemsToClient(menuItems: [item]) // send when an item is added
        for i in 0..<allOrders[orderIndex].itemCollections[0].count {
            if item == allOrders[orderIndex].itemCollections[0][i] {
                allOrders[orderIndex].itemCollections[0].insert(item, at: i)
                return i
            }
        }
        allOrders[orderIndex].itemCollections[0].insert(item, at: 0)
        
        return 0
    }
    
    func getNumberOfSelectionOptions(ofItem itemIndex: Int, inCollection collectionIndex: Int, inOrder orderIndex: Int)  -> Int {
        var nSelected = 0
        let item = allOrders[orderIndex].itemCollections[collectionIndex][itemIndex]
        for option in item.options {
            if option.value {
                nSelected += 1
            }
        }
        return nSelected
    }
    
    private func insertItemToPaidCollection(_ itemToAdd: MenuItem, paymentMethod method: PaymentMethod, order orderIndex: Int) -> Int {
        var item = itemToAdd
        item.paymentStatus = .paid
        if method == .card {
            allOrders[orderIndex].cardSales += item.totalPrice
        } else if method == .cash {
            allOrders[orderIndex].cashSales += item.totalPrice
        } else {
            fatalError()
        }
        for i in 0..<allOrders[orderIndex].itemCollections[1].count {
            if item == allOrders[orderIndex].itemCollections[1][i] {
                allOrders[orderIndex].itemCollections[1].insert(item, at: i)
                return i
            }
        }
        allOrders[orderIndex].itemCollections[1].insert(item, at: 0)
        return 0
    }
    
    // billing single items
    func quickBillTemplateItem(_ itemToAdd: MenuItem, withPaymentMethod method: PaymentMethod, order orderIndex: Int)  -> Int {
        var item = itemToAdd
        item.orderIndex = allOrders[orderIndex].orderNumber - 1
        item.itemHash = Scheme.Util.randomString(length: 8)
        sendItemsToClient(menuItems: [item]) // send
        let index = insertItemToPaidCollection(item, paymentMethod: method, order: orderIndex)
        return index
        
    }
    
    func quickBillPendingItem(withIndex index: Int, withPaymentMethod method: PaymentMethod, order orderIndex: Int) -> Int {
        let item = allOrders[orderIndex].itemCollections[0][index]
        allOrders[orderIndex].itemCollections[0].remove(at: index)
        let index = insertItemToPaidCollection(item, paymentMethod: method, order: orderIndex)
        return index
    }
    
    
    func splitBill(templateItem itemToAdd: MenuItem, cashSales cash: Double, cardSales card: Double, order orderIndex: Int) -> Int {
        var item = itemToAdd
        item.orderIndex = allOrders[orderIndex].orderNumber - 1
        item.itemHash = Scheme.Util.randomString(length: 8)
        let index = splitBill(menuItem: item, cashSales: cash, cardSales: card, order: orderIndex) // send
        sendItemsToClient(menuItems: [item])
        return index

    }
    
    func splitBill(pendingItemIndex index: Int, cashSales cash: Double, cardSales card: Double, order orderIndex: Int) -> Int {
        let item = allOrders[orderIndex].itemCollections[0][index]
        allOrders[orderIndex].itemCollections[0].remove(at: index)
        let index = splitBill(menuItem: item, cashSales: cash, cardSales: card, order: orderIndex) // send
        return index
    }
    
    
    
    private func splitBill(menuItem itemToAdd: MenuItem, cashSales cash: Double, cardSales card: Double, order orderIndex: Int) -> Int {
        var item = itemToAdd
        item.paymentStatus = .paid
        allOrders[orderIndex].cardSales += card
        allOrders[orderIndex].cashSales += cash
        for i in 0..<allOrders[orderIndex].itemCollections[1].count {
            if item == allOrders[orderIndex].itemCollections[1][i] {
                allOrders[orderIndex].itemCollections[1].insert(item, at: i)
                return i
            }
        }
        allOrders[orderIndex].itemCollections[1].insert(item, at: 0)
        return 0
    }
    
    // all pending items
    func billAllPendingItems(inOrder orderIndex: Int, withPaymentMethod method: PaymentMethod) {
        for item in allOrders[orderIndex].itemCollections[0] {
            let _ = insertItemToPaidCollection(item, paymentMethod: method, order: orderIndex)
        }
        allOrders[orderIndex].itemCollections[0].removeAll()
    }
    
    
    func splitBillAllPendingItems(cashSales cash: Double, cardSales card: Double, order orderIndex: Int) {
        allOrders[orderIndex].cashSales += cash
        allOrders[orderIndex].cardSales += card
        var matchFound = false
        for var item in allOrders[orderIndex].itemCollections[0] {
            matchFound = false
            item.paymentStatus = .paid
            for i in 0..<allOrders[orderIndex].itemCollections[1].count {
                if item == allOrders[orderIndex].itemCollections[1][i] {
                    allOrders[orderIndex].itemCollections[1].insert(item, at: i)
                    matchFound = true
                    break
                }
            }
            if !matchFound {
                allOrders[orderIndex].itemCollections[1].insert(item, at: 0)
            }
        }
        allOrders[orderIndex].itemCollections[0].removeAll()
    }
    
    func saveLoadedOrder(orderIndex index: Int) {
        allOrders[index].isBeingEdited = false
        let encoder = JSONEncoder()
        let fileManager = FileManager()
        var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            url = url.appendingPathComponent("\(allOrders[index].orderNumber)" + ".json")
            let data = try encoder.encode(allOrders[index])
            try data.write(to: url)
        } catch let error {
            fatalError("\(error)")
        }
        loadData()
    }
    
    
    func deleteLastestOrder() {
        let orderNumber = allOrders.last!.orderNumber
        allOrders.removeLast()
        let fileManager = FileManager()
        var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            url = url.appendingPathComponent("\(orderNumber)" + ".json")
            try fileManager.removeItem(at: url)
        } catch let error {
            fatalError("\(error)")
        }
        
        sendMessageToClient(type: .deleteLastedOrder)
        loadData()
    }
    
}

extension OrderModel {
    
    func sendInitalOrders() {
        for order in allOrders {
            let items = compile(order)
            sendItemsToClient(menuItems: items)
        }
    }

    private func sendItemsToClient(menuItems items: [MenuItem], withMessage message: MessageType = MessageType.serverToClientItemUpdate) {
        guard let sess = session else { return }
        do {
//            print(items)
            let data = try JSONEncoder().encode(CommunicationProtocol(containingItems: items, numberOfOrders: currentOrderNumber - 1, ofMessageType: message))
            try sess.send(data, toPeers: sess.connectedPeers, with: .reliable)
        } catch let error {
            print(error)
        }
    }
    
    func sendMessageToClient(type messageType: MessageType) {
        guard let sess = session else { return }
        do {
            let data = try JSONEncoder().encode(CommunicationProtocol(containingItems: nil, numberOfOrders: currentOrderNumber - 1, ofMessageType: messageType))
                
            try sess.send(data, toPeers: sess.connectedPeers, with: .reliable)
        } catch {}
    }
    
    private func compile(_ order: Order) -> [MenuItem] {
        var items: [MenuItem] = []
        
        items.append(contentsOf: order.itemCollections[0])
        items.append(contentsOf: order.itemCollections[1])
        
        return items
    }
    
    
    private func notifyClientOfItemDeletion(_ item: MenuItem) {
        sendItemsToClient(menuItems: [item], withMessage: .serverDidDeleteItem)
    }

    
    func markItemsAsServed(_ items: [MenuItem]) -> Int? {
        for item in items {
            for i in 0..<allOrders[item.orderIndex!].itemCollections[0].count {
                if item.itemHash == allOrders[item.orderIndex!].itemCollections[0][i].itemHash {
                    allOrders[item.orderIndex!].itemCollections[0][i].served = !allOrders[item.orderIndex!].itemCollections[0][i].served
                    saveOrderToFile(item.orderIndex!)
                    sendItemsToClient(menuItems: [allOrders[item.orderIndex!].itemCollections[0][i]])
                    return i
                }
                
            }
            for i in 0..<allOrders[item.orderIndex!].itemCollections[1].count {
                if item.itemHash == allOrders[item.orderIndex!].itemCollections[1][i].itemHash {
                    allOrders[item.orderIndex!].itemCollections[1][i].served = !allOrders[item.orderIndex!].itemCollections[1][i].served
                    saveOrderToFile(item.orderIndex!)
                    sendItemsToClient(menuItems: [allOrders[item.orderIndex!].itemCollections[1][i]])
                    return i
                }
                
            }
        }
        return nil
    }
    
    private func saveOrderToFile(_ index: Int) {
        let order = allOrders[index]
        let fileManager = FileManager()
        var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            url = url.appendingPathComponent("\(order.orderNumber)" + ".json")
            let data = try JSONEncoder().encode(allOrders[index])
            try data.write(to: url)
        } catch let error {
            fatalError("\(error)")
        }
    }
}
