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
    var headerHeight:CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.backgroundColor = Scheme.collectionViewBackGroundColour
        layoutCollectionView()
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes
        navigationController?.navigationBar.topItem?.title = "Order #" + "\(orderId! + 1)"
        navigationController?.navigationBar.barTintColor = Scheme.navigationBarColour
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if orderList!.isLatestOrderEmpty && orderId == orderList!.allOrders.count - 1 {
            // if this order was newly created, discard it
            // if the latest(created) order is empty && this order is the latest!
            orderList!.discardLastestOrder()
        }
    }
    
    @IBAction func saveAndDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderList?.saveLoadedOrder(withIndex: orderId!)
    }
}


extension OrderItemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow) / 2)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        itemCollectionView.collectionViewLayout = layout
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
        return CGSize(width: self.view.frame.width, height: headerHeight)
    }
}

extension OrderItemViewController: DetailViewControllerDelegate {
    func orderAdded(toOrderNumbered number: Int) {
        let indexPath = IndexPath.init(row: number, section: 0)
        itemCollectionView.reloadData()
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        itemCollectionView.reloadItems(at: [IndexPath.init(row: 0, section: 0)])

        
    }
}

extension OrderItemViewController: ItemCollectionViewCellDelegate {
    func deleteItemInCell(_ cell: ItemCollectionViewCell) {
        let indexPath = itemCollectionView.indexPath(for: cell)
        orderList!.deleteItemInLoadedOrder(withIndex: indexPath!.row)
        itemCollectionView.deleteItems(at: [indexPath!])
    }
}


