//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func orderAdded()
}

class DetailViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var orderId: Int?
    var orderList: OrderList?
    weak var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        itemsCollectionView.backgroundColor = ColourScheme.detailViewControllerBackgoundColour
        layoutCollectionView()
        navigationController?.navigationBar.barTintColor = ColourScheme.navigationBarColour

        // Do any additional setup after loading the view.
    }

}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList!.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = orderList?.menuItems[indexPath.row + 1] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuItemCollectionViewCell
        cell.delegate = self
        cell.configure(imgUrl: item.imageURL)
        return cell
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
        let indexPath = itemsCollectionView.indexPath(for: sender)
        orderList!.addItem(number: indexPath!.row + 1, toOrder: orderId! + 1)
        if delegate != nil {
            delegate!.orderAdded()
        }
    }
}

