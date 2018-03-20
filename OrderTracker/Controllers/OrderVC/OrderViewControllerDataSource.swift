//
//  File.swift
//  OrderTracker
//
//  Created by Siyu Liu on 19/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class OrderViewControllerDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var orderList: OrderList
    init(data orderList: OrderList) {
        
        self.orderList = orderList
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.allOrders.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OrderCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCollectionViewCell
        cell.configure()
        if indexPath.row == orderList.allOrders.count {
            cell.label.text = "New Cell"
        } else {
            cell.label.text = "\(orderList.allOrders[indexPath.row].orderNumber)"
        }
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    

}
