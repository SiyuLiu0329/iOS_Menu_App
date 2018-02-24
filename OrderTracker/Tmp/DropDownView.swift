//
//  DropDownView.swift
//  OrderTracker
//
//  Created by macOS on 24/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class DropDownView: UIView {
    
    var tableView = UITableView()
    var isOn = false
    var height: NSLayoutConstraint!
    
    func changeDropViewState() {
        NSLayoutConstraint.deactivate([height])
        if isOn {
            height.constant = 0
        } else {
            height.constant = (superview?.frame.height)!
        }
        NSLayoutConstraint.activate([height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        isOn = !isOn
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        height = heightAnchor.constraint(equalToConstant: 0)
        addBlur()
        setupTableView()

    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.separatorColor = UIColor.clear
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
