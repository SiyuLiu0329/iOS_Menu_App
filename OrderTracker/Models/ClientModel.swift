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
    
    func getIntialOrderFromServer(_ order: Order) {
        orders.append(order)
        print("got order from server: \(order.orderNumber)")
    }
}
