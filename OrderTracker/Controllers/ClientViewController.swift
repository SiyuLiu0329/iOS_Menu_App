//
//  ClientViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ClientOrderViewDelegate: class {
    func didReceiveOrderFromServerAfterPayment(insertedAtindex index: Int)
}

class ClientViewController: UIViewController {
    @IBOutlet weak var clientOrderCollectionView: UICollectionView!
    
    var clientModel: ClientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Scheme.collectionViewBackGroundColour
        clientOrderCollectionView.backgroundColor = Scheme.collectionViewBackGroundColour
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ClientViewController: ClientOrderViewDelegate {
    func didReceiveOrderFromServerAfterPayment(insertedAtindex index: Int) {
    }
}
