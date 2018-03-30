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
    override func viewDidLoad() {
        super.viewDidLoad()
        views = []
        views.append(BillAllViewController().view)
        views.append(SplitBillViewController().view)
        for view in views {
            containerView.addSubview(view)
        }
        containerView.bringSubview(toFront: views[0])
    }
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        containerView.bringSubview(toFront: views[sender.selectedSegmentIndex])
    }
}
