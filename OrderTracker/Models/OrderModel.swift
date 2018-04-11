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
    var billBuffer: [MenuItem] = []
    
    var billBufferPrice: Double {
        var price: Double = 0
        for item in billBuffer {
            price += item.totalPrice
        }
        return price
    }
    
    func select(item itemIndex: Int, inOrder orderIndex: Int) {
        allOrders[orderIndex].itemCollections[0][itemIndex].isInBuffer = !allOrders[orderIndex].itemCollections[0][itemIndex].isInBuffer
        let item = allOrders[orderIndex].itemCollections[0][itemIndex]
        if item.isInBuffer {
            billBuffer.append(item)
        } else {
            // remove item with matching hash
            billBuffer = billBuffer.filter({$0.itemHash != item.itemHash})
            
        }
        
    }
    
    func getPendingItemsIn(order orderIndex: Int) -> [MenuItem] {
        return allOrders[orderIndex].itemCollections[0]
    }
    
    var isLatestOrderEmpty: Bool {
        return allOrders.last!.itemCollections[0].isEmpty
    }
    
    func refund(paidItem itemIndex: Int, inOrder orderIndex: Int) {
        allOrders[orderIndex].itemCollections[1][itemIndex].refunded = !allOrders[orderIndex].itemCollections[1][itemIndex].refunded
        let item = allOrders[orderIndex].itemCollections[1][itemIndex]
        if allOrders[orderIndex].itemCollections[1][itemIndex].refunded {
            // ask client to remove this item since its no longer needed
            sendItemsToClient(menuItems: [item], withMessage: .serverDidDeleteItem)
            allOrders[orderIndex].refundedAmount += item.totalPrice
        } else {
            // make the item reappear on client side again
            sendItemsToClient(menuItems: [item])
            allOrders[orderIndex].refundedAmount -= item.totalPrice
        }
        
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
            let files = try fileManager.contentsOfDirectory(at: documentsURL.appendingPathComponent("orders"), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
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
        billBuffer = allOrders[index].itemCollections[0]
    }
    
    func deletePendingItem(inOrder orderIndex: Int, item itemIndex: Int) {
        let item = allOrders[orderIndex].itemCollections[0][itemIndex]
        billBuffer = billBuffer.filter({$0.itemHash != item.itemHash})
        allOrders[orderIndex].itemCollections[0].remove(at: itemIndex)
        notifyClientOfItemDeletion(item)
        
    }
    
    func clearPendingItems(inOrder orderIndex: Int) {
        for item in allOrders[orderIndex].itemCollections[0] {
            sendItemsToClient(menuItems: [item], withMessage: .serverDidDeleteItem)
        }
        billBuffer = []
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
        billBuffer.append(item)
        if let index = allOrders[orderIndex].itemCollections[0].index(where: {$0 == item}) {
            allOrders[orderIndex].itemCollections[0].insert(item, at: index)
            return index
        }
        allOrders[orderIndex].itemCollections[0].insert(item, at: 0)
        
        return 0
    }
    
    func getNumberOfSelectionOptions(ofItem itemIndex: Int, inCollection collectionIndex: Int, inOrder orderIndex: Int)  -> Int {
        let item = allOrders[orderIndex].itemCollections[collectionIndex][itemIndex]
        return item.options.filter({$0.value}).count
    }
    
    private func insertItemToPaidCollection(_ itemToAdd: MenuItem, paymentMethod method: PaymentMethod, order orderIndex: Int) -> Int {
        var item = itemToAdd
        item.paymentStatus = .paid
        if method == .card {
            allOrders[orderIndex].cardSales += item.totalPrice
        } else if method == .cash {
            allOrders[orderIndex].cashSales += item.totalPrice
        }
        if let index = allOrders[orderIndex].itemCollections[1].index(where: {$0 == item}) {
            allOrders[orderIndex].itemCollections[1].insert(item, at: index)
            return index
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
    
    func splitBill(templateItem itemToAdd: MenuItem, cashSales cash: Double, cardSales card: Double, order orderIndex: Int) -> Int {
        var item = itemToAdd
        item.orderIndex = allOrders[orderIndex].orderNumber - 1
        item.itemHash = Scheme.Util.randomString(length: 8)
        let index = splitBill(menuItem: item, cashSales: cash, cardSales: card, order: orderIndex) // send
        sendItemsToClient(menuItems: [item])
        return index
        
    }
    
    func bill(itemsInBuffer items: [MenuItem], paymentMethod method: PaymentMethod, inOrder orderIndex: Int) {
        for item in items {
            _ = insertItemToPaidCollection(item, paymentMethod: method, order: orderIndex)
             cleanUpAfterBilling(forItem: item, inOrder: orderIndex)
        }
    }
    
    func splitBill(itemsInBuffer items: [MenuItem], cash cashSales: Double, card cardSales: Double, inOrder orderIndex: Int) {
        allOrders[orderIndex].cashSales += cashSales
        allOrders[orderIndex].cardSales += cardSales
        for item in items {
            _ = insertItemToPaidCollection(item, paymentMethod: .mix, order: orderIndex)
            cleanUpAfterBilling(forItem: item, inOrder: orderIndex)
            
        }
    }
    
    private func cleanUpAfterBilling(forItem item: MenuItem, inOrder orderIndex: Int) {
        billBuffer = billBuffer.filter({$0.itemHash != item.itemHash})
        allOrders[orderIndex].itemCollections[0] = allOrders[orderIndex].itemCollections[0].filter({$0.itemHash != item.itemHash})
    }
    
    
    
    private func splitBill(menuItem itemToAdd: MenuItem, cashSales cash: Double, cardSales card: Double, order orderIndex: Int) -> Int {
        var item = itemToAdd
        item.paymentStatus = .paid
        allOrders[orderIndex].cardSales += card
        allOrders[orderIndex].cashSales += cash
        if let index = allOrders[orderIndex].itemCollections[1].index(where: {$0 == item}) {
            allOrders[orderIndex].itemCollections[1].insert(item, at: index)
            return index
        }
        allOrders[orderIndex].itemCollections[1].insert(item, at: 0)
        return 0
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
        for item in order.itemCollections[0] {
            if !item.refunded {
                items.append(item)
            }
        }
        for item in order.itemCollections[1] {
            if !item.refunded {
                items.append(item)
            }
        }
        return items
    }
    
    
    private func notifyClientOfItemDeletion(_ item: MenuItem) {
        sendItemsToClient(menuItems: [item], withMessage: .serverDidDeleteItem)
    }
    
    
    func markItemAsServed(_ item: MenuItem) -> Int? {
        // find the item match the hash and return its index after action
        for i in 0..<allOrders[item.orderIndex!].itemCollections[0].count {
            if item.itemHash == allOrders[item.orderIndex!].itemCollections[0][i].itemHash {
                // matching hash...
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
            
        // no match found, should not happen.
        return nil
    }
    
    func closeAndSave(order index: Int) {
        for i in 0..<allOrders[index].itemCollections[0].count {
            allOrders[index].itemCollections[0][i].isInBuffer = true
        }
        saveOrderToFile(index)
    }
    
    
    func saveOrderToFile(_ index: Int) {
        
        let order = allOrders[index]
        let fileManager = FileManager()
        var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            url = url.appendingPathComponent("orders")
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            url = url.appendingPathComponent("\(order.orderNumber)" + ".json")
            let data = try JSONEncoder().encode(allOrders[index])
            try data.write(to: url)
        } catch let error {
            fatalError("\(error)")
        }
    }
}
