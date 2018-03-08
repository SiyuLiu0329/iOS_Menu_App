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
            let splitVC = segue.destination as! UISplitViewController
            let detailVC = splitVC.viewControllers.last as! DetailViewController
            detailVC.orderList = orderList
            
            let masterVC = splitVC.viewControllers.first as! UINavigationController
            let menu = masterVC.viewControllers.first as! MenuViewController
            menu.orderList = orderList
            menu.delegate = detailVC
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
