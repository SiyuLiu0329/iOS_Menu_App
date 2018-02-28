//
//  summaryCollectionViewCell.swift
//  OrderTracker
//
//  Created by macOS on 27/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {
    var originalCentreX: CGFloat!
    var panGestureRecogniser: UIPanGestureRecognizer!
    var deleteThreashold: CGFloat = 300
    
    @IBOutlet weak var deleteLabel: UILabel!
    func setUpCell() {
        deleteLabel.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        deleteLabel.backgroundColor = UIColor.red
        originalCentreX = deleteLabel.center.x
        layer.cornerRadius = 20
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        
    }
    
}

//extension SummaryCollectionViewCell: UIGestureRecognizerDelegate {
//    private func addGuestureRecogniser() {
//        panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(self.panCell(_:)))
//        panGestureRecogniser.delegate = self
//        addGestureRecognizer(panGestureRecogniser)
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//
//    @objc private func panCell(_ recogniser: UIPanGestureRecognizer) {
//        guard recogniser == self.panGestureRecogniser else { return }
//        switch panGestureRecogniser.state {
//        case .began:
//            break
//
//        case .ended:
//            if abs(displacement) > deleteThreashold && delegate != nil {
//                delegate!.deleteItemAt(self)
//            } else {
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.center.x = self.originalCentreX
//                    self.deleteLabel.alpha = 0
//                })
//            }
//            break
//        case .changed:
//            let translation = panGestureRecogniser.translation(in: self)
//            center.x += translation.x
//            displacement = center.x - originalCentreX
//            panGestureRecogniser.setTranslation(CGPoint.zero, in: self)
//            deleteLabel.alpha = min(1, abs(displacement/250))
//            if abs(displacement) > deleteThreashold {
//                deleteLabel.backgroundColor = UIColor.red
//            } else  {
//                deleteLabel.backgroundColor = UIColor.gray
//            }
//            break
//        default:
//            UIView.animate(withDuration: 0.2, animations: {
//                self.center.x = self.originalCentreX
//                self.deleteLabel.alpha = 0
//            })
//            break
//        }
//    }
//}

