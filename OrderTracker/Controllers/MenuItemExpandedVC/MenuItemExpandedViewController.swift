//
//  MenuItemExpandedViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 20/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class MenuItemExpandedViewController: UIViewController {
    var orderList: OrderList?
    var itemId: Int?
    @IBOutlet weak var optionTableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var contentView: UIView!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = OptionaTableViewDataSource(data: orderList!.menuItems[itemId!]!)
        optionTableView.delegate = self
        optionTableView.dataSource = dataSource
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        navBar.barTintColor = Scheme.getColour(withSeed: itemId!)
        navBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .light),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        contentView.addSubview(blurEffectView)
        contentView.backgroundColor = .clear
        contentView.sendSubview(toBack: blurEffectView)
    }
}

extension MenuItemExpandedViewController: UITableViewDelegate {
    
}
