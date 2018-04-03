//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func addItemToOrder(_ item: MenuItem)
    func quickBillItem(_ item: MenuItem)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }


    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var menuModel: MenuModel!
    weak var delegate: DetailViewControllerDelegate?
    var collectionViewDataSource: DetailCollectionViewDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = DetailCollectionViewDataSource(data: menuModel, delegate: self)
        
        // load order from list of orders so changes can be made to the order
        
        
        itemsCollectionView.dataSource = collectionViewDataSource
        itemsCollectionView.backgroundColor = Scheme.detailViewControllerBackgoundColour
        layoutCollectionView()
        
        // configure nav bar
        navigationController?.navigationBar.barTintColor = Scheme.navigationBarColour
        navigationController?.navigationBar.topItem?.title = "Menu Items"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        
        // add blur to nav bar
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
        destinationVC.menuModel = menuModel
        destinationVC.itemId = indexPath.row + 1
        destinationVC.modalPresentationStyle = .overCurrentContext
        destinationVC.view.backgroundColor = .clear
        destinationVC.delegate = delegate
        destinationVC.popoverDelegate = self // to animate dim
        destinationVC.modalTransitionStyle = .crossDissolve
        present(destinationVC, animated: true, completion: nil)
    }
    
    func quickBillItem(atCell cell: MenuItemCollectionViewCell) {
        guard let indexPath = itemsCollectionView.indexPath(for: cell) else { return }
        if delegate != nil {
            delegate!.quickBillItem(menuModel.menuItems[indexPath.row + 1]!)
        }
    }
    
    func itemAdded(atCell cell: MenuItemCollectionViewCell) {
        let indexPath = itemsCollectionView.indexPath(for: cell)!
        if delegate != nil {
            delegate!.addItemToOrder(menuModel.menuItems[indexPath.row + 1]!)
        }
    }
}

extension DetailViewController: MenuItemExpandedViewControllerDismissedDelegate {
    func popoverDidDisappear() {
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 0
        }
    }
    func popoverWillAppear() {
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 0.6
        }
    }
}

