//
//  OrderItemViewControllerDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 19/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

protocol OrderItemCollectionViewCellDelegate: class {
    func itemWillDelete(sender cell: ItemCollectionViewCell)
    func willBillPendingItem(sender cell: ItemCollectionViewCell)
}


class OrderItemViewControllerDataSource: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var orderModel: OrderModel
    var orderId: Int!
    weak var delegate: OrderItemCollectionViewCellDelegate?
    init(data orderModel: OrderModel) {
        self.orderModel = orderModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = orderModel.allOrders[orderId].itemCollections[section].count
        if num == 0 {
            return 1 // this is for a place holder cell
        }
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let items = orderModel.allOrders[orderId!].itemCollections[indexPath.section]
        if items.isEmpty {
            let cell: OrderItemPlaceHolderCell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeholder", for: indexPath) as! OrderItemPlaceHolderCell
            cell.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
            cell.placeholderTextLabel.text = indexPath.section == 0 ? "No pending items(s)" : "No paid item(s)" + "..."
            return cell
        }
        
        let item: MenuItem = items[indexPath.row]
        let cell: ItemCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.configure(usingItem: item)
        cell.delegate = self
        cell.isUserInteractionEnabled = indexPath.section == 0 ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowHeight: CGFloat = 22
        if orderModel.allOrders[orderId!].itemCollections[indexPath.section].isEmpty {
            // if the list is empty, use the placeholder cell
            return CGSize(width: collectionView.frame.width - 10, height: 0 * rowHeight + 65 + 25)
        }
        let nSelected = orderModel.getNumberOfSelectionOptions(ofItem: indexPath.row, inCollection: indexPath.section, inOrder: orderId)
        return CGSize(width: collectionView.frame.width - 10, height: CGFloat(nSelected) * rowHeight + 65 + 30)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return orderModel.allOrders[orderId].itemCollections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(3)
    }
    
}

extension OrderItemViewControllerDataSource: ItemCollectionViewCellDelegate {
    func itemVillQuickBill(_ cell: ItemCollectionViewCell) {
        if delegate != nil {
            delegate!.willBillPendingItem(sender: cell)
        }
    }

    
    func itemWillBeRemoved(_ cell: ItemCollectionViewCell) {
        if delegate != nil {
            delegate!.itemWillDelete(sender: cell)
        }
    }
}


