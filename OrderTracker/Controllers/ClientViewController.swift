//
//  ClientViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ClientOrderViewDelegate: class {
    func didReceiveOrderFromServerAfterPayment(_ order: Order)
    func didReceiveInitialOrdersFromServer()
}

class ClientViewController: UIViewController {
    
    var clientModel: ClientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ClientViewController: ClientOrderViewDelegate {
    func didReceiveOrderFromServerAfterPayment(_ order: Order) {
        
        
    }
    
    func didReceiveInitialOrdersFromServer() {
        
    }
}
