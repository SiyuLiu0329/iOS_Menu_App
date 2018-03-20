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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = OptionaTableViewDataSource(data: orderList!.menuItems[itemId!]!)
        optionTableView.delegate = self
        optionTableView.dataSource = dataSource
    }
}

extension MenuItemExpandedViewController: UITableViewDelegate {
    
}
