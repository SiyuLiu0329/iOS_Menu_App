//
//  rootViewController.swift
//  OrderTracker
//
//  Created by macOS on 7/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    let orderList = OrderList()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rootSegue1" {
            
            let navVC = segue.destination as! UINavigationController
            let orderVC = navVC.viewControllers.first as! OrderViewController
            orderVC.orderList = orderList
            orderList.newOrder()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
