//
//  paymentOptionView.swift
//  OrderTracker
//
//  Created by macOS on 6/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

protocol paymentOptionTappedDelegate: class {
    func swichView(withID id: Int)
}

class PaymentOptionView: UIView {
    var themeColour: UIColor! {
        willSet {
            optionLabel.textColor = newValue
        }
    }
    var selected = false {
        willSet {
            
            if newValue == true {
                UIView.animate(withDuration: 0.5, animations: {
                    self.backgroundColor = self.themeColour
                    self.optionLabel.textColor = .white
                })
                
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.backgroundColor = .clear
                    self.optionLabel.textColor = self.themeColour
                })
                
            }
        }
    }
    weak var delegate: paymentOptionTappedDelegate?
    var viewID: Int?
    var optionTitle: String! {
        willSet {
            optionLabel.text = newValue
        }
    }
    private var optionLabel: UILabel = UILabel()
    
    func configureView() {
        configureOptionLabel()
        addGuesture()
    }
    
    private func addGuesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapped() {
        if delegate != nil && viewID != nil {
            delegate!.swichView(withID: viewID!)
        }
    }
    
    private func configureOptionLabel() {
        addSubview(optionLabel)
        optionLabel.backgroundColor = .clear
        optionLabel.textAlignment = .center
        optionLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        optionLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        optionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        optionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
}
