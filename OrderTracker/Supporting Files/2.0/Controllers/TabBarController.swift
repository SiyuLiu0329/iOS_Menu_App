//
//  TabbarController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        tabBar.barTintColor = ColourScheme.navigationBarColour
        tabBar.tintColor = .white
    }
}
