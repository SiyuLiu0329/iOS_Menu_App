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
    var menuModel: MenuModel
    var delegateVC: ItemCellDelegate?
    init(data menuModel: MenuModel, delegate delegateVC: ItemCellDelegate) {
        self.menuModel = menuModel
        self.delegateVC = delegateVC
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuModel.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = menuModel.menuItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuItemCollectionViewCell
        cell.delegate = delegateVC!
        cell.configure(withItem: item)
        return cell
    }
    
}

