//
//  SelectedOrderViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class OrderItemViewController: UIViewController {
    @IBOutlet weak var billButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var buttonDisabledBackgroundView: UIView!
    @IBOutlet weak var buttonsDisabledLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    var isNewOrder = false
    var collectionViewDataSource: OrderItemViewControllerDataSource!
    var orderModel: OrderModel?
    var orderIndex: Int?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func billButtonPressed(_ sender: Any) {
        itemCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
        let billVC = BillItemViewController()
        billVC.modalPresentationStyle = .formSheet
        billVC.items = orderModel!.billBuffer
        billVC.delegate = self // get billing info when this VC is dismissed
        billVC.billingMode = .normal(orderModel!.billBuffer)
        present(billVC, animated: true, completion: nil)

    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "Clear", style: .default) { (action) in
            self.orderModel!.clearPendingItems(inOrder: self.orderIndex!)
            self.itemCollectionView.reloadSections([0])
            self.updateBillView()
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
        
        collectionViewDataSource = OrderItemViewControllerDataSource(data: orderModel!)
        collectionViewDataSource.orderIndex = orderIndex!
        collectionViewDataSource.delegate = self
        collectionViewDataSource.collectionView = itemCollectionView
        itemCollectionView.dataSource = collectionViewDataSource
        itemCollectionView.delegate = collectionViewDataSource
        itemCollectionView.alwaysBounceVertical = true
        itemCollectionView.backgroundColor = Scheme.menuItemCollectionViewBackgroundColour
        itemCollectionView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.titleTextAttributes = Scheme.AttributedText.navigationControllerTitleAttributes
        navigationController?.navigationBar.topItem?.title = "Items in Order " + "\(orderModel!.allOrders[orderIndex!].orderNumber)"
        navigationController?.navigationBar.barTintColor = Scheme.navigationBarColour
        billView.backgroundColor = Scheme.billViewColour
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = buttonDisabledBackgroundView.bounds
        buttonDisabledBackgroundView.addSubview(blurEffectView)
        buttonDisabledBackgroundView.backgroundColor = .clear
        buttonDisabledBackgroundView.sendSubview(toBack: blurEffectView)
        clearButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        billButton.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        billButton.layer.cornerRadius = 5
        billButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        billButton.clipsToBounds = true
        clearButton.layer.cornerRadius = 5
        clearButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        clearButton.clipsToBounds = true
        updateBillView()
        
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderModel?.saveOrderToFile(orderIndex!)
        
    }
    
    func updateBillView() {
        let numItems = orderModel!.allOrders[orderIndex!].itemCollections[0].count
        totalQuantityLabel.text = "\(orderModel!.billBuffer.count)"
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(orderModel!.billBufferPrice)
        UIView.animate(withDuration: 0.3) {
            self.buttonDisabledBackgroundView.alpha = numItems == 0 ? 1 : 0
        }
    }
}


extension OrderItemViewController: MenuDelegate {
    func addItemToOrder(_ item: MenuItem) {
        let number = orderModel!.pendItemToOrder(orderIndex!, item: item)
        let indexPath = IndexPath.init(row: number, section: 0)
        if orderModel!.getNumberOfPendingItems(inOrder: orderIndex!) == 1 {
            itemCollectionView.reloadItems(at: [indexPath])
        } else {
            itemCollectionView.insertItems(at: [indexPath])
        }
    
        itemCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        updateBillView()
        if let cell = itemCollectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell {
            // if cell is visible, light up the cell
            cell.animateSelected()
        }
    }
    
    func quickBillItem(_ item: MenuItem) {
        let billVC = BillItemViewController()
        billVC.modalPresentationStyle = .formSheet
        billVC.delegate = self // get billing info when this VC is dismissed
        billVC.items = [item]
        billVC.billingMode = BillingMode.template(item)
        present(billVC, animated: true, completion: nil)
        
    }
    
}

extension OrderItemViewController: OrderItemCollectionViewCellDelegate {
    func itemWillDelete(sender cell: ItemCollectionViewCell) {
        // do nothing if index path not found (happens when the clear button is pressed before this action)
        // prevents the app from crashing
        guard let indexPath = itemCollectionView.indexPath(for: cell) else { return }
        orderModel!.deletePendingItem(inOrder: orderIndex!, item: indexPath.row)
        if itemCollectionView.numberOfItems(inSection: 0) == 1 {
            // if this is the last item left in the collection view, dont delete (replace with placeholder)
            itemCollectionView.reloadItems(at: [indexPath])
        } else {
            itemCollectionView.deleteItems(at: [indexPath])
        }
        
        updateBillView()
    }
}

extension OrderItemViewController: BillItemViewControllerDelegate {
    func billItemViewControllerDidReturn(withBillReturnType mode: BillReturnType, paymentMethod method: PaymentMethod, billingMode bMode: BillingMode) {
        switch mode {
        case .billAll:
            switch bMode {
            case .normal(let items):
                orderModel!.bill(itemsInBuffer: items, paymentMethod: method, inOrder: orderIndex!)
                itemCollectionView.reloadData()
            case .template(let item):
                let index = orderModel!.quickBillTemplateItem(item, withPaymentMethod: method, order: orderIndex!)
                insertIntoSection1(IndexPath(item: index, section: 1))
            }
        case .splitBill(let cash, let card):
            switch bMode {
            case .normal(let items):
                orderModel!.splitBill(itemsInBuffer: items, cash: cash, card: card, inOrder: orderIndex!)
                itemCollectionView.reloadData()
            case .template(let item):
                let index = orderModel!.splitBill(templateItem: item, cashSales: cash, cardSales: card, order: orderIndex!)
                insertIntoSection1(IndexPath(item: index, section: 1))
            }
        }
    }
    
    func quickBill(templateItem item: MenuItem, paymentMethod method: PaymentMethod) {
        let insertRes = orderModel!.quickBillTemplateItem(item, withPaymentMethod: method, order: orderIndex!)
        let paidIndexPath = IndexPath(item: insertRes, section: 1)
        itemCollectionView.performBatchUpdates({
            insertIntoSection1(paidIndexPath)
        }, completion: nil)
        updateBillView()
    }
    
    private func insertIntoSection1(_ indexPath: IndexPath) {
        let count = orderModel!.allOrders[orderIndex!].itemCollections[1].count
        if count == 1 && indexPath.row == 0 {
            self.itemCollectionView.reloadItems(at: [indexPath])
        } else {
            self.itemCollectionView.insertItems(at: [indexPath])
        }
    }
    
    private func removeFromSection0(_ indexPath: IndexPath) {
        if self.itemCollectionView.numberOfItems(inSection: 0) == 1 {
            self.itemCollectionView.reloadItems(at: [indexPath])
        } else {
            self.itemCollectionView.deleteItems(at: [indexPath])
        }
    }
    
}



