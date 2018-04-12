//
//  NewOptionViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 13/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol NewOptionViewControllerDelegate: class {
    func didCreateNewOption(named name: String, pricedAt price: Double)
}

class NewOptionViewController: UIViewController {
    weak var delegate: NewOptionViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
