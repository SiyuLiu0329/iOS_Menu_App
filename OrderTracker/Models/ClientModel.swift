//
//  ClientModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct ClientOrder {
    var items: [MenuItem] = []
    var tableNumber = 0
    var orderNumber = 0
}

class ClientModel {
    var session: MCSession!
    var orders: [ClientOrder] = []
    
    func reciveItemsFromServer(_ items: [MenuItem], numberOfOrders nOrders: Int) -> (insertionIndex: Int, isNewOrder: Bool, isItemInserted: Bool)? {
        var isNewOrder = false
        // since only items are sent here, need to check if the order the item should be added to already exists, if not create it
        if nOrders > orders.count {
            // create empty orders
            for _ in 0..<nOrders - orders.count {
                var order = ClientOrder()
                order.orderNumber = orders.count + 1
                orders.append(order) // empty order
                isNewOrder = true
            }
        }
        
        if items.count == 1 {
            let res = insert(items.first!)
            return (res.index, isNewOrder, res.inserted)
        }
        
        for item in items {
            _ = insert(item)
        }
        // multiple items inserted ... return nil
        return nil
    }
    
    private func insert(_ item: MenuItem) -> (index: Int, inserted: Bool) {
        // return insertion index
        if let index = orders[item.orderIndex!].items.index(where: {$0.itemHash! == item.itemHash!}) {
            orders[item.orderIndex!].items[index] = item
            return (index, false)
        }
        // no match found... this item is brand new
        if let index = orders[item.orderIndex!].items.index(where: {$0 == item}) {
            orders[item.orderIndex!].items.insert(item, at: index)
            return(index, true)
        }
        // no matching type found... insert this item at the start
        orders[item.orderIndex!].orderNumber = item.orderIndex! + 1
        orders[item.orderIndex!].items.insert(item, at: 0)
        return (0, true)
    }
    
    func deleteItem(_ item: MenuItem) -> Int? {
        if let index = orders[item.orderIndex!].items.index(where: {$0.itemHash! == item.itemHash!}) {
            orders[item.orderIndex!].items.remove(at: index)
            return index
        }
        return nil
    }
    
    func addEmptyOrder(numbered number: Int) {
        var newOrder = ClientOrder()
        newOrder.orderNumber = number
        orders.append(newOrder)
    }
    
    func deleteLastestOrder() {
        orders.removeLast()
    }
    
    func clearOrder(indexed index: Int) {
        orders[index].items.removeAll()
    }
    
    
    func requestFinishItem(indexed itemIndex: Int, inOrder orderIndex: Int) {
        let item = orders[orderIndex].items[itemIndex]
        sendItemsToServer([item], withMessage: .clientRequestItemFinish)
    }
    
    func requestFinishOrder(indexed orderIndex: Int) {
        let itemsTofinish = orders[orderIndex].items
        sendItemsToServer(itemsTofinish, withMessage: .clientRequestItemFinish)
    }
    
    func sendItemsToServer(_ items: [MenuItem], withMessage message: MessageType) {
        guard let sess = session else { return }
        do {
            let data = CommunicationProtocol(containingItems: items, numberOfOrders: nil, ofMessageType: message)
            let jsonData = try JSONEncoder().encode(data)
            try sess.send(jsonData, toPeers: sess.connectedPeers, with: .reliable)
        } catch {}
    }
}
