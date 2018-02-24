//
//  DropDownButton.swift
//  OrderTracker
//
//  Created by macOS on 24/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol DropDownButtonPressedDelegate: class {
    func changeDropViewState()
}


class DropDownButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame) // x, y, width, height
    }
    
    weak var delegate: DropDownButtonPressedDelegate?

    
//    var isOpen = false
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let contraintHeight = height else { return }
//        if !isOpen {
//            NSLayoutConstraint.deactivate([contraintHeight])
//            contraintHeight.constant = 150
//            NSLayoutConstraint.activate([contraintHeight])
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
//                self.dropDownView.layoutIfNeeded()
//            }, completion: nil)
//            isOpen = true
//            
//        } else {
//            NSLayoutConstraint.deactivate([contraintHeight])
//            contraintHeight.constant = 0
//            NSLayoutConstraint.activate([contraintHeight])
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
//                self.dropDownView.layoutIfNeeded()
//            }, completion: nil)
//            isOpen = false
//            
//        }
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate != nil {
            delegate!.changeDropViewState()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
