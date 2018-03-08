//
//  MenuViewController.swift
//  OrderTracker
//
//  Created by macOS on 7/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

protocol ItemSelectedDelegate: class {
    func updateUIForItem(numbered number: Int)
}

class MenuViewController: UIViewController {
    var orderList: OrderList?
    let cellSpacing: CGFloat = 0
    
    weak var delegate: ItemSelectedDelegate?
        
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var menuCollectionView: UICollectionView!
    override func viewDidLoad() {
        setUpNavController()
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        layoutCollectionView()
    }
    
    private func setUpNavController() {
        menuCollectionView.backgroundColor = .clear
        view.backgroundColor = UIColor.darkGray
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Menu"
    }
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        cell.backgroundColor = .black
//        cell.frame.size.width = width! / 3
//        cell.frame.size.height = width! / 3
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList!.menuItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.updateUIForItem(numbered: indexPath.row + 1)
        }
    }
    
    
    
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 3
        let numberOfItemsPerRow = 3
        let width = menuCollectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * itemSpacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow))
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        menuCollectionView.collectionViewLayout = layout
    }
    
}



