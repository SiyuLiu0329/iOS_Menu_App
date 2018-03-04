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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeaderBar: UINavigationBar!
    @IBOutlet weak var itemImage: UIImageView!
    var gradient: CAGradientLayer?
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        configureNavBar()
        addGradientMaskToImageView()
        addImageCaption()
        if let item = itemToDisplay {
            itemImage.image = UIImage(named: item.imageURL)
        }
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
            contentViewHeaderBar.topItem?.title = "NO. \(item.number)"
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

