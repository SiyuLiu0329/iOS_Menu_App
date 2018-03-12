//
//  SelectedOrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderItemViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    var orderList: OrderList?
    var orderId: Int?
    var cellCount: Int? // for deleting and add cells
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.backgroundColor = ColourScheme.collectionViewBackGroundColour
        layoutCollectionView()
        navigationController?.navigationBar.barTintColor = ColourScheme.navigationBarColour
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if orderList!.isLatestOrderEmpty {
            // if this order was newly created, discard it
            orderList!.discardLastestOrder()
        }
    }
    
    @IBAction func saveAndDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderList?.saveLoadedOrder(withIndex: orderId!)
    }
}


extension OrderItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList!.getNumberOfItemsInLoadedOrder()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemCollectionViewCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.configure()
        cell.label.text =  "item \(orderList!.getItemNumberInLoadedOrder(withIndex: indexPath.row)) x \(orderList!.getItemQuantityInLoadedOrder(withIndex: indexPath.row))"
        cell.delegate = self
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
        if orderList!.allOrders[orderId!].items.count == cellCount {
            itemCollectionView.reloadData()
        } else {
            cellCount = orderList!.allOrders[orderId!].items.count
            let row = cellCount! - 1
            itemCollectionView.insertItems(at: [IndexPath.init(row: row, section: 0)])
        }
    }
}

extension OrderItemViewController: ItemCollectionViewCellDelegate {
    func deleteItemInCell(_ cell: ItemCollectionViewCell) {
        let indexPath = itemCollectionView.indexPath(for: cell)
        orderList!.deleteItemInLoadedOrder(withIndex: indexPath!.row)
        itemCollectionView.deleteItems(at: [indexPath!])
    }
}


