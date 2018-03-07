//
//  MenuViewController.swift
//  OrderTracker
//
//  Created by macOS on 7/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    var orderList: OrderList?
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    override func viewDidLoad() {
        setUpNavController()
    }
    
    private func setUpNavController() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        
        if let popover = navigationController?.popoverPresentationController {
            popover.backgroundColor = UIColor.clear
        }
        
        //        collectionVIew.separatorColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.65)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Menu"
    }
}
