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
    
    func receiveOrderFromServer(_ order: Order) -> Int {
        orders.append(order)
        return orders.count - 1
    }
}
