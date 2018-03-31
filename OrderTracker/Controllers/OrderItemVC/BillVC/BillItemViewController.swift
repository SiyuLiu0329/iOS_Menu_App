//
//  BillItemViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 30/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class BillItemViewController: UIViewController {
    var itemsToBill: [MenuItem]!
    var totalPrice: Double!
    var numberOfItems: Int!
    private var collectionViewDataSource: UICollectionViewDataSource!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var billingOptionCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = BillCollectionViewDataSource(forCollectionView: billingOptionCollectionView)
        billingOptionCollectionView.dataSource = collectionViewDataSource
        billingOptionCollectionView.delegate = self
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(totalPrice!)
        numberOfItemsLabel.text =  "\(numberOfItems!) items"
        self.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
//        self.billingOptionCollectionView.bounces = false
//        billingOptionCollectionView.isScrollEnabled = false
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
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
