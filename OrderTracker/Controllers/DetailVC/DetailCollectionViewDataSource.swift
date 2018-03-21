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
    var orderList: OrderList
    var delegateVC: ItemCellDelegate?
    init(data orderList: OrderList, delegate delegateVC: ItemCellDelegate) {
        self.orderList = orderList
        self.delegateVC = delegateVC
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = orderList.menuItems[indexPath.row + 1] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuItemCollectionViewCell
        cell.delegate = delegateVC!
        cell.configure(imgUrl: item.imageURL, cellColour: item.colour)
        return cell
    }
    
}

