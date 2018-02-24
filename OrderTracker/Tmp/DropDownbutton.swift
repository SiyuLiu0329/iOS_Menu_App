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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate != nil {
            delegate!.changeDropViewState()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
