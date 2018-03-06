//
//  paymentOption.swift
//  OrderTracker
//
//  Created by macOS on 6/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

protocol PaymentOptionDelegate: class {
    func paymentOption(withIdSelected id: Int)
}

class PaymentOption: UILabel {
    var id: Int?
    var themeColour: UIColor?
    private var initialFrame: CGRect?
    var isSelected = false {
        willSet {
            if newValue == true {
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = self.themeColour!
                    self.textColor = .white
                    self.frame = self.superview!.bounds
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundColor = .white
                    self.textColor = self.themeColour
                }
            }
        }
    }
    weak var delegate: PaymentOptionDelegate?
    
    func configureLabel(paymentOption text: String, labelID id: Int, themeColour colour: UIColor, initialFrame frame: CGRect) {
        textAlignment = .center
        textColor = colour
        self.themeColour = colour
        self.id = id
        self.text = text
        self.frame = frame
        self.initialFrame = frame
        font = UIFont.systemFont(ofSize: 30, weight: .light)
        configureGesture()
    }
    
    private func configureGesture() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        addGestureRecognizer(tap)
        
    }
    
    @objc private func tapped() {
        if delegate != nil && id != nil {
            delegate!.paymentOption(withIdSelected: id!)
        }
    }
}
