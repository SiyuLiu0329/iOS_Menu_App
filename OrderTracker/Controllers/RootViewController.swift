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
    let orderModel = OrderModel()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rootSegue1" {
            UIBarButtonItem.appearance().setTitleTextAttributes(Scheme.AttributedText.navigationControllerTitleAttributes, for: .normal) // this affects all bar buttons
            let navVC = segue.destination as! UINavigationController
            navVC.navigationBar.barTintColor = Scheme.navigationBarColour
            let orderVC = navVC.viewControllers.first as! OrderViewController
            orderVC.orderModel = orderModel
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
