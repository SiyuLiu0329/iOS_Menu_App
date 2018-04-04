//
//  ClientModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ClientModel {
    var session: MCSession!
    var orders: [Order] = []
    
    func receiveOrderFromServer(_ order: Order) -> (index: Int, inserted: Bool) {
//        print(order.itemCollections[0].count, order.itemCollections[1].count)
        for i in 0..<orders.count {
            let od = orders[i]
            if od.orderNumber == order.orderNumber {
                orders.remove(at: i)
                orders.insert(order, at: i)
                return (i, false)
            }
        }
        orders.append(order)
        return (orders.count - 1, true)
    }
}
