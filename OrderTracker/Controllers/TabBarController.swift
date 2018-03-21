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
        
        tabBar.barTintColor = Scheme.navigationBarColour
        tabBar.tintColor = .white
        tabBar.backgroundImage = UIImage()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        tabBar.addSubview(blurEffectView)
        tabBar.sendSubview(toBack: blurEffectView)
    }
}
