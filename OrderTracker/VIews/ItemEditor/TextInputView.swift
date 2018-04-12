//
//  TextInputView.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class TextInputView: UIView {
    var inputTextFiled: UITextField!
    var titleLabel: UILabel!
    var text: String {
        return inputTextFiled.text!
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
        textField.font = UIFont.systemFont(ofSize: 17)
//        textField.textAlignment = .center
        self.inputTextFiled = textField
        
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
        title.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.textColor = Scheme.editorThemeColour
        title.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        self.titleLabel = title
        
    }
    
    func setPlaceholderText(_ text: String) {
        inputTextFiled.placeholder = text
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }

}
