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
            guard let detail = segue.destination as? DetailViewController else { return }
            detail.orderList = orderList
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
