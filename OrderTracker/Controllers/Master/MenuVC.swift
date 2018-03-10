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
    var orderList: OrderList? {
        willSet {
            itemSelected = Array(repeatElement(false, count: newValue!.menuItems.count))
            itemSelected![0] = true
        }
    }
    let cellSpacing: CGFloat = 0
    var itemSelected: [Bool]?
    
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
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Menu"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "summarySegue" {
            let navController = segue.destination as? UINavigationController
            let summaryVC = navController?.viewControllers.first as? SummaryViewController
            summaryVC?.orderList = orderList
        }
    }
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        cell.backgroundColor = .black
        if let item = orderList!.getItem(numbered: indexPath.row + 1) {
            cell.isItemSelected = itemSelected![indexPath.row]
            cell.configure(imageUrl: item.imageURL)
        }
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
            for i in 0 ..< itemSelected!.count {
                itemSelected![i] = (indexPath.row == i) ? true : false
            }
            collectionView.reloadData()
        }
    }
    
    
    
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 3
        let numberOfItemsPerRow = 2
        let width = menuCollectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * itemSpacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow) * 3 / 4)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        menuCollectionView.collectionViewLayout = layout
    }
    
}




