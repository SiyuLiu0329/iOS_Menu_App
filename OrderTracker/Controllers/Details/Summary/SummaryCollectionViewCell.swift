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
    private var originalCentreX: CGFloat!
    private var panGestureRecogniser: UIPanGestureRecognizer!
    private var delete = false
    private var displacement: CGFloat!
    private var panRecogniser: UIPanGestureRecognizer!
    private let colourView = UIView()
    weak var delegate: SummaryCellDelegate?
    var deleteThreashold: CGFloat = -250
    private let optionSize = 32
    private var deleteLabel = UILabel()
    private let optionSizeNA = 80
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var priceNumber: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var menuItem: MenuItem! {
        willSet {
            scrollView.subviews.forEach { $0.removeFromSuperview() }

            var i = 0
            for option in newValue.options {
                if option.value {
                    let label = UILabel()
                    label.font = label.font.withSize(20)
                    label.text = "\(i + 1). " + option.description
                    let yPosition = i * optionSize
                    label.frame = CGRect(x: 0, y: yPosition, width: Int(scrollView.frame.width), height: optionSize)
                    
                    scrollView.addSubview(label)
                    i += 1
                }
            }
            
            if i == 0 {
                let label = UILabel()
                label.font = label.font.withSize(60)
                label.text = "N/A"
                label.textColor = UIColor.lightGray
                let yPosition = 0
                label.frame = CGRect(x: 0, y: yPosition, width: Int(scrollView.frame.width), height: optionSizeNA)
                scrollView.addSubview(label)
                scrollView.contentSize.height = CGFloat(optionSizeNA)
            } else {
                scrollView.contentSize.height = CGFloat(optionSize * (i + 1))
            }
        }
        
        didSet {
            setUpCell()
            loadCellData()

        }
    }
    
    
    private func setUpCell() {
        submitButton.layer.cornerRadius = 15
        colourView.frame = CGRect(x: 0, y: 0, width: 120, height: frame.height)
        contentView.addSubview(colourView)
        setUpDeleteLabel()
        contentView.sendSubview(toBack: colourView)
        originalCentreX = deleteLabel.center.x
        layer.cornerRadius = 20
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        addGuestureRecogniser()
    }
    
    private func setUpDeleteLabel() {
        deleteLabel.text = "Delete"
        deleteLabel.backgroundColor = UIColor.red
        deleteLabel.textAlignment = NSTextAlignment.center
        deleteLabel.textColor = UIColor.white
        deleteLabel.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        deleteLabel.backgroundColor = UIColor.red
        contentView.addSubview(deleteLabel)
    }
    
    private func loadCellData() {
        priceNumber.text = "$\(menuItem.totalPrice)"
        quantityLabel.text = "X\(menuItem.quantity)"
        itemNumberLabel.text = "#\(menuItem.number)"
        
    }
    
    func assignColour(_ colour: UIColor) {
        submitButton.backgroundColor = colour.withAlphaComponent(0.5)
        colourView.backgroundColor = colour
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






