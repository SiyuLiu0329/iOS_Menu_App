//
//  TextInputView.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol TextFieldDelegate: class {
    func textDidChange(sender: TextInputView)
}

class TextInputView: UIView, UITextFieldDelegate {
    var inputTextField: UITextField!
    var titleLabel: UILabel!
    weak var delegate: TextFieldDelegate?
    var text: String {
        return inputTextField.text!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let textField = UITextField()
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.font = UIFont.systemFont(ofSize: 20, weight: .light)
        self.inputTextField = textField
        self.inputTextField.delegate = self
        
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 0.0
        
        let title = UILabel()
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: textField.topAnchor).isActive = true
        title.textColor = Scheme.editorThemeColour
        title.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.titleLabel = title
        
        inputTextField.addTarget(self, action: #selector(self.textDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textDidChange() {
        if delegate != nil {
            delegate!.textDidChange(sender: self)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if string.count > 0 {
            let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
            
            let resultingStringLengthIsLegal = prospectiveText.count <= 9
            
            let scanner = Scanner(string: prospectiveText)
            let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            result = replacementStringIsLegal &&
                resultingStringLengthIsLegal &&
            resultingTextIsNumeric
        }
        return result
    }
    
    
    func setPlaceholderText(_ text: String) {
        inputTextField.placeholder = text
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }

}
