//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {

    var itemNumber: Int?
    var dropDownView: DropDownView!
    var dropDownButton: DropDownButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalPrice: UILabel!

    
    var orderList: OrderList! {
        willSet {
            if totalPrice != nil {
                totalPrice.text = "Total: " + twoDigitPriceText(of: newValue.getTotalPrice())
            }
        }
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
    
    func refreshUI() {
        loadViewIfNeeded()
        guard let currentItem = item else { return }
        itemImage.image = UIImage(named: currentItem.imageURL)
        navigationController?.navigationBar.topItem?.title = currentItem.name
        quantity.text = String(describing: currentItem.quantity)
        priceLabel.text = twoDigitPriceText(of: currentItem.totalPrice)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpDropDownMenu()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        print(indexPath.row)
        return cell
    }
    
    
    private func setUpDropDownMenu() {
        addBarButton()
        addDropDownView()
        dropDownButton.delegate = dropDownView
    }
    
    func addBarButton() {
        dropDownButton = DropDownButton()
        dropDownButton.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        dropDownButton.translatesAutoresizingMaskIntoConstraints = false
        dropDownButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dropDownButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropDownButton.setTitle("Order Summary", for: .normal)
        dropDownButton.backgroundColor = UIColor.darkGray
        let item = UIBarButtonItem(customView: dropDownButton)
        self.navigationItem.setRightBarButtonItems([item, item], animated: true)
    }
    
    func addDropDownView() {
        dropDownView = DropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.addSubview(dropDownView)
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dropDownView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        dropDownView.leftAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        dropDownView.tableView.delegate = self
        dropDownView.tableView.dataSource = self
//        dropDownView.heightAnchor.constraint(equalToConstant: 500).isActive = true
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
            priceLabel.text = twoDigitPriceText(of: orderList.menuItems[itemNumber!]!.totalPrice)
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
        item = orderList.menuItems[itemNumber!]
        dimAllCells()
        totalPrice.text = "Total: " + twoDigitPriceText(of: orderList.getTotalPrice())
    }
    
    @IBAction func btnIncrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.menuItems[item!.number] != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: 1)
        quantity.text = String(describing: orderList.menuItems[itemNumber!]!.quantity)
        priceLabel.text = twoDigitPriceText(of: orderList.menuItems[itemNumber!]!.totalPrice)
    }
    
    @IBAction func btnDecrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.menuItems[item!.number] != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: -1)
        quantity.text = String(describing: orderList.menuItems[itemNumber!]!.quantity)
        priceLabel.text = twoDigitPriceText(of: orderList.menuItems[itemNumber!]!.totalPrice)
    }
    
    @IBAction func btnAddOrder(_ sender: Any) {
        guard itemNumber != nil,
            orderList.menuItems[itemNumber!]!.totalPrice != 0 else { return }
        orderList.addItem(itemNumber: itemNumber!)
        item = orderList.menuItems[itemNumber!]
        dimAllCells()
        totalPrice.text = "Total: " + twoDigitPriceText(of: orderList.getTotalPrice())
    }

}

