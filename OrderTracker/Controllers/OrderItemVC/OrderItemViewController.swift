//
//  SelectedOrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderItemViewController: UIViewController {
    
    @IBOutlet weak var buttonDisabledBackgroundView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var buttonsDisabledLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var tenderView: UIView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var tenderButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBAction func clearButtonPressed(_ sender: Any) {
        var indexPaths: [IndexPath] = []
        for i in 0..<orderList!.getNumberOfItemsInLoadedOrder() {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        orderList!.clearLoadedOrder()
        itemCollectionView.deleteItems(at: indexPaths)
        updateTenderView()
        
    }
    
    @IBAction func tenderButtonPressed(_ sender: Any) {
        
    }
    var isNewOrder = false
    var collectionViewDataSource: OrderItemViewControllerDataSource!
    var orderList: OrderList?
    var orderId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutCollectionView()
        collectionViewDataSource = OrderItemViewControllerDataSource(data: orderList!)
        collectionViewDataSource.delegate = self
        itemCollectionView.dataSource = collectionViewDataSource
        itemCollectionView.delegate = collectionViewDataSource
        itemCollectionView.alwaysBounceVertical = true
        itemCollectionView.backgroundColor = Scheme.menuItemCollectionViewBackgroundColour
        itemCollectionView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes
        navigationController?.navigationBar.topItem?.title = "Items in Order " + "\(orderId! + 1)"
        navigationController?.navigationBar.barTintColor = Scheme.navigationBarColour
        tenderView.backgroundColor = Scheme.tenderViewColour
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = buttonDisabledBackgroundView.bounds
        buttonDisabledBackgroundView.addSubview(blurEffectView)
        buttonDisabledBackgroundView.backgroundColor = .clear
        buttonDisabledBackgroundView.layer.cornerRadius = 5
        buttonDisabledBackgroundView.clipsToBounds = true
        buttonDisabledBackgroundView.sendSubview(toBack: blurEffectView)
        
        // buttons
        tenderButton.layer.cornerRadius = 5
        tenderButton.clipsToBounds = true
        tenderButton.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 4)
        tenderButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        clearButton.layer.cornerRadius = 5
        clearButton.clipsToBounds = true
        clearButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        clearButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        updateTenderView()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if orderList!.isLatestOrderEmpty && orderId == orderList!.allOrders.count - 1 && isNewOrder {
            // if this order was newly created, discard it
            // if the latest(created) order is empty && this order is the latest!
            orderList!.discardLastestOrder()
        }
    }
    
    @IBAction func saveAndDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderList?.saveLoadedOrder(withIndex: orderId!)
    }
    
    private func layoutCollectionView() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.sectionHeadersPinToVisibleBounds = true 
        itemCollectionView.collectionViewLayout = layout
    }
    
    func updateTenderView() {
        let numItems = orderList!.getTotalNumberOfItemsInLoadedOrder()
        totalQuantityLabel.text = "\(numItems)"
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(orderList!.getTotalPriceOfLoadedOrder())
        UIView.animate(withDuration: 0.5) {
            self.buttonDisabledBackgroundView.alpha = numItems == 0 ? 1 : 0
        }
    }
}


extension OrderItemViewController: DetailViewControllerDelegate {
    func orderAdded(toOrderNumbered number: Int) {
        let indexPath = IndexPath.init(row: number, section: 0)
        itemCollectionView.reloadData()
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        itemCollectionView.reloadItems(at: [IndexPath.init(row: 0, section: 0)])
        updateTenderView()
        if let cell = itemCollectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell {
            cell.animateSelected()
        }
    }
    
}

extension OrderItemViewController: ItemDeletedDelegate {
    func itemDidGetDeleted(sender cell: ItemCollectionViewCell) {
        // do nothing if index path not found (happens when the clear button is pressed before this action)
        // prevents the app from crashing
        guard let indexPath = itemCollectionView.indexPath(for: cell) else { return }
        
        orderList!.deleteItemInLoadedOrder(withIndex: indexPath.row)
        itemCollectionView.deleteItems(at: [indexPath])
        updateTenderView()
    }
}



