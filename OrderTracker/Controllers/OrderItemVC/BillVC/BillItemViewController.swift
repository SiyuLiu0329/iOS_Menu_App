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
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(totalPrice!)
        numberOfItemsLabel.text =  "\(numberOfItems!) items"
        self.toolbar.setBackgroundImage(UIImage(),
                                        forToolbarPosition: .any,
                                        barMetrics: .default)
        self.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}
