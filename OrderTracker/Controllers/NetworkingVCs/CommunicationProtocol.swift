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
    case serverToClientOrderUpdate
    case clientReportConnected
    case clientFinishedOrder
    case discardLastOrder
}

struct CommunicationProtocol: Codable {
    var order: Order?
    var type: MessageType
    init(containingOrder order: Order?, ofMessageType type: MessageType) {
        self.order = order
        self.type = type
    }
}
