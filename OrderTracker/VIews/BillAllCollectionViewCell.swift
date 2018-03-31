//
//  BillAllCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 31/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class BillAllCollectionViewCell: UICollectionViewCell {
    @IBAction func CancelButtonPressed(_ sender: Any) {
        cashLabel.textColor = .darkGray
        cardLabel.textColor = .darkGray
        cardViewWidth.constant = fullWidth / 2
        UIView.animate(withDuration: 0.3) {
            self.cashView.alpha = 1
            self.cardView.alpha = 1
            self.contentView.layoutIfNeeded()
            self.cardView.backgroundColor = .white
            self.cashView.backgroundColor = .white
        }
    }
    private let fullWidth: CGFloat = 541
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
    }
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var cardViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cashImageView: UIImageView!
    private var cashViewTapGestureRecogniser: UITapGestureRecognizer!
    private var cardViewTapGestureRecogniser: UITapGestureRecognizer!
    private var cashSelected = true
    
    private func addRoundedCorner(toSubview view: UIView, withRadius radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardViewWidth.constant = fullWidth / 2
        cardImageView.image = #imageLiteral(resourceName: "card")
        cardImageView.alpha = 0.8
        cashImageView.image = #imageLiteral(resourceName: "cash")
        cashImageView.alpha = 0.8
        addRoundedCorner(toSubview: cardImageView, withRadius: 20)
        addRoundedCorner(toSubview: cashImageView, withRadius: 20)
        cardImageView.backgroundColor = .white
        cashImageView.backgroundColor = .white
        
        cashViewTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.tapped(sender:)))
        cashView.addGestureRecognizer(cashViewTapGestureRecogniser)
        
        cardViewTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.tapped(sender:)))
        cardView.addGestureRecognizer(cardViewTapGestureRecogniser)
    }
    
    @objc func tapped(sender genstureRecogniser: UITapGestureRecognizer) {
        if genstureRecogniser == cashViewTapGestureRecogniser {
            // cash
            
            cardViewWidth.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.cardView.alpha = 0
                self.cashView.backgroundColor = .darkGray
                self.cardView.backgroundColor = .white
                self.contentView.layoutIfNeeded()
            }
            cashLabel.textColor = .white
            cardLabel.textColor = .darkGray
            
        } else if genstureRecogniser == cardViewTapGestureRecogniser {
            // card
            cardViewWidth.constant = fullWidth
            UIView.animate(withDuration: 0.3) {
                self.cashView.alpha = 0
                self.cardView.backgroundColor = .darkGray
                self.cashView.backgroundColor = .white
                self.contentView.layoutIfNeeded()
            }
            
            cashLabel.textColor = .darkGray
            cardLabel.textColor = .white
        } else {
            // this should never happen!
            fatalError()
        }
        
    }

}
