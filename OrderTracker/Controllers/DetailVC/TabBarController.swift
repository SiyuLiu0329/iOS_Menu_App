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
    var menuModel = MenuModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        tabBar.barTintColor = Scheme.navigationBarColour
        tabBar.tintColor = .white
        tabBar.backgroundImage = UIImage()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        tabBar.addSubview(blurEffectView)
        tabBar.sendSubview(toBack: blurEffectView)
    }
    
    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        let vc1 = viewControllers?.first as! UINavigationController
        let detailVC = vc1.viewControllers.first as! DetailViewController
        detailVC.menuModel = menuModel
    }
}
