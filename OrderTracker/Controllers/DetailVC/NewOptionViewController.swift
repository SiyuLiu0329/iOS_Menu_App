//
//  NewOptionViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 13/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol NewOptionViewControllerDelegate: class {
    func didCreateNewOption(named name: String, pricedAt price: Double)
    func didEditOption(at index: Int, name: String, price: Double)
}

class NewOptionViewController: UIViewController {
    @IBOutlet weak var optionNameField: TextInputView!
    @IBOutlet weak var optionPriceField: TextInputView!
    weak var delegate: NewOptionViewControllerDelegate?
    
    private var initialName: String?
    private var initialPrice: String?
    private var loaded = false
    private var editIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Option"
        optionNameField.setTitle("Option Description:")
        optionNameField.inputTextFiled.font = UIFont.systemFont(ofSize: 20, weight: .light)
        optionNameField.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        optionPriceField.setTitle("Price:")
        optionPriceField.inputTextFiled.font = UIFont.systemFont(ofSize: 20, weight: .light)
        optionPriceField.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        optionNameField.inputTextFiled.keyboardType = .numberPad
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onDoneButtonPressed(_:)))
        
        if let name = initialName {
            optionNameField.inputTextFiled.text = name
        }
        
        if let price = initialPrice {
            optionPriceField.inputTextFiled.text = price
        }
    }
    
    func loadInitialInfo(name: String, price: Double, index: Int) {
        initialName = name
        initialPrice = "\(price)"
        loaded = true
        editIndex = index
    }
    
    @objc func onDoneButtonPressed(_ sender: Any?) {
        guard !optionNameField.text.isEmpty && !optionPriceField.text.isEmpty else { return }
        guard let price = Double(optionPriceField.text) else { return }
        navigationController?.popViewController(animated: true)
        if delegate != nil {
            if !loaded {
                delegate!.didCreateNewOption(named: optionNameField.text, pricedAt: price)
            } else {
                guard let index = editIndex else { return }
                delegate!.didEditOption(at: index, name: optionNameField.text, price: price)
            }
            
        }
    }

}
