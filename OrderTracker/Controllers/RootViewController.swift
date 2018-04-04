
//  rootViewController.swift
//  OrderTracker
//
//  Created by macOS on 7/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class RootViewController: UIViewController {
    
    var connectionHandler = ConnectionHandler()
    weak var delegate: ClientOrderViewDelegate?
    @IBOutlet weak var joinButton: UIButton!

    @IBAction func joinButtonPressed(_ sender: Any) {
        present(connectionHandler.browser, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        connectionHandler.browser.delegate = self
        orderModel.session = connectionHandler.session
        clientModel.session = connectionHandler.session
        connectionHandler.session.delegate = self
        showOrderButton.alpha = 0
    }
    
    @IBOutlet weak var showOrderButton: UIButton!
    
    let orderModel = OrderModel()
    let clientModel = ClientModel()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rootSegue1" {
            UIBarButtonItem.appearance().setTitleTextAttributes(Scheme.AttributedText.navigationControllerTitleAttributes, for: .normal) // this affects all bar buttons
            let navVC = segue.destination as! UINavigationController
            navVC.navigationBar.barTintColor = Scheme.navigationBarColour
            let orderVC = navVC.viewControllers.first as! OrderViewController
            orderVC.orderModel = orderModel
        } else if segue.identifier == "rootViewSegue2" {
            let clientVC = segue.destination as! ClientViewController
            clientVC.clientModel = clientModel
            delegate = clientVC
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension RootViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        connectionHandler.isServer = false
        // this is the client
        do {
            let data = try JSONEncoder().encode(CommunicationProtocol(containingOrder: nil, ofMessageType: .clientReportConnected))
            try connectionHandler.session.send(data, toPeers: connectionHandler.session.connectedPeers, with: .reliable)
        } catch {
            fatalError()
        }
        
        joinButton.setTitle("Client", for: .normal)
        joinButton.isUserInteractionEnabled = false
        showOrderButton.alpha = 1
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
}

extension RootViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            // disconnected
            print("disconnected")
            // fatal error
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONDecoder().decode(CommunicationProtocol.self, from: data)
            
            switch message.type {
            case .serverToClientOrderUpdate:
                // client
                let insertResult = clientModel.receiveOrderFromServer(message.order!)
                if delegate != nil {
                    // if client is in order view, this delegate will have been set so UI elements can be updated
                    DispatchQueue.main.async {
                        // updating UI elements, need to do it in the main thread
                        self.delegate!.didReceiveOrderFromServerAfterPayment(newItem: insertResult.index, wasInerted: insertResult.inserted)
                    }
                }
            case .clientReportConnected:
                DispatchQueue.main.async {
                    // updating UI elements, need to do it in the main thread
                    self.joinButton.setTitle("Server", for: .normal)
                    self.joinButton.isUserInteractionEnabled = false
                    self.connectionHandler.browser.dismiss(animated: true, completion: nil)
                }
                orderModel.sendInitialOrdersToClient()
            case .clientFinishedOrder:
                let orderNumber = message.order!.orderNumber
                orderModel.finishOrder(orderIndex: orderNumber - 1)
                // update async after updating model
            case .discardLastOrder:
                // client
                if delegate != nil {
                    clientModel.discardLastOrder()
                    DispatchQueue.main.async {
                        self.delegate!.didRemoveLastOrder()
                    }
                }
            }
            
            
        } catch {
//            print(error)
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // not needed
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // not needed
    }
}
