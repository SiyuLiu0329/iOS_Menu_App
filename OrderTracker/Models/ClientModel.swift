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
    
    func reciveItemsFromServer(_ items: [MenuItem], numberOfOrders nOrders: Int) -> (insertionIndex: Int, isNewOrder: Bool)? {
        var isNewOrder = false
//        print(nOrders, items)
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
            let index = insert(items.first!)
            return (index, isNewOrder)
        }
        
        for item in items {
            _ = insert(item)
        }
        // multiple items inserted ... return nil
        return nil
    }
    
    private func insert(_ item: MenuItem) -> Int {
        // return insertion index
        for i in 0..<orders[item.orderIndex!].items.count {
            if item == orders[item.orderIndex!].items[i] {
                if item.itemId == orders[item.orderIndex!].items[i].itemId {
                    fatalError()
                }
                orders[item.orderIndex!].items.insert(item, at: i)
                return (i)
            }
        }
        orders[item.orderIndex!].orderNumber = item.orderIndex! + 1
        orders[item.orderIndex!].items.insert(item, at: 0)
        return (0)
    }
    
    func deleteItem(_ item: MenuItem) -> Int? {
//        orders[item.orderIndex!].items.remove(at: item.indexInOrder!)
        for i in 0..<orders[item.orderIndex!].items.count {
            if item.itemId == orders[item.orderIndex!].items[i].itemId {
                orders[item.orderIndex!].items.remove(at: i)
                return i
            }
        }
        return nil
    }
    
    func deleteLatestOrder() {
        orders.removeLast()
    }
    
    func addEmptyOrder(numbered number: Int) {
        var newOrder = ClientOrder()
        newOrder.orderNumber = number
        orders.append(newOrder)
    }
}
