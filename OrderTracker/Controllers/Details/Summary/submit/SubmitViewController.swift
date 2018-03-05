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
    var itemToDisplay: MenuItem?
    var orderList: OrderList?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeaderBar: UINavigationBar!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var remainingNumberLabel: UILabel!
    var gradient: CAGradientLayer?
    @IBOutlet weak var optionDetails: UILabel!
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentOptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        addGradientMaskToImageView()
        addImageCaption()
        configureRemainingNumber()
        configureOtherUIElements()
    }
    
    private func configureOtherUIElements() {
        itemImage.clipsToBounds = true
        itemImage.contentMode = .scaleAspectFill
        paymentView.backgroundColor = themeColour?.withAlphaComponent(0.3)
        updateOptionsDisplay()
        optionDetails.textColor = themeColour
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        paymentOptionLabel.textColor = themeColour
        
        if let item = itemToDisplay {
            itemImage.image = UIImage(named: item.imageURL)
            remainingNumberLabel.text = "\(item.quantity)"
        }
    }
    
    private func configureRemainingNumber() {
        remainingLabel.textColor = UIColor.white
        remainingLabel.backgroundColor = themeColour
        remainingLabel.layer.cornerRadius = 10
        remainingLabel.clipsToBounds = true
        remainingLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        remainingNumberLabel.layer.cornerRadius = 10
        remainingNumberLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        remainingNumberLabel.clipsToBounds = true
        remainingNumberLabel.layer.borderColor = themeColour?.cgColor
        remainingNumberLabel.layer.borderWidth = 2
        remainingNumberLabel.textColor = themeColour
    }
    
    func updateOptionsDisplay() {
        guard let item = itemToDisplay else { return }
        var displayText = "Options:\n"
        for option in item.options {
            if option.value {
                displayText += option.description + ", "
            }
        }
        
        if displayText == "Options:\n" {
            displayText += "Not Applicable."
        } else {
            displayText.removeLast()
            displayText.removeLast()
            displayText += "."
        }
        
        let text = NSMutableAttributedString.init(string: displayText)
        text.setAttributes([
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17, weight: .bold)
            ], range: NSRange.init(location: 0, length: 8))
        
        text.setAttributes([
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17, weight: .light)
            ], range: NSRange.init(location: 8, length: displayText.count - 8))
        optionDetails.attributedText = text
    }
    
    private func addGradientMaskToImageView() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: itemImage.frame.height)
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradient.locations = [0, 0.7, 1]
        self.gradient = gradient
        itemImage.layer.addSublayer(gradient)
    }
    
    private func addImageCaption() {
        guard let item = itemToDisplay else { return }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.bottomAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: -10).isActive = true
        label.leftAnchor.constraint(equalTo: itemImage.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: itemImage.rightAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 60)
        label.text = item.name
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    private func configureNavBar() {
        contentViewHeaderBar.barTintColor = themeColour
        if let item = itemToDisplay {
            contentViewHeaderBar.topItem?.title = "Item No. \(item.number)"
        }  
        contentViewHeaderBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 21, weight: .regular)
        ]
        contentViewHeaderBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        guard let grad = gradient else { return }
        grad.frame = itemImage.bounds
    }
}

extension SubmitViewController {
    
}

