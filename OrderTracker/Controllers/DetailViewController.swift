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
        itemsCollectionView.delegate = collectionViewDataSource
        itemsCollectionView.backgroundColor = Scheme.detailViewControllerBackgoundColour
        layoutCollectionView()
        navigationController?.navigationBar.barTintColor = Scheme.navigationBarColour
        navigationController?.navigationBar.topItem?.title = "Menu"
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes

        // Do any additional setup after loading the view.
    }
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 5
        let numberOfItemsPerRow = 1
        let width = itemsCollectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * itemSpacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow)/5)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        itemsCollectionView.collectionViewLayout = layout
    }

}

extension DetailViewController: ItemCellDelegate {
    func incrementQuantity(_ sender: MenuItemCollectionViewCell) {
        // item added, update master view
        let indexPath = itemsCollectionView.indexPath(for: sender)
        let number = orderList?.addItemToLoadedOrder(number: indexPath!.row + 1)
        if delegate != nil {
            delegate!.orderAdded(toOrderNumbered: number!)
        }
    }
}

