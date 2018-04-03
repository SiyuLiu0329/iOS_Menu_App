//
//  BillItemViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 30/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

enum BillReturnType {
    case billAll
    case splitBill(Double, Double)
}

enum BillingMode {
    case template(MenuItem) // item number
    case pendingItem(Int) // index
    case normal
}

protocol BillItemViewControllerDelegate: class {
    func billItemViewControllerDidReturn(withBillReturnType mode: BillReturnType, paymentMethod method: PaymentMethod, billingMode bMode: BillingMode)
    func quickBill(itemInPendingItems index: Int, paymentMethod method: PaymentMethod)
    func quickBill(templateItem item: MenuItem, paymentMethod method: PaymentMethod)
}

class BillItemViewController: UIViewController {
    var items: [MenuItem]!
    var model: BillModel!
    var billingMode: BillingMode!
    weak var delegate: BillItemViewControllerDelegate?
    private var collectionViewDataSource: BillCollectionViewDataSource!
    @IBOutlet weak var minusSplit: UIButton!
    @IBOutlet weak var plusSplit: UIButton!
    @IBOutlet weak var splitStackView: UIStackView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var billingOptionCollectionView: UICollectionView!
    @IBOutlet weak var numberOfSplitsLabel: UILabel!
    
    @IBAction func plusSplitAction(_ sender: Any) {
        model.appendUnselected()
        let cell = billingOptionCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! SplitBillCollectionViewCell
        let collectionView = cell.collectionView
        collectionView?.reloadData()
        cell.price = model.priceForSelected
        updateNumberOfSplits()
        
    }
    @IBAction func minusSplitAction(_ sender: Any) {
        guard model.numberOfSplits > 1 else { return }
        model.removeLast()
        let cell = billingOptionCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! SplitBillCollectionViewCell
        let collectionView = cell.collectionView
        collectionView?.reloadData()
        cell.price = model.priceForSelected
        updateNumberOfSplits()
        
    }
    
    private func updateNumberOfSplits() {
        numberOfSplitsLabel.text = "\(model.numberOfSplits) " + (model.numberOfSplits == 1 ? "Split" : "Splits")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = BillModel(withItems: items)
        collectionViewDataSource = BillCollectionViewDataSource(forCollectionView: billingOptionCollectionView, billModel: model, withDelegate: self)
        billingOptionCollectionView.dataSource = collectionViewDataSource
        billingOptionCollectionView.delegate = self
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(model.totalPrice)
        let unit = model.items.count == 1 ? "Item" : "Items"
        numberOfItemsLabel.text =  "\(model.items.count) " + unit
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        billingOptionCollectionView.showsHorizontalScrollIndicator = false
        self.billingOptionCollectionView.bounces = false
        splitStackView.alpha = 0
        updateNumberOfSplits()
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        splitStackView.alpha = segmentedControl.selectedSegmentIndex == 1 ? 1 : 0
        billingOptionCollectionView.scrollToItem(at: IndexPath(row: segmentedControl.selectedSegmentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}

extension BillItemViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x == 0 ? 0 : 1
        splitStackView.alpha = segmentedControl.selectedSegmentIndex == 1 ? 1 : 0
    }
}

extension BillItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.billingOptionCollectionView.frame.width, height: self.billingOptionCollectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension BillItemViewController: BillCellDelegate {
    // this functions are called by two types of cells ( they are for split bill and bill all)
    func splitBillDidConfirm(_ collectionView: UICollectionView, paymentMethod method: PaymentMethod) {
        // function called by split bill cell when confirm is pressed
        let indices = model.billSelectedItems(withPaymentMethod: method)
        var indexPaths: [IndexPath] = []
        for i in indices {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        collectionView.deleteItems(at: indexPaths)
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(model.totalPrice)
        if model.selected.isEmpty {
            // all items billed
            delegate!.billItemViewControllerDidReturn(withBillReturnType: .splitBill(model.cashSales, model.cardSales), paymentMethod: .mix, billingMode: billingMode)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func billAllCellDidConfirm(paymentMethod method: PaymentMethod) {
        if delegate != nil {
            // get information from cell and pass it onto orderItemVC
            switch billingMode! {
            case .normal:
                delegate!.billItemViewControllerDidReturn(withBillReturnType: .billAll, paymentMethod: method, billingMode: .normal)
            case .pendingItem(let index):
                delegate!.quickBill(itemInPendingItems: index, paymentMethod: method)
            case .template:
                delegate!.quickBill(templateItem: model.items.first!, paymentMethod: method)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
