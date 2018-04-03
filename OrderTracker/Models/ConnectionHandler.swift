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

//extension ConnectionHandler: MCSessionDelegate, MCBrowserViewControllerDelegate {
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        switch state {
//        case .connected:
//            print("Connected: \(peerID.displayName)")
//        case .connecting:
//            print("Connecting: \(peerID.displayName)")
//        case .notConnected:
//            print("Not Connected: \(peerID.displayName)")
//        }
//    }
//
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//
//    }
//
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//
//    }
//
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//        // not needed
//    }
//
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
//        // not needed
//    }
//
//}
