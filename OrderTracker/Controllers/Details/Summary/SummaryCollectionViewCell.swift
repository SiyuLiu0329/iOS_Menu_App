//
//  summaryCollectionViewCell.swift
//  OrderTracker
//
//  Created by macOS on 27/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol SummaryCellDelegate: class {
    func removeItemAt(_ cell: SummaryCollectionViewCell)
}

class SummaryCollectionViewCell: UICollectionViewCell {
    var originalCentreX: CGFloat!
    var panGestureRecogniser: UIPanGestureRecognizer!
    var deleteThreashold: CGFloat = -250
    var delete = false
    private var displacement: CGFloat!
    var menuItem: MenuItem!
    var panRecogniser: UIPanGestureRecognizer!
    weak var delegate: SummaryCellDelegate?
    let colourView = UIView()

    @IBOutlet weak var priceNumber: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    
    func setUpCell() {
        
        contentView.addSubview(colourView)
        colourView.frame = CGRect(x: 0, y: 0, width: 120, height: frame.height)
        contentView.sendSubview(toBack: colourView)
        contentView.bringSubview(toFront: deleteLabel)
        
        deleteLabel.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        deleteLabel.backgroundColor = UIColor.red
        originalCentreX = deleteLabel.center.x
        layer.cornerRadius = 20
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        addGuestureRecogniser()

        
    }
    
    func loadCellData() {
        
        priceNumber.text = "$\(menuItem.totalPrice)"
        quantityLabel.text = "X\(menuItem.quantity)"
        itemNumberLabel.text = "#\(menuItem.number)"
        setCellColour(withSeed: menuItem.number)
        
    }
    
    private func setCellColour(withSeed number: Int) {
        if number % 4 == 0 {
            colourView.backgroundColor = UIColor.darkGray
        } else if number % 4 == 1 {
            colourView.backgroundColor = UIColor.purple
        } else if number % 4 == 2 {
            colourView.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        } else if number % 4 == 3 {
            colourView.backgroundColor = UIColor(red: 7/255, green: 87/255, blue: 152/255, alpha: 1)
        }
    }
    
}

extension SummaryCollectionViewCell: UIGestureRecognizerDelegate {
    private func addGuestureRecogniser() {
        panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(self.panCell(_:)))
        panGestureRecogniser.delegate = self
        addGestureRecognizer(panGestureRecogniser)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }


    @objc private func panCell(_ recogniser: UIPanGestureRecognizer) {
        guard recogniser == self.panGestureRecogniser else { return }
        switch panGestureRecogniser.state {
        case .began:
            break

        case .ended:
            if delete == true {
                guard delegate != nil else { return }
                delegate!.removeItemAt(self)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.deleteLabel.frame = CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
                })
            }
            break
        case .changed:
            let translation = recogniser.translation(in: self)
            let width = frame.width
            let height = frame.height
            displacement = deleteLabel.center.x - originalCentreX
            if displacement < deleteThreashold {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.deleteLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                })
                delete = true
                
            } else {
                deleteLabel.frame = CGRect(x: width + translation.x, y: 0, width: width, height: height)
                delete = false
            }
            break
        default:
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteLabel.frame = CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
            })
        }
    }
}






