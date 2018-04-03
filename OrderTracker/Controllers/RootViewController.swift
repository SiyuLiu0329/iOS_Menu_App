//
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
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var viewOrdersButton: UIButton!
    @IBAction func viewOrdersButton(_ sender: Any) {
    }

    private func hostSelected(_ selected: Bool) {
        if selected {
            self.hostButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
            self.hostButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.hostButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            self.hostButton.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    private func joinSelected(_ selected: Bool) {
        if selected {
            self.joinButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
            self.joinButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.joinButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            self.joinButton.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    @IBAction func hostButtonPressed(_ sender: Any) {
        connectionHandler.isServer = true
        UIView.animate(withDuration: 0.3) {
            self.viewOrdersButton.alpha = 0
            self.hostSelected(true)
            
            self.joinSelected(false)
        }

    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        connectionHandler.isServer = false
        UIView.animate(withDuration: 0.3) {
            
            self.hostSelected(false)
            self.joinSelected(true)
        }
        if connectionHandler.session.connectedPeers.count == 0 {
            // nothing is connected
            self.present(connectionHandler.browser, animated: true, completion: nil)
        } else {
            // already connected
            self.viewOrdersButton.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOrdersButton.alpha = 0
        hostButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        joinButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        connectionHandler.browser.delegate = self
        self.joinSelected(false)
        self.hostSelected(false)
        orderModel.serverHandler = connectionHandler
    }
    
    let orderModel = OrderModel()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rootSegue1" {
            UIBarButtonItem.appearance().setTitleTextAttributes(Scheme.AttributedText.navigationControllerTitleAttributes, for: .normal) // this affects all bar buttons
            let navVC = segue.destination as! UINavigationController
            navVC.navigationBar.barTintColor = Scheme.navigationBarColour
            let orderVC = navVC.viewControllers.first as! OrderViewController
            orderVC.orderModel = orderModel
        } else if segue.identifier == "rootViewSegue2" {
            let clientVC = segue.destination as! ClientViewController
            clientVC.clientHandler = connectionHandler
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension RootViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.viewOrdersButton.alpha = 1
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.viewOrdersButton.alpha = 0
        hostSelected(false)
        joinSelected(false)
        browserViewController.dismiss(animated: true, completion: nil)
    }
}
