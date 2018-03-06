import Foundation
import UIKit

protocol PaymentOptionDelegate: class {
    func selectOption(withId id: Int)
}

class PaymentOption: UIView {
    var optionLabel: UILabel?
    var themeColour: UIColor?
    var intialFrame: CGRect?
    var originalCenterX: CGFloat?
    var id: Int?
    var isSelected = false 
    weak var delegate: PaymentOptionDelegate?
    func configureOption(frame rect: CGRect, themColour colour: UIColor, optionText text: String, viewId number: Int) {
        self.frame = rect
        self.themeColour = colour
        self.intialFrame = rect
        
        optionLabel = UILabel()
        addSubview(optionLabel!)
        optionLabel!.textAlignment = .center
        optionLabel!.text = text
        optionLabel!.frame = bounds
        optionLabel!.font = UIFont.systemFont(ofSize: 30, weight: .light)
        optionLabel!.textColor = themeColour!
        id = number
        originalCenterX = optionLabel!.center.x
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapped() {
        if id != nil && delegate != nil {
            delegate!.selectOption(withId: id!)
        }
    }
}
