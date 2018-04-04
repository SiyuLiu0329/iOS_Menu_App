//
//  ClientOrderCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 4/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ClientOrderCollectionViewCell: UICollectionViewCell {
//
    @IBOutlet weak var headerViewTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var order: Order!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = Scheme.clientOrderCollectionViewCellColour
        collectionView.delegate = self
        collectionView.dataSource = self
        let billAllCellNib = UINib(nibName: "ClientItemCollectionViewCell", bundle: Bundle.main)
        collectionView.register(billAllCellNib, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = Scheme.clientOrderCollectionViewCellColour
        headerView.backgroundColor = Scheme.clientOrderCollectionViewCellColour
        
    }
    
    func configure(loadingOrder order: Order) {
        headerViewTitle.text = "Order \(order.orderNumber)"
        self.order = order
        
    }

}

extension ClientOrderCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.itemCollections[0].count + order.itemCollections[1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ClientItemCollectionViewCell
        let numberOfPendingItems = order.itemCollections[0].count
        if indexPath.row < numberOfPendingItems {
            let item = order.itemCollections[0][indexPath.row]
            cell.configure(withItem: item)
        } else {
            let item = order.itemCollections[1][indexPath.row - numberOfPendingItems]
            cell.configure(withItem: item)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var base: CGFloat = 60
        let numberOfPendingItems = order.itemCollections[0].count
        var item: MenuItem
        if indexPath.row < numberOfPendingItems {
            item = order.itemCollections[0][indexPath.row]
        } else {
            item = order.itemCollections[1][indexPath.row - numberOfPendingItems]
        }
        
        for option in item.options {
            if option.value {
                base += 22
            }
        }
        return CGSize(width: frame.width - 10, height: base + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
}
