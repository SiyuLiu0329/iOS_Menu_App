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
        let billAllCellNib = UINib(nibName: "ClientOrderCollectionViewCell", bundle: Bundle.main)
        clientOrderCollectionView.register(billAllCellNib, forCellWithReuseIdentifier: "clientOrderCell")
        clientOrderCollectionView.delegate = self
        clientOrderCollectionView.dataSource = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ClientViewController: ClientOrderViewDelegate {
    func didReceiveOrderFromServerAfterPayment(insertedAtindex index: Int) {
        clientOrderCollectionView.reloadData()
    }
}

extension ClientViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clientModel.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clientOrderCell", for: indexPath) as! ClientOrderCollectionViewCell
        cell.backgroundColor = .red
        return cell
    }
    
    
}
