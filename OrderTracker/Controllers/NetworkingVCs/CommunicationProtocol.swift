//
//  Connection Delegate.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

enum MessageType: Int, Codable {
    case serverToClientItemUpdate
    case clientReportConnected
    case serverDidDeleteItem
    case newEmptyOrderCreatedByServer
    case deleteLastestOrder
    case addEmptyOrder
    case revertToOriginal
    case clearOrder
}

struct CommunicationProtocol: Codable {
    var items: [MenuItem]?
    var type: MessageType
    var numberOfOrders: Int?
    var orderToModify: Int?
    init(containingItems items: [MenuItem]?, numberOfOrders nOrders: Int?, ofMessageType type: MessageType) {
        self.items = items
        self.type = type
        self.numberOfOrders = nOrders
    }
    
    init(orderToModify indexed: Int, messageType type: MessageType) {
        self.orderToModify = indexed
        self.type = type
    }
}
