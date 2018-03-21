//
//  OptionTableViewDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 20/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class OptionaTableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var item: MenuItem
    
    init(data item: MenuItem) {
        self.item = item
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // placeholder cells -> xib in the future
        let cell = UITableViewCell()
        return cell
    }
}
