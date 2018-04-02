//
//  DetailCollectionViewDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 19/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class DetailCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var orderModel: OrderModel
    var delegateVC: ItemCellDelegate?
    init(data orderModel: OrderModel, delegate delegateVC: ItemCellDelegate) {
        self.orderModel = orderModel
        self.delegateVC = delegateVC
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderModel.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = orderModel.menuItems[indexPath.row + 1] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuItemCollectionViewCell
        cell.delegate = delegateVC!
        cell.configure(withItem: item)
        return cell
    }
    
}

