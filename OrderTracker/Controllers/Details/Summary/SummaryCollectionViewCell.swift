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
    var deleteThreashold: CGFloat = 300
    var delete = false
    private var displacement: CGFloat!
    var panRecogniser: UIPanGestureRecognizer!
    weak var delegate: SummaryCellDelegate?
    
    @IBOutlet weak var deleteLabel: UILabel!
    func setUpCell() {
        deleteLabel.frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
        deleteLabel.backgroundColor = UIColor.red
        originalCentreX = deleteLabel.center.x
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
            if displacement < -300 {
                delete = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.deleteLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                })
                
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






