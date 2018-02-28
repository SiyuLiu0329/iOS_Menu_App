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
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!
    var cellLabel: UILabel!
    private var displacement: CGFloat = 0
    var originalCentreX: CGFloat!
    var panGestureRecogniser: UIPanGestureRecognizer!
    func setUpCell() {
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
        print(panGestureRecogniser.state.rawValue)
        switch panGestureRecogniser.state {
        case .began:
            break
            
        case .ended:
            if abs(displacement) > 400 && delegate != nil {
                delegate!.deleteItemAt(self)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.center.x = self.originalCentreX
                })
            }
            break
        case .changed:
            let translation = panGestureRecogniser.translation(in: self)
            center.x += translation.x
            //            print(translation)
            displacement = center.x - originalCentreX
            panGestureRecogniser.setTranslation(CGPoint.zero, in: self)
            break
        default:
            UIView.animate(withDuration: 0.2, animations: {
                self.center.x = self.originalCentreX
            })
        }
    }
}
