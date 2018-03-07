//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    var orderList: OrderList!
    var itemNumber: Int?
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDel: UIButton!

    @IBOutlet weak var quantityPicker: UIPickerView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let currentItem = item else { return }
        itemImage.image = UIImage(named: currentItem.imageURL)
        navigationController?.navigationBar.topItem?.title = "Item #\(currentItem.number)" + " - " + currentItem.name
        priceLabel.text = twoDigitPriceText(of: currentItem.totalPrice)
        collectionView.reloadData()
        quantityPicker.selectRow(currentItem.quantity - 1, inComponent: 0, animated: true)
    }
    
    private func addGradientMaskToImageView() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.3).cgColor]
        gradient.locations = [0, 0.3, 0.7, 1]
        itemImage.layer.addSublayer(gradient)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.isTranslucent = true
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.topItem?.title = ""
        
        item = orderList.getItem(numbered: 1)
        btnAdd.backgroundColor = UIColor.lightGray
        btnAdd.isEnabled = false
        navigationController?.navigationBar.barTintColor = DesignConfig.detailNavBarColour
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 36/255, green: 126/255, blue: 46/255, alpha: 1),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: .light)
        ]
        collectionView.delegate = self
        collectionView.dataSource = self
        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        collectionView.backgroundColor = DesignConfig.detailConnectionViewBackgoundColour
        disableButtonsIfEmpty()
        configureLeftView()
        refreshUI()
        addGradientMaskToImageView()
    }
    
    private func configureLeftView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rightView.addSubview(blurEffectView)
        rightView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        rightView.sendSubview(toBack: blurEffectView)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSummary" {
            guard let navController = segue.destination as? UINavigationController else { return }
            guard let summaryController = navController.viewControllers.first as? SummaryViewController else { return }
            summaryController.orderList = orderList
            
        } else if segue.identifier == "menuSegue" {
            guard let navController = segue.destination as? UINavigationController else { return }
            guard let menuController = navController.viewControllers.first as? MenuViewController else { return }
            menuController.orderList = orderList
            menuController.delegate = self
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath) as! OptionCollectionViewCell
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
            let collectionViewCell = cell as! OptionCollectionViewCell
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
        let cell = sender as! OptionCollectionViewCell
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
        quantityPicker.selectRow(0, inComponent: 0, animated: true)
        disableButtonsIfEmpty()
    }
    
    @IBAction func btnAddOrder(_ sender: Any) {
        guard itemNumber != nil,
            orderList.getSubTotal(ofItem: itemNumber!) != 0 else { return }
        orderList.addItem(itemNumber: itemNumber!)
        item = orderList.menuItems[itemNumber!]
        disableButtonsIfEmpty()
        dimAllCells()
    }
    
    private func disableButtonsIfEmpty() {
        guard let selectedItem = item else { return }
        let quantity = orderList.getQuantity(ofItem: selectedItem.number)
        if quantity == 0 {
            btnAdd.backgroundColor = UIColor.lightGray
            btnAdd.isEnabled = false
        } else {
            btnAdd.backgroundColor = UIColor(red: 65/255, green: 169/255, blue: 56/255, alpha: 1)
            btnAdd.isEnabled = true
        }
    }

}

extension DetailViewController: ItemSelectedDelegate {
    func updateUIForItem(numbered number: Int) {
        if let item = orderList.getItem(numbered: number) {
            self.item = item
        }
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UILabel()
        view.textColor = .white
        view.text = "\(row + 1)"
        view.font = UIFont.systemFont(ofSize: 150, weight: .thin)
        view.textAlignment = .center
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        orderList.setQuantity(ofItem: itemNumber!, to: row + 1)
        priceLabel.text = twoDigitPriceText(of: orderList.getSubTotal(ofItem: itemNumber!))
    }
}

