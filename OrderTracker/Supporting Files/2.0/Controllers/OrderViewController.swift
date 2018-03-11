//
//  OrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true 
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var orderCollectionView: UICollectionView!
    var orderList: OrderList?

    override func viewDidLoad() {
        super.viewDidLoad()
        orderCollectionView.delegate = self
        orderCollectionView.dataSource = self
        orderCollectionView.backgroundColor = ColourScheme.collectionViewBackGroundColour
        layoutCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        orderCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let splitVC = segue.destination as! UISplitViewController
        let navVc = splitVC.viewControllers.first as! UINavigationController
        let orderItemVC = navVc.viewControllers.first as! OrderItemViewController
        let indexPath = orderCollectionView.indexPath(for: sender as! UICollectionViewCell)
        if indexPath!.row == orderList!.allOrders.count {
            orderList!.newOrder()
        }
        orderItemVC.orderList = orderList
        orderItemVC.orderId = indexPath!.row
        orderItemVC.cellCount = orderList!.allOrders[indexPath!.row].items.count
        let tbC = splitVC.viewControllers.last as! UITabBarController
        let detailNavVC = tbC.viewControllers?.first  as! UINavigationController
        let detailVC = detailNavVC.viewControllers.first as! DetailViewController
        detailVC.orderList = orderList
        detailVC.orderId = indexPath!.row
        detailVC.delegate = orderItemVC
    }
}

extension OrderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList!.allOrders.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OrderCollectionViewCell
        cell = orderCollectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCollectionViewCell
        cell.configure()
        if indexPath.row == orderList!.allOrders.count {
            cell.label.text = "New Cell"
        } else {
            cell.label.text = "\(orderList!.allOrders[indexPath.row].orderNumber)"
        }
        

        return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 5
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

