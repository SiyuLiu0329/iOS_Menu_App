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
    @IBOutlet weak var label: UILabel!
    private let deleteLabel = UILabel()
    private var originalCenterX: CGFloat?
    let threashold: CGFloat = 190
    private var delete = false
    private var displacement: CGFloat = 0
    weak var delegate: ItemCollectionViewCellDelegate?
    func configure() {
        addSubview(deleteLabel)
        contentView.backgroundColor = UIColor.darkGray
        deleteLabel.frame = bounds
        deleteLabel.backgroundColor = .red
        originalCenterX = center.x
        addPanGesutre()
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
        let point = recogniser.location(in: self)
        switch recogniser.state {
        case .began: break
        case .ended:
            if delete {
                if delegate != nil {
                    delegate!.deleteItemInCell(self)
                }
            } else {
                // restore to original position
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
                delete = true
                let dir = (displacement > 0) ? 1: -1
                UIView.animate(withDuration: 0.2, animations: {
                    self.contentView.frame = CGRect(x: CGFloat(dir) * width, y: 0, width: self.frame.width, height: self.frame.height)
                })
                
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
        return fabs(velocity.y) < fabs(velocity.x)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // make pan work with scroll view
        return true
    }
    
    
}

