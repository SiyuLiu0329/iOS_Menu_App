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
    func didReceiveOrderFromServerAfterPayment(newItem index: Int, wasInerted inserted: Bool)
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
    func didReceiveOrderFromServerAfterPayment(newItem index: Int, wasInerted inserted: Bool) {
        if !inserted {
            if let cell = clientOrderCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ClientOrderCollectionViewCell {
                cell.configure(loadingOrder: clientModel.orders[index])
            }
            clientOrderCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            
        } else {
            clientOrderCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
        }
    }
}

extension ClientViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clientModel.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clientOrderCell", for: indexPath) as! ClientOrderCollectionViewCell
        cell.configure(loadingOrder: clientModel.orders[indexPath.row])
        return cell
    }
    
    
    
    // layout options
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 20
        let width = collectionView.frame.width / 3 - 13
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
