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
    var menuModel: MenuModel
    var itemId: Int
    var customOptions: [Option] = []
    
    init(data menuMode: MenuModel, itemId id: Int) {
        self.menuModel = menuMode
        self.itemId = id
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuModel.getOptions(inItem: itemId).count
        } else {
            return customOptions.count
        }
    }
    
    func getDisplayedPrice() -> Double {
        var price = menuModel.menuItems[itemId].unitPrice
        customOptions.forEach { (option) in price += option.price }
        return price
    }
    
    func getItemForBilling() -> MenuItem {
        var item = menuModel.menuItems[itemId];
        customOptions.forEach({item.addCustomOption(option: $0)})
        return item
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // placeholder cells -> xib in the future
        let cell = Bundle.main.loadNibNamed("OptionTableViewCell", owner: self, options: nil)?.first as! OptionTableViewCell // grab the first view
        if indexPath.section == 0 {
            let option = menuModel.getOptions(inItem: itemId)[indexPath.row]
            cell.optionName.text = option.description
            cell.priceLabel.text = (option.price == 0) ? "" : (Scheme.Util.twoDecimalPriceText(option.price))
            cell.value = option.value
        } else {
            let option = customOptions[indexPath.row]
            cell.optionName.text = option.description
            cell.priceLabel.text = (option.price == 0) ? "" : (Scheme.Util.twoDecimalPriceText(option.price))
            cell.value = option.value
        }
        
        return cell
    }
}
