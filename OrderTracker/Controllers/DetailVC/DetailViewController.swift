//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol MenuDelegate: class {
    func addItemToOrder(_ item: MenuItem)
    func quickBillItem(_ item: MenuItem)
}

class DetailViewController: UIViewController {
    @IBAction func onEditMenuButtonPressed(_ sender: Any) {
        let navController = UINavigationController()
        let viewControler = MenuItemEditorViewController()
        navController.viewControllers.append(viewControler)
        navController.modalPresentationStyle = .formSheet
        viewControler.menuModel = menuModel
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var dimView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }


    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var menuModel: MenuModel!
    weak var delegate: MenuDelegate?
    var collectionViewDataSource: DetailCollectionViewDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = DetailCollectionViewDataSource(data: menuModel, delegate: self)
        
        // load order from list of orders so changes can be made to the order
        
        
        itemsCollectionView.dataSource = collectionViewDataSource
        itemsCollectionView.backgroundColor = Scheme.detailViewControllerBackgoundColour
        itemsCollectionView.delegate = self
        // configure nav bar
        
        toolbar.barTintColor = Scheme.navigationBarColour
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.isTranslucent = true
        
        // add blur to nav bar
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = toolbar.bounds.insetBy(dx: -125, dy: 0)
        toolbar.addSubview(blurEffectView)
        toolbar.sendSubview(toBack: blurEffectView)
        toolbar.tintColor = Scheme.navigationControllerBackButtonColour
    }
    

}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numItems: CGFloat = 3
        let width = collectionView.frame.width / numItems - 15
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 54, left: 10, bottom: 10, right: 10)
    }
}

extension DetailViewController: ItemCellDelegate {
    func showDetailFor(collectionViewCell cell: MenuItemCollectionViewCell) {
        let indexPath = itemsCollectionView.indexPath(for: cell)!
        let destinationVC = MenuItemExpandedViewController()
        destinationVC.menuModel = menuModel
        destinationVC.itemId = indexPath.row
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
            delegate!.quickBillItem(menuModel.menuItems[indexPath.row])
        }
    }
    
    func itemAdded(atCell cell: MenuItemCollectionViewCell) {
        let indexPath = itemsCollectionView.indexPath(for: cell)!
        if delegate != nil {
            delegate!.addItemToOrder(menuModel.menuItems[indexPath.row])
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

