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
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = tabBar.bounds
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.addSubview(visualEffectView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailVC = viewControllers?.first as! DetailViewController
        detailVC.menuModel = MenuModel(menuName: "Food")
        detailVC.tabBarItem.title = detailVC.menuModel.menuName
        detailVC.delegate = menuDelegate
        
        // change model for this one later
        let drinkVC = storyboard?.instantiateViewController(withIdentifier: "tabbarItem") as! DetailViewController
        drinkVC.menuModel = MenuModel(menuName: "Drink")
        drinkVC.tabBarItem = UITabBarItem(title: drinkVC.menuModel.menuName, image: nil, selectedImage: nil)
        drinkVC.delegate = menuDelegate
        viewControllers?.append(drinkVC)
        
    }
}
