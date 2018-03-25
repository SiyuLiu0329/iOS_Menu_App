//
//  OrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    var collectionViewDataSource: OrderViewControllerDataSource!
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
        collectionViewDataSource = OrderViewControllerDataSource(data: orderList!)
        orderCollectionView.dataSource = collectionViewDataSource
        orderCollectionView.alwaysBounceVertical = true
        orderCollectionView.backgroundColor = Scheme.collectionViewBackGroundColour
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes
        navigationController?.navigationBar.topItem?.title = "All Orders"
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

        orderItemVC.orderList = orderList
        orderItemVC.orderId = indexPath!.row
        if indexPath!.row == orderList!.allOrders.count {
            orderList!.newOrder()
            orderItemVC.isNewOrder = true
        }
        let tbC = splitVC.viewControllers.last as! UITabBarController
        let detailNavVC = tbC.viewControllers?.first  as! UINavigationController
        let detailVC = detailNavVC.viewControllers.first as! DetailViewController
        detailVC.orderList = orderList
        detailVC.orderId = indexPath!.row
        detailVC.delegate = orderItemVC
    }
}

extension OrderViewController:  UICollectionViewDelegateFlowLayout {

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

