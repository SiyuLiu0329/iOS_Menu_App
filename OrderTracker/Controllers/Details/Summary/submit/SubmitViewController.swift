//
//  SubmitViewController.swift
//  OrderTracker
//
//  Created by macOS on 3/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController {
    var themeColour: UIColor?

    @IBOutlet weak var contentView: UIView!
    var itemToDisplay: MenuItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

