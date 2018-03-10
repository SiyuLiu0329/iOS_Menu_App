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
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDel: UIButton!

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var itemDetailView: UIView!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityPicker: UIPickerView!

    private func twoDigitPriceText(of price: Double) -> String {
        return String(format: "$%.2f", price)
    }
    
    var item: MenuItem? {
        didSet {
            itemNumber = item?.number
            itemNumberLabel.text = "\(itemNumber!)"
            itemNameLabel.text = item?.name
            submitBtn.backgroundColor = DesignConfig.getColour(withSeed: itemNumber!).withAlphaComponent(0.4)
            refreshUI()
        }
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        guard let currentItem = item else { return }
        itemImage.image = UIImage(named: currentItem.imageURL)
        navigationController?.navigationBar.topItem?.title = "Item #\(currentItem.number)" + " - " + currentItem.name
        priceLabel.text = twoDigitPriceText(of: currentItem.totalPrice)
        optionTableView.reloadData()
        quantityPicker.selectRow(currentItem.quantity - 1, inComponent: 0, animated: true)
        unitPriceLabel.text = twoDigitPriceText(of: orderList.getUnitPrice(ofItem: itemNumber!)) + "/ea"
    }
    
    private func addGradientMaskToImageView() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        gradient.locations = [0, 0.3, 0.7, 1]
        itemImage.layer.addSublayer(gradient)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        item = orderList.getItem(numbered: 1)

        navigationController?.navigationBar.barTintColor = DesignConfig.detailNavBarColour
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 36/255, green: 126/255, blue: 46/255, alpha: 1),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: .light)
        ]
        optionTableView.delegate = self
        optionTableView.dataSource = self
        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        optionTableView.backgroundColor = .clear
        optionTableView.separatorColor = .clear
        
        itemNumberLabel.layer.cornerRadius = 10
        itemNumberLabel.clipsToBounds = true
        itemNumberLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addBlurTo(view: quantityView)
        addBlurTo(view: totalView)
        addBlurTo(view: submitView)
        addBlurTo(view: commentView)
        addBlurTo(view: itemDetailView)
        addBlurTo(view: optionView)
        refreshUI()
        addGradientMaskToImageView()
        itemNameLabel.numberOfLines = 0
        
//        viewTrailingConstraint.constant = -200
    }
   
    
    private func addBlurTo(view uiView: UIView) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = uiView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.88
        uiView.addSubview(blurEffectView)
        uiView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        uiView.sendSubview(toBack: blurEffectView)
        uiView.layer.cornerRadius = 8
        uiView.clipsToBounds = true
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

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard item != nil else { return 0 }
        return item!.options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "opCell", for: indexPath) as! OptionTableViewCell
        if let currentItem = orderList.getItem(numbered: itemNumber!) {
            let option = currentItem.options[indexPath.row]
            print(option.value)
            cell.toggleState = option.value
            cell.configureCell(description: option.description)
        }
        return cell
    }
    

    func dimAllCells() {
        let cells = optionTableView.visibleCells
        for cell in cells {
            let collectionViewCell = cell as! OptionTableViewCell
            collectionViewCell.dim()
            collectionViewCell.toggleState = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? OptionTableViewCell {
            cell.toggleState = !cell.toggleState
            orderList.toggleOptionValue(ofOption: indexPath.row, forItem: itemNumber!)
            unitPriceLabel.text = twoDigitPriceText(of: orderList.getUnitPrice(ofItem: itemNumber!)) + "/ea"
            priceLabel.text = twoDigitPriceText(of: orderList.getSubTotal(ofItem: itemNumber!))
        }
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dim = collectionView.bounds.width - 5
        return CGSize(width: dim, height: 44)
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
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        guard itemNumber != nil,
            orderList.getSubTotal(ofItem: itemNumber!) != 0 else { return }
        orderList.addItem(itemNumber: itemNumber!)
        item = orderList.menuItems[itemNumber!]
        dimAllCells()
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
        view.font = UIFont.systemFont(ofSize: 150, weight: .ultraLight)
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

