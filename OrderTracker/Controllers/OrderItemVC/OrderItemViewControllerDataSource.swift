//
//  OrderItemViewControllerDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 19/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDeletedDelegate: class {
    func itemDidGetDeleted(sender cell: ItemCollectionViewCell)
}


class OrderItemViewControllerDataSource: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    var headerHeight:CGFloat = 25

    var orderList: OrderList
    weak var delegate: ItemDeletedDelegate?
    init(data orderList: OrderList) {
        self.orderList = orderList
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 0
        }
        return orderList.getNumberOfItemsInLoadedOrder()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell
        let item = orderList.getItemInLoadedOrder(atIndex: indexPath.row)
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.configure(usingItem: item)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "orderHeaderView", for: indexPath) as! ItemCollectionViewHeaderView
            
            //do other header related calls or settups
            if indexPath.section == 0 {
                reusableview.configureHeader(title: "Pending")
            } else if indexPath.section == 1 {
                reusableview.configureHeader(title: "Finished")
            }
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nSelected = orderList.getNumberOfSelectedOptions(forItemInLoadedOrder: indexPath.row)
        return CGSize(width: collectionView.frame.width - 10, height: CGFloat(nSelected) * 22 + 65 + 40) // 65 for title and 40 for buttons
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if orderList.getNumberOfItemsInLoadedOrder() == 0 {
            return 0
        }
        return 1
    }
}

extension OrderItemViewControllerDataSource: ItemCollectionViewCellDelegate {
    func deleteItemInCell(_ cell: ItemCollectionViewCell) {
        if delegate != nil {
            delegate!.itemDidGetDeleted(sender: cell)
        }
    }
}


