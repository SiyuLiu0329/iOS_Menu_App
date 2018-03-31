//
//  BillAllViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 30/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class BillAllViewController: UIViewController {
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    var price: Double!
    var numberOfItems: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = Scheme.Util.twoDecimalPriceText(price)
        numberOfItemsLabel.text = "\(numberOfItems!) items"
        print(numberOfItems)
    }

}
