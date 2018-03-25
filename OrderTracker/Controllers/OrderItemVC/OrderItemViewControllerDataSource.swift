//
//  OrderItemViewControllerDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 19/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class OrderItemViewControllerDataSource: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    var headerHeight:CGFloat = 80

    var orderList: OrderList
    init(data orderList: OrderList) {
        self.orderList = orderList
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.getNumberOfItemsInLoadedOrder()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.configure()
        cell.label.text =  "item \(orderList.getItemNumberInLoadedOrder(withIndex: indexPath.row)) x \(orderList.getItemQuantityInLoadedOrder(withIndex: indexPath.row))"
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "orderHeaderView", for: indexPath) as! ItemCollectionViewHeaderView
            
            //do other header related calls or settups
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nSelected = orderList.getNumberOfSelectedOptions(forItemInLoadedOrder: indexPath.rowjhj)
        return CGSize(width: collectionView.frame.width, height: CGFloat(nSelected + 1) * 50)
    }
}

extension OrderItemViewControllerDataSource: ItemCollectionViewCellDelegate {
    func deleteItemInCell(_ cell: ItemCollectionViewCell) {
        // item deleted, update collection view
        let itemCollectionView = cell.superview as! UICollectionView
        let indexPath = itemCollectionView.indexPath(for: cell)
        orderList.deleteItemInLoadedOrder(withIndex: indexPath!.row)
        itemCollectionView.deleteItems(at: [indexPath!])
    }
}


