//
//  OrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var orderCollectionView: UICollectionView!
    var orderList: OrderList?

    override func viewDidLoad() {
        super.viewDidLoad()
        orderCollectionView.delegate = self
        orderCollectionView.dataSource = self
        layoutCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let splitVC = segue.destination as! UISplitViewController
        let navVc = splitVC.viewControllers.first as! UINavigationController
        let selectedVC = navVc.viewControllers.first as! OrderItemViewController
        let indexPath = orderCollectionView.indexPath(for: sender as! UICollectionViewCell)

        selectedVC.orderList = orderList
        selectedVC.orderId = indexPath!.row
        let tbC = splitVC.viewControllers.last as! UITabBarController
        let detailNavVC = tbC.viewControllers?.first  as! UINavigationController
        let detailVC = detailNavVC.viewControllers.first as! DetailViewController
        detailVC.orderList = orderList
        detailVC.orderId = indexPath!.row
        detailVC.delegate = selectedVC
    }
}

extension OrderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList!.allOrders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OrderCollectionViewCell
        
        cell = orderCollectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCollectionViewCell

        cell.label.text = "\(orderList!.allOrders[indexPath.row].orderNumber)"

        
        return cell
        
        
    }
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 3
        let numberOfItemsPerRow = 5
        let width = orderCollectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * itemSpacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow))
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        orderCollectionView.collectionViewLayout = layout
    }
    
}

