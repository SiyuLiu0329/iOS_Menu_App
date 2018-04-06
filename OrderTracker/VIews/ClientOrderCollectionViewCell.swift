//
//  ClientOrderCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 4/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
protocol ClientItemCollectionViewCellDelegate: class {
    func didSelectItem(atIndex index: Int, inOrder orderIndex: Int)
}

class ClientOrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var orderFinishedButton: UIButton!
    @IBOutlet weak var headerViewTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var order: ClientOrder!
    weak var delegate: ClientItemCollectionViewCellDelegate?
    
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
    
    func configure(loadingOrder order: ClientOrder) {
        headerViewTitle.text = "Order \(order.orderNumber)"
        self.order = order
    }

}

extension ClientOrderCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate!.didSelectItem(atIndex: indexPath.row, inOrder: order.orderNumber - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ClientItemCollectionViewCell
        cell.configure(withItem: order.items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var base: CGFloat = 60
        let item = order.items[indexPath.row]
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
