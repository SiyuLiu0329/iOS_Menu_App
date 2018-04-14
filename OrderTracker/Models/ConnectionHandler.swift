//
//  ConnectionHandler.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionHandler: NSObject {
    var peerId: MCPeerID!
    var session: MCSession!
    var advertiser: MCAdvertiserAssistant!
    var isServer = true
    var browser: MCBrowserViewController!
    
    override init() {
        super.init()
        peerId = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        browser = MCBrowserViewController(serviceType: "menu", session: session)
        advertiser = MCAdvertiserAssistant(serviceType: "menu", discoveryInfo: nil, session: session)
        start()
    }
    
    func start() {
        advertiser.start()
    }
    
    func stop() {
        advertiser.stop()
    }
}
