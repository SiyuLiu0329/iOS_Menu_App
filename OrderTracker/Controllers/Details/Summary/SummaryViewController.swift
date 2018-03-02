//
//  SummaryTableViewController.swift
//  OrderTracker
//
//  Created by macOS on 24/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol SummaryViewControllerDelegate: class {
    func updateNavBarPrice()
}

class SummaryViewController: UIViewController {
    var orderList: OrderList! {
        didSet {
            prepareDataForTableView()
        }
    }
    
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    weak var delegate: SummaryViewControllerDelegate?
    private var expanded: [Bool]!

    
    
    private func prepareDataForTableView() {
        expanded = Array(repeating: false, count: orderList.getItemsInCurrentOrder().count)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 500, height: 700)
        setUpCollectionView()
        disableSubmitIfEmpty()
        updateLabelOnSubmitButton()
        btnSubmit.setTitle("Order is Empty", for: .disabled)
        addBlur()

    }
    
    private func addBlur() {
        summaryCollectionView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)

        if let popover = navigationController?.popoverPresentationController {
            popover.backgroundColor = UIColor.clear
        }

//        collectionVIew.separatorColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Order Summary"
    }
}


extension SummaryViewController {
    // submit button functions
    @IBAction func btnSubmitPressed(_ sender: Any) {
        orderList.submitCurrentOrder(asTable: 1, withPaymentStatus: .card)
        disableSubmitIfEmpty()
        updateLabelOnSubmitButton()
        summaryCollectionView.reloadData()
        if delegate != nil {
            delegate!.updateNavBarPrice()
        }
    }
    
    private func disableSubmitIfEmpty() {
        if orderList.getItemsInCurrentOrder().isEmpty {
            btnSubmit.isEnabled = false // may dim it down a bit in the future
            btnSubmit.backgroundColor = UIColor.gray
        } else {
            btnSubmit.backgroundColor = UIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 1)
        }
    }
    
    func updateLabelOnSubmitButton() {
        let updatedText = "Submit All (" + String(describing: twoDigitPriceText(of: orderList.getTotalPriceOfCurrentOrder())) + ")"
        btnSubmit.setTitle(updatedText, for: .normal)
    }
}

extension SummaryViewController {
    // helper functions
    private func twoDigitPriceText(of price: Double) -> String {
        return String(format: "$%.2f", price)
    }
}
    
extension SummaryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    private func setUpCollectionView() {
        summaryCollectionView.delegate = self
        summaryCollectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.getItemsInCurrentOrder().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = summaryCollectionView.dequeueReusableCell(withReuseIdentifier: "sCell", for: indexPath) as! SummaryCollectionViewCell
        cell.menuItem =  orderList.getItemsInCurrentOrder()[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 440, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension SummaryViewController: SummaryCellDelegate {
    func removeItemAt(_ cell: SummaryCollectionViewCell) {
        guard let indexPath = summaryCollectionView.indexPath(for: cell) else { return }
        orderList.removeItemInCurrentOrder(numbered: indexPath.row)
        summaryCollectionView.deleteItems(at: [indexPath])
        updateLabelOnSubmitButton()
        disableSubmitIfEmpty()
    }
    
    func submitItem(inCell cell: SummaryCollectionViewCell) {
        guard let indexPath = summaryCollectionView.indexPath(for: cell) else { return }
        guard let item = orderList.getItemInCurrentOrder(numberInOrder: indexPath.row) else { return }
    }
}

