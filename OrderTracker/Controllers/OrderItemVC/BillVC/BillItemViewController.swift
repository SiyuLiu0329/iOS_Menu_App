//
//  BillItemViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 30/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

enum BillingMode {
    case billAll
    case splitBill
}

protocol BillItemViewControllerDelegate: class {
    func billItemViewControllerDidReturn(withBillingMode mode: BillingMode, paymentMethod method: PaymentMethod)
    func quickBill(itemInPendingItems index: Int, paymentMethod method: PaymentMethod)
    func quickBill(templateItemNumbered number: Int, paymentMethod method: PaymentMethod)
}

class BillItemViewController: UIViewController {
    var totalPrice: Double!
    var numberOfItems: Int!
    var model: BillModel!
    var isQuickBill = false // bill all pending items if this is false
    var pendingItemQuickBillIndex: Int? {
        willSet {
            if templateItemQuickBillNumber != nil && newValue != nil {
                fatalError()
            }
        }
    } // use this number to quick bill a item in pending items
    var templateItemQuickBillNumber: Int? {
        willSet {
            if pendingItemQuickBillIndex != nil && newValue != nil {
                fatalError()
            }
        }
    }// use this number to quick bill a item in the template item
    weak var delegate: BillItemViewControllerDelegate?
    private var collectionViewDataSource: BillCollectionViewDataSource!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var billingOptionCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = BillCollectionViewDataSource(forCollectionView: billingOptionCollectionView)
        collectionViewDataSource.cellDelegate = self
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
        model = BillModel(totalPrice: totalPrice, numberOfItems: numberOfItems)
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
    func billAllCellDidConfirm(paymentMethod method: PaymentMethod) {
        if delegate != nil {
            // get information from cell and pass it onto orderItemVC
            if !isQuickBill {
                delegate!.billItemViewControllerDidReturn(withBillingMode: .billAll, paymentMethod: method)
                
            } else {
                
                if let index = pendingItemQuickBillIndex {
                    delegate!.quickBill(itemInPendingItems: index, paymentMethod: method)
                }
                
                if let number = templateItemQuickBillNumber {
                    delegate!.quickBill(templateItemNumbered: number, paymentMethod: method)
                }
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
