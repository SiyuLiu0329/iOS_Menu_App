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
    case template(Int) // item number
    case pendingItem(Int) // index
    case normal
}

protocol BillItemViewControllerDelegate: class {
    func billItemViewControllerDidReturn(withBillReturnType mode: BillReturnType, paymentMethod method: PaymentMethod, billingMode bMode: BillingMode)
    func quickBill(itemInPendingItems index: Int, paymentMethod method: PaymentMethod)
    func quickBill(templateItemNumbered number: Int, paymentMethod method: PaymentMethod)
}

class BillItemViewController: UIViewController {
    var totalPrice: Double!
    var numberOfItems: Int!
    var model: BillModel!
    var billingMode: BillingMode!
    weak var delegate: BillItemViewControllerDelegate?
    private var collectionViewDataSource: BillCollectionViewDataSource!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var billingOptionCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = BillModel(totalPrice: totalPrice, numberOfItems: numberOfItems)
        collectionViewDataSource = BillCollectionViewDataSource(forCollectionView: billingOptionCollectionView, billModel: model, withDelegate: self)
        billingOptionCollectionView.dataSource = collectionViewDataSource
        billingOptionCollectionView.delegate = self
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(totalPrice!)
        let unit = numberOfItems == 1 ? "item" : "items"
        numberOfItemsLabel.text =  "\(numberOfItems!) " + unit
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        billingOptionCollectionView.showsHorizontalScrollIndicator = false
        self.billingOptionCollectionView.bounces = false
        // instanciate model here
//        billingOptionCollectionView.isScrollEnabled = false
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        billingOptionCollectionView.scrollToItem(at: IndexPath(row: segmentedControl.selectedSegmentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}

extension BillItemViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x == 0 ? 0 : 1
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
            case .template(let number):
                delegate!.quickBill(templateItemNumbered: number, paymentMethod: method)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
