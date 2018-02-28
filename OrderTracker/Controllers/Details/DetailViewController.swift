//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, SummaryViewControllerDelegate {

    var itemNumber: Int?
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightNavBarItem: UIBarButtonItem!
    
    var orderList: OrderList! {
        didSet {
            updateNavBarPrice()
        }

    }
    
    func updateNavBarPrice() {
        guard orderList != nil else { return }
        // update labels if needed
    }
    
    private func twoDigitPriceText(of price: Double) -> String {
        return String(format: "$%.2f", price)
    }
    
    var item: MenuItem? {
        didSet {
            itemNumber = item?.number
            refreshUI()
        }
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let currentItem = item else { return }
        itemImage.image = UIImage(named: currentItem.imageURL)
        navigationController?.navigationBar.topItem?.title = String(describing: currentItem.number) + ". " + currentItem.name
        updateNavBarPrice()
        quantity.text = String(describing: currentItem.quantity)
        priceLabel.text = twoDigitPriceText(of: currentItem.totalPrice)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkText]
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSummary" {
            guard let navController = segue.destination as? UINavigationController else { return }
            guard let summaryController = navController.viewControllers.first as? SummaryViewController else { return }
            summaryController.orderList = orderList
            summaryController.delegate = self
            
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard item != nil else { return 0 }
        return item!.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath) as! CollectionViewCell
        if let currentItem = item {
            cell.itemDescription.text = currentItem.options[indexPath.row].description
            cell.itemDescription.isEditable = false
            cell.delegate = self
            cell.toggleState = currentItem.options[indexPath.row].value
        }
        return cell
    }
    
    func dimAllCells() {
        let cells = collectionView.visibleCells
        for cell in cells {
            let collectionViewCell = cell as! CollectionViewCell
            collectionViewCell.dim()
            collectionViewCell.toggleState = false
        }
    }
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dim = collectionView.bounds.width / 4 - 5
        return CGSize(width: dim, height: dim)
    }
    
}

extension DetailViewController: optionButtonDelegate {
    func optionaButtonPressed(_ sender: Any) {
        let cell = sender as! CollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell){
            orderList.toggleOptionValue(ofOption: indexPath.row, forItem: itemNumber!)
            priceLabel.text = twoDigitPriceText(of: orderList.getSubTotal(ofItem: itemNumber!))
            cell.toggleState = !cell.toggleState
            if cell.toggleState == true {
                cell.light()
            } else {
                cell.dim()
            }
        }
    }
}


extension DetailViewController {
    // Button actions
    @IBAction func btnClearPressed(_ sender: Any) {
        guard itemNumber != nil else { return }
        orderList.resetTamplateItem(itemNumber: itemNumber!)
        item = orderList.getItem(numbered: itemNumber!)
        dimAllCells()
    }
    
    @IBAction func btnIncrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.getItem(numbered: itemNumber!) != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: 1)
        quantity.text = String(describing: orderList.getQuantity(ofItem: itemNumber!))
        priceLabel.text = twoDigitPriceText(of: orderList.getSubTotal(ofItem: itemNumber!))
    }
    
    @IBAction func btnDecrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.getItem(numbered: itemNumber!) != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: -1)
        quantity.text = String(describing: orderList.getQuantity(ofItem: itemNumber!))
        priceLabel.text = twoDigitPriceText(of: orderList.getSubTotal(ofItem: itemNumber!))
    }
    
    @IBAction func btnAddOrder(_ sender: Any) {
        guard itemNumber != nil,
            orderList.getSubTotal(ofItem: itemNumber!) != 0 else { return }
        orderList.addItem(itemNumber: itemNumber!)
        item = orderList.menuItems[itemNumber!]
        dimAllCells()
        updateNavBarPrice()
    }

}

