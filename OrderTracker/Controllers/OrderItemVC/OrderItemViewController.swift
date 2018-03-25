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
    var isNewOrder = false
    var collectionViewDataSource: OrderItemViewControllerDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutCollectionView()
        collectionViewDataSource = OrderItemViewControllerDataSource(data: orderList!)
        itemCollectionView.dataSource = collectionViewDataSource
        itemCollectionView.delegate = collectionViewDataSource
        itemCollectionView.backgroundColor = Scheme.collectionViewBackGroundColour
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes
        navigationController?.navigationBar.topItem?.title = "Order #" + "\(orderId! + 1)"
        navigationController?.navigationBar.barTintColor = Scheme.navigationBarColour
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if orderList!.isLatestOrderEmpty && orderId == orderList!.allOrders.count - 1 && isNewOrder {
            // if this order was newly created, discard it
            // if the latest(created) order is empty && this order is the latest!
            orderList!.discardLastestOrder()
        }
    }
    
    @IBAction func saveAndDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderList?.saveLoadedOrder(withIndex: orderId!)
    }
    
    private func layoutCollectionView() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 5

        itemCollectionView.collectionViewLayout = layout
    }
}


extension OrderItemViewController: DetailViewControllerDelegate {
    func orderAdded(toOrderNumbered number: Int) {
        let indexPath = IndexPath.init(row: number, section: 0)
        itemCollectionView.reloadData()
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        itemCollectionView.reloadItems(at: [IndexPath.init(row: 0, section: 0)])
        if let cell = itemCollectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell {
            cell.animateSelected()
        }
    }
    
}



