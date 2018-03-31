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
    func itemWillBill(sender cell: ItemCollectionViewCell)
}


class OrderItemViewControllerDataSource: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var orderList: OrderList
    weak var delegate: OrderItemCollectionViewCellDelegate?
    init(data orderList: OrderList) {
        self.orderList = orderList
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = orderList.loadedItemCollections[section].items.count
        if num == 0 {
            return 1 // this is for a place holder cell
        }
        return orderList.loadedItemCollections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let items = orderList.loadedItemCollections[indexPath.section].items
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
        if orderList.loadedItemCollections[indexPath.section].items.isEmpty {
            // if the list is empty, use the placeholder cell
            return CGSize(width: collectionView.frame.width - 10, height: 0 * 22 + 65 + 40)
        }
        let nSelected = orderList.getNumberOfSelectedOptions(inCollection: indexPath.section, forItem: indexPath.row)
        return CGSize(width: collectionView.frame.width - 10, height: CGFloat(nSelected) * 22 + 65 + 40)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return orderList.loadedItemCollections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
}

extension OrderItemViewControllerDataSource: ItemCollectionViewCellDelegate {
    func itemVillQuickBill(_ cell: ItemCollectionViewCell) {
        if delegate != nil {
            delegate!.itemWillBill(sender: cell)
        }
    }

    
    func itemWillBeRemoved(_ cell: ItemCollectionViewCell) {
        if delegate != nil {
            delegate!.itemWillDelete(sender: cell)
        }
    }
}


