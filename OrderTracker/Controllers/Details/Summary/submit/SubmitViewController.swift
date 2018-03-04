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
    var itemToDisplay: MenuItem?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeaderBar: UINavigationBar!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        configureNavBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    private func configureNavBar() {
        contentViewHeaderBar.barTintColor = themeColour
        contentViewHeaderBar.topItem?.title = itemToDisplay?.name
        contentViewHeaderBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        contentViewHeaderBar.tintColor = .white
    }
}

