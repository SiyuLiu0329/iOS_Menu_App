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
    
    @IBOutlet weak var orderCollectionView: UICollectionView!
    var orderModel: OrderModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = OrderViewControllerDataSource(data: orderModel!)
        collectionViewDataSource.collectionView = orderCollectionView
        orderCollectionView.dataSource = collectionViewDataSource
        orderCollectionView.alwaysBounceVertical = true
        orderCollectionView.delegate = self
        orderCollectionView.backgroundColor = Scheme.collectionViewBackGroundColour
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes
        navigationController?.navigationBar.topItem?.title = "All Orders"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        orderCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let splitVC = segue.destination as! UISplitViewController
        let navVc = splitVC.viewControllers.first as! UINavigationController
        let orderItemVC = navVc.viewControllers.first as! OrderItemViewController
        let indexPath = orderCollectionView.indexPath(for: sender as! UICollectionViewCell)
        
        orderItemVC.orderModel = orderModel
        orderItemVC.orderIndex = indexPath!.row
        if indexPath!.row == orderModel!.allOrders.count {
            orderModel!.newOrder()
            orderItemVC.isNewOrder = true
        }
        orderModel!.loadOrder(withIndex: indexPath!.row)
        
        let tbC = splitVC.viewControllers.last as! TabBarController
        tbC.menuDelegate = orderItemVC
    }
}

extension OrderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numItems: CGFloat = 5
        let width = collectionView.frame.width / numItems - 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

