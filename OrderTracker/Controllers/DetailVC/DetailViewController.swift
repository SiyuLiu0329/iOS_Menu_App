//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func orderAdded(toOrderNumbered number: Int)
}

class DetailViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var orderId: Int?
    var orderList: OrderList?
    weak var delegate: DetailViewControllerDelegate?
    var collectionViewDataSource: DetailCollectionViewDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = DetailCollectionViewDataSource(data: orderList!, delegate: self)
        orderList!.loadOrder(withIndex: orderId!)
        itemsCollectionView.dataSource = collectionViewDataSource
        itemsCollectionView.backgroundColor = Scheme.detailViewControllerBackgoundColour
        layoutCollectionView()
        navigationController?.navigationBar.barTintColor = Scheme.navigationBarColour
        navigationController?.navigationBar.topItem?.title = "Menu Items"
        

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = (self.navigationController?.navigationBar.bounds)!
        navigationController?.navigationBar.addSubview(blurEffectView)
        navigationController?.navigationBar.sendSubview(toBack: blurEffectView)
        
        navigationController?.navigationBar.tintColor = Scheme.navigationControllerBackButtonColour
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes

    }
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 10
        let numberOfItemsPerRow = 3
        let width = itemsCollectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * itemSpacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow) * 1.4)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        itemsCollectionView.collectionViewLayout = layout
    }
    

}

extension DetailViewController: ItemCellDelegate {
    func showDetailFor(collectionViewCell cell: MenuItemCollectionViewCell) {
        let indexPath = itemsCollectionView.indexPath(for: cell)!
        let destinationVC = MenuItemExpandedViewController()
        // set up data here
        destinationVC.orderList = orderList
        destinationVC.itemId = indexPath.row + 1
        // display
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func itemAdded(atCell cell: MenuItemCollectionViewCell) {
        let indexPath = itemsCollectionView.indexPath(for: cell)!
        let number = orderList?.addItemToLoadedOrder(number: indexPath.row + 1)
        if delegate != nil {
            delegate!.orderAdded(toOrderNumbered: number!)
        }

    }
}


//extension DetailViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let number = orderList?.addItemToLoadedOrder(number: indexPath.row + 1)
//        if delegate != nil {
//            delegate!.orderAdded(toOrderNumbered: number!)
//        }
//    }
//}

