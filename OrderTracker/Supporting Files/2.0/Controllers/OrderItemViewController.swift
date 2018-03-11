//
//  SelectedOrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderItemViewController: UIViewController {
    @IBOutlet weak var itemCollectionView: UICollectionView!
    var orderList: OrderList?
    var orderId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        layoutCollectionView()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension OrderItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList!.allOrders[orderId!].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.configureCell()
        cell.label.text =  "item \(orderList!.allOrders[orderId!].items[indexPath.row].number)"
        return cell
    }
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 3
        let numberOfItemsPerRow = 1
        let width = itemCollectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * itemSpacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow) / 2)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        itemCollectionView.collectionViewLayout = layout
    }
    
    
}

extension OrderItemViewController: DetailViewControllerDelegate {
    func orderAdded() {
        itemCollectionView.reloadData()
//        itemCollectionView.insertItems(at: [IndexPath.init(row: orderList!.allOrders[orderId!].items.count + 1, section: 0)])
        
    }
}


