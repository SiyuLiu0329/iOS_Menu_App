//
//  OptionTableViewDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 20/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class OptionaTableViewDataSource: NSObject, UITableViewDataSource {
    var orderList: OrderList
    var itemId: Int
    
    init(data orderList: OrderList, itemId id: Int) {
        self.orderList = orderList
        self.itemId = id
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderList.getOptions(inItem: itemId).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // placeholder cells -> xib in the future
        let cell = Bundle.main.loadNibNamed("OptionTableViewCell", owner: self, options: nil)?.first as! OptionTableViewCell // grab the first view
        let option = orderList.getOptions(inItem: itemId)[indexPath.row]
        cell.optionName.text = option.description
        cell.priceLabel.text = (option.price == 0) ? "" : (Scheme.Util.twoDecimalPriceText(option.price))
        cell.value = option.value
        return cell
    }
}
