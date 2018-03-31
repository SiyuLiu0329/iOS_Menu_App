//
//  BillItemViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 30/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class BillItemViewController: UIViewController {
    var views: [UIView]!
    var itemsToBill: [MenuItem]!
    var totalPrice: Double!
    var numberOfItems: Int!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views = []
        views.append(createBillAllView())
        views.append(SplitBillViewController().view)
        for view in views {
            containerView.addSubview(view)
        }
        // bring the first view to front ... (to fix switching problems)
        containerView.bringSubview(toFront: views[0])
    }
    
    func createBillAllView() -> UIView {
        let billAllViewVC = BillAllViewController()
        billAllViewVC.numberOfItems = numberOfItems
        billAllViewVC.price = totalPrice
        billAllViewVC.view.frame = containerView.bounds
        return billAllViewVC.view
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        containerView.bringSubview(toFront: views[sender.selectedSegmentIndex])
    }
}
