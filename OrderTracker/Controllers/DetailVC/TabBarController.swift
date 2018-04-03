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
    weak var menuDelegate: MenuDelegate?
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
        let detailVC = viewControllers?.first as! DetailViewController
        detailVC.menuModel = MenuModel(menuName: "Food")
        detailVC.tabBarItem.title = detailVC.menuModel.menuName
        detailVC.delegate = menuDelegate
        
        let drinkVC = storyboard?.instantiateViewController(withIdentifier: "tabbarItem") as! DetailViewController
        drinkVC.menuModel = MenuModel(menuName: "Drink")
        drinkVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        drinkVC.delegate = menuDelegate
        viewControllers?.append(drinkVC)
        
    }
}
