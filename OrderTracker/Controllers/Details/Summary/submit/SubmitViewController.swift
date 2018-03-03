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
    
    private var contentView: UIView?
    private var itemImage: UIImageView?
    
    var itemToDisplay: MenuItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContentView()
//        setUpImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setUpContentView() {
        view.backgroundColor = UIColor.black
        guard themeColour != nil else { return }
        contentView = UIView()
        view.addSubview(contentView!)
        layout(view: contentView!, constraintTo: view, withConstraints: [20, 20, -20, -20])
        contentView?.layer.cornerRadius = 10
        contentView?.backgroundColor = .white
    }
    
//    private func setUpImageView() {
//        let itemImageView = UIImageView()
//        guard contentView != nil else { return }
//        contentView?.addSubview(itemImageView)
//        layout(view: itemImageView, constraintTo: contentView!, withConstraints: [2, 2, -2, -340])
//        itemImageView.image = UIImage(named: itemToDisplay!.imageURL)
//        itemImageView.layer.cornerRadius = 10
//        itemImageView.layer.masksToBounds = true
//    }
    
    private func layout(view viewToLayout: UIView, constraintTo constraintView: UIView, withConstraints constraints: [CGFloat]) {
        viewToLayout.translatesAutoresizingMaskIntoConstraints = false
        viewToLayout.topAnchor.constraint(equalTo: constraintView.topAnchor, constant: constraints[0]).isActive = true
        viewToLayout.leftAnchor.constraint(equalTo: constraintView.leftAnchor, constant: constraints[1]).isActive = true
        viewToLayout.rightAnchor.constraint(equalTo: constraintView.rightAnchor, constant: constraints[2]).isActive = true
        viewToLayout.bottomAnchor.constraint(equalTo: constraintView.bottomAnchor, constant: constraints[3]).isActive = true
    }

}
