//
//  summaryCollectionViewCell.swift
//  OrderTracker
//
//  Created by macOS on 27/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol SummaryCellDelegate: class {
    func deleteItemAt(_ cell: SummaryCollectionViewCell)
}

class SummaryCollectionViewCell: UICollectionViewCell {
    weak var delegate: SummaryCellDelegate?
    private var displacement: CGFloat = 0
    var originalCentreX: CGFloat!
    var panGestureRecogniser: UIPanGestureRecognizer!
    
    @IBOutlet weak var deleteLabel: UILabel!
    func setUpCell() {
        deleteLabel.alpha = 0
        originalCentreX = center.x
        layer.cornerRadius = 20
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        addGuestureRecogniser()
        
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
            if abs(displacement) > 400 && delegate != nil {
                delegate!.deleteItemAt(self)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.center.x = self.originalCentreX
                    self.deleteLabel.alpha = 0
                })
            }
            break
        case .changed:
            let translation = panGestureRecogniser.translation(in: self)
            center.x += translation.x
            displacement = center.x - originalCentreX
            panGestureRecogniser.setTranslation(CGPoint.zero, in: self)
            deleteLabel.alpha = min(1, abs(displacement/250))
            break
        default:
            UIView.animate(withDuration: 0.2, animations: {
                self.center.x = self.originalCentreX
                self.deleteLabel.alpha = 0
            })
            break
        }
    }
}
