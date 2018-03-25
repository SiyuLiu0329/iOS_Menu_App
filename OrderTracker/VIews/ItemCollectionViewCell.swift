//
//  ItemCollectionViewCell.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol ItemCollectionViewCellDelegate: class {
    func deleteItemInCell(_ cell: ItemCollectionViewCell)
}

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    private var deleteLabel: UILabel!
    

    @IBAction func showItemDetailPressed(_ sender: Any) {
        print("pressed")
    }
    
    @IBOutlet weak var quantityLabel: UILabel!
    private var originalCenterX: CGFloat?
    let threashold: CGFloat = 150
    private var delete = false
    private var displacement: CGFloat = 0
    weak var delegate: ItemCollectionViewCellDelegate?
    private var item: MenuItem!
    func configure(usingItem item: MenuItem) {
        contentView.frame = bounds
        label.text = item.name
        contentView.backgroundColor = item.colour
        self.item = item
        quantityLabel.text = "\(item.quantity) × \(Scheme.Util.twoDecimalPriceText(item.unitPrice))"
        priceLabel.text = "\(Scheme.Util.twoDecimalPriceText(item.totalPrice))"
        itemNumberLabel.text = "\(item.number)"
        
        var optionText = ""
        for option in item.options {
            if option.value {
                optionText += "             · " + option.description + "\n"
            }
        }
        
        if !optionText.isEmpty {
            optionText.removeLast()
        }
        
        optionLabel.text = optionText
        
        
        
    }
    
    func animateSelected() {
        UIView.animate(withDuration: 0.5) {
            self.contentView.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        }
        UIView.animate(withDuration: 0.5) {
            self.contentView.backgroundColor = self.item.colour
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteLabel = UILabel()
        addSubview(deleteLabel)
        contentView.backgroundColor = UIColor.darkGray
        deleteLabel.backgroundColor = .red
        deleteLabel.text = "Delete"
        deleteLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        deleteLabel.textAlignment = .center
        deleteLabel.textColor = .white
        originalCenterX = center.x
        contentView.frame = bounds
        addPanGesutre()
        priceLabel.layer.cornerRadius = 5
        priceLabel.clipsToBounds = true
        priceLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteLabel.frame = bounds
        bringSubview(toFront: contentView)
    }
}

extension ItemCollectionViewCell: UIGestureRecognizerDelegate {
    private func addPanGesutre() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    @objc private func pan(_ recogniser: UIPanGestureRecognizer) {
        switch recogniser.state {
        case .began: break
        case .ended:
            if delete {
                // perform delete
                if delegate != nil {
                    delegate!.deleteItemInCell(self)
                }
            } else {
                // restore to original position (delete cancelled)
                UIView.animate(withDuration: 0.2, animations: {
                    self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                })
            }
        case .changed:
            let translation = recogniser.translation(in: self)
            let width = contentView.frame.width
            let height = contentView.frame.height
            displacement = contentView.center.x - originalCenterX!
            if fabs(displacement) > threashold {
                if fabs(translation.x) < threashold {
                    // cancel delete (User swipes back)
                    delete = false
                    UIView.animate(withDuration: 0.2, animations: {
                        self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                    })
                    delete = false
                } else {
                    delete = true
                    let dir = (displacement > 0) ? 1: -1
                    UIView.animate(withDuration: 0.2, animations: {
                        self.contentView.frame = CGRect(x: CGFloat(dir) * width, y: 0, width: self.frame.width, height: self.frame.height)
                    })
                }
                
            } else {
                contentView.frame = CGRect(x: translation.x, y: 0, width: width, height: height)
                delete = false
            }
        default:
            UIView.animate(withDuration: 0.2, animations: {
                self.contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            })
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // horizontal only
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = pan.velocity(in: self)
        return fabs(velocity.y * 2) < fabs(velocity.x)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // make pan work with scroll view
        return true
    }
    
    
}

