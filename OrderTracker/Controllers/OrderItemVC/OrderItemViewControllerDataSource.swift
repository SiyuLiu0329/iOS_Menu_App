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
        if section == 0 {
            if orderList.getPendingItemsInLoadedOrder().isEmpty {
                return orderList.getPaidItemsInLoadedOrder().count
            } else {
                return orderList.getPendingItemsInLoadedOrder().count
            }
        } else if section == 1 {
            return orderList.getPaidItemsInLoadedOrder().count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell
        
        var item: MenuItem?
        if indexPath.section == 0 {
            if orderList.getPendingItemsInLoadedOrder().isEmpty {
                item = orderList.getItemInPaidItems(withIndexInLoadedOrder: indexPath.row)
            } else {
                item = orderList.getItemInPendingItems(withIndexInLoadedOrder: indexPath.row)
            }
            
        } else if indexPath.section == 1 {
            item = orderList.getItemInPaidItems(withIndexInLoadedOrder: indexPath.row)
        } else {
            fatalError()
        }
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.configure(usingItem: item!)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "orderHeaderView", for: indexPath) as! ItemCollectionViewHeaderView
            
            //do other header related calls or settups
            if indexPath.section == 0 {
                if orderList.getPendingItemsInLoadedOrder().isEmpty {
                    reusableview.configureHeader(title: "Paid")
                } else {
                    reusableview.configureHeader(title: "Pending")
                }
                
            } else if indexPath.section == 1 {
                reusableview.configureHeader(title: "Paid")
            }
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var nSelected: Int?
        if indexPath.section == 0 {
            if orderList.getPendingItemsInLoadedOrder().isEmpty {
                nSelected = orderList.getNumberOfSelectedOptions(forPaidItemInLoadedOrder: indexPath.row)
            } else {
                nSelected = orderList.getNumberOfSelectedOptions(forPendingItemInLoadedOrder: indexPath.row)
            }
            
        } else if indexPath.section == 1 {
            nSelected = orderList.getNumberOfSelectedOptions(forPaidItemInLoadedOrder: indexPath.row)
            
        }
        return CGSize(width: collectionView.frame.width - 10, height: CGFloat(nSelected!) * 22 + 65 + 40)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numSectins = 0
        numSectins += orderList.getPaidItemsInLoadedOrder().isEmpty ? 0 : 1
        numSectins += orderList.getPendingItemsInLoadedOrder().isEmpty ? 0 : 1
        return numSectins
    }
}

extension OrderItemViewControllerDataSource: ItemCollectionViewCellDelegate {
    func deleteItemInCell(_ cell: ItemCollectionViewCell) {
        if delegate != nil {
            delegate!.itemDidGetDeleted(sender: cell)
        }
    }
}


