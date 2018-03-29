//
//  SelectedOrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderItemViewController: UIViewController {
    @IBOutlet weak var tenderButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var buttonDisabledBackgroundView: UIView!
    @IBOutlet weak var buttonsDisabledLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var tenderView: UIView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    var isNewOrder = false
    var collectionViewDataSource: OrderItemViewControllerDataSource!
    var orderList: OrderList?
    var orderId: Int?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func tenderAllItems(withPaymentType paymentType: PaymentStatus) {
        let _ = self.orderList!.tenderAllPendingItems(withPaymentType: paymentType)
        self.itemCollectionView.reloadSections([0, 1])
        self.updateTenderView()
    }
    
    
    @IBAction func tenderButtonPressed(_ sender: Any) {
        // alert shown when tendering ALL items (by clicking on the button at the bottom)
        self.itemCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)

        let card = UIAlertAction(title: "Card", style: .default) { (action) in
            self.tenderAllItems(withPaymentType: .card)
        }
        let cash = UIAlertAction(title: "Cash", style: .default) { (action) in
            self.tenderAllItems(withPaymentType: .cash)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Tendering: \(Scheme.Util.twoDecimalPriceText(orderList!.getTotalPriceOfPendingItemsInLoadedOrder()))",
                                      message: "Select a payment method.",
                                      preferredStyle: .alert)
        alert.addAction(card)
        alert.addAction(cash)
        alert.addAction(cancelAction)
        alert.view.tintColor = .black
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "Clear", style: .default) { (action) in
            self.orderList!.clearPendingItemsLoadedOrder()
            self.itemCollectionView.reloadSections([0])
            self.updateTenderView()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Delete",
                                      message: "Click \"Clear\" to delete all pending items.",
                                      preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.view.tintColor = .black
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }

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
        buttonDisabledBackgroundView.sendSubview(toBack: blurEffectView)
        clearButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        tenderButton.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        tenderButton.layer.cornerRadius = 5
        tenderButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        tenderButton.clipsToBounds = true
        clearButton.layer.cornerRadius = 5
        clearButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        clearButton.clipsToBounds = true
        updateTenderView()
        
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if orderList!.isLatestOrderEmpty && orderId == orderList!.allOrders.count - 1 && isNewOrder {
            // if this order was newly created, discard it
            // if the latest(created) order is empty && this order is the latest!
            orderList!.discardLastestOrder()
            orderList!.resetTamplateItem(itemNumber: 0) // reset template items so options are reset
        }
    }
    
    @IBAction func saveAndDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderList?.saveLoadedOrder(withIndex: orderId!)
        orderList!.resetTamplateItem(itemNumber: 0) // reset template items so options are reset
    }
    
    private func layoutCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.sectionHeadersPinToVisibleBounds = true
        itemCollectionView.collectionViewLayout = layout
    }
    
    func updateTenderView() {
        let numItems = orderList!.loadedItemCollections[0].items.count
        totalQuantityLabel.text = "\(numItems)"
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(orderList!.getTotalPriceOfPendingItemsInLoadedOrder())
        UIView.animate(withDuration: 0.3) {
            self.buttonDisabledBackgroundView.alpha = numItems == 0 ? 1 : 0
        }
    }
}


extension OrderItemViewController: DetailViewControllerDelegate {
    func itemAdded(toIndex number: Int) {
        let indexPath = IndexPath.init(row: number, section: 0)
        if number == orderList!.loadedItemCollections[0].items.count - 1 && number != itemCollectionView.numberOfItems(inSection: 0) - 1 {
            itemCollectionView.insertItems(at: [indexPath])
        } else {
            itemCollectionView.reloadItems(at: [IndexPath.init(row: number, section: 0)])
        }
        itemCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        updateTenderView()
        if let cell = itemCollectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell {
            // if cell is visible, light up the cell
            cell.animateSelected()
        }
    }
    
    func itemWillQuickTender(itemNumber number: Int) {
        // called when a single template item is tendered
        let card = UIAlertAction(title: "Card", style: .default) { (action) in
            let _ = self.orderList!.quickTenderTemplateItem(numbered: number, withPaymentMethod: .card)
            self.itemCollectionView.reloadSections([1])
        }
        let cash = UIAlertAction(title: "Cash", style: .default) { (action) in
            let _ = self.orderList!.quickTenderTemplateItem(numbered: number, withPaymentMethod: .cash)
            self.itemCollectionView.reloadSections([1])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Tendering: \(Scheme.Util.twoDecimalPriceText(orderList!.menuItems[number]!.unitPrice))",
            message: "Select a payment method.",
            preferredStyle: .alert)
        alert.addAction(card)
        alert.addAction(cash)
        alert.addAction(cancelAction)
        alert.view.tintColor = .black
        self.present(alert, animated: true) {
            // The alert was presented
        }
        
    }
    
}

extension OrderItemViewController: OrderItemCollectionViewCellDelegate {
    func itemDidGetTendered(sender cell: ItemCollectionViewCell) {
        // called when a pending item is tendered (A card in the collection view)
        guard let indexPath = itemCollectionView.indexPath(for: cell) else { return }

        let card = UIAlertAction(title: "Card", style: .default) { (action) in
            let _ = self.orderList!.tender(pendingItem: indexPath.row, withPaymentMethod: .card)
            self.itemCollectionView.reloadSections([0, 1])
            self.updateTenderView()
        }
        let cash = UIAlertAction(title: "Cash", style: .default) { (action) in
            let _ = self.orderList!.tender(pendingItem: indexPath.row, withPaymentMethod: .cash)
            self.itemCollectionView.reloadSections([0, 1])
            self.updateTenderView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Tendering: \(Scheme.Util.twoDecimalPriceText(orderList!.getPriceOfPendingItem(withIndex: indexPath.row)))",
            message: "Select a payment method.",
            preferredStyle: .alert)
        alert.addAction(card)
        alert.addAction(cash)
        alert.addAction(cancelAction)
        alert.view.tintColor = .black
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    func itemDidGetDeleted(sender cell: ItemCollectionViewCell) {
        // do nothing if index path not found (happens when the clear button is pressed before this action)
        // prevents the app from crashing
        guard let indexPath = itemCollectionView.indexPath(for: cell) else { return }
        orderList!.deletePendingItemInLoadedOrder(withIndex: indexPath.row)
        if itemCollectionView.numberOfItems(inSection: 0) == 1 {
            // if this is the last item left in the collection view, dont delete (replace with placeholder)
            itemCollectionView.reloadItems(at: [indexPath])
        } else {
            itemCollectionView.deleteItems(at: [indexPath])
        }
        
        updateTenderView()
    }
}



