//
//  BillViewDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 31/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class BillCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var collectionView: UICollectionView?
    weak var cellDelegate: BillCellDelegate?
    
    init(forCollectionView collectionView: UICollectionView) {
        super.init()
        let billAllCellNib = UINib(nibName: "BillAllCollectionViewCell", bundle: Bundle.main)
        collectionView.register(billAllCellNib, forCellWithReuseIdentifier: "billAllCell")
        let splitBillNib = UINib(nibName: "SplitBillCollectionViewCell", bundle: Bundle.main)
        collectionView.register(splitBillNib, forCellWithReuseIdentifier: "splitBillCell")
        
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "billAllCell", for: indexPath) as! BillAllCollectionViewCell
            cell.delegate = cellDelegate
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "splitBillCell", for: indexPath) as! SplitBillCollectionViewCell
            return cell
        default:
            fatalError()
        }
    }
    
    
}
