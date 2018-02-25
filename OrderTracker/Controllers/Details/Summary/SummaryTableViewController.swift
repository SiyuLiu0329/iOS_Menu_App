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

class SummaryTableViewController: UIViewController {
    var defaultRowHeight: Int = 80
    var expandedRowHeight: Int = 250
    
    private var expandedArr: [Bool]!
    var orderList: OrderList!
    weak var delegate: SummaryViewControllerDelegate?
    var expanded = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 500, height: 700)
//        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        disableSubmitIfEmpty()
        updateLabelOnSubmitButton()
        btnSubmit.setTitle("Order is Empty", for: .disabled)
        addBlur()
        
        expandedArr = Array(repeating: false, count: orderList.getItemsInCurrentOrder().count)

    }
    
    private func addBlur() {

        tableView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        if let popover = navigationController?.popoverPresentationController {
            popover.backgroundColor = UIColor.clear
        }
        
        view.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Order Summary"
    }
}

extension SummaryTableViewController {
    // submit button functions
    @IBAction func btnSubmitPressed(_ sender: Any) {
        orderList.submitCurrentOrder(asTable: 1, withPaymentStatus: .card)
        disableSubmitIfEmpty()
        updateLabelOnSubmitButton()
        tableView.reloadData()
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

extension SummaryTableViewController {
    // helper functions
    private func twoDigitPriceText(of price: Double) -> String {
        return String(format: "$%.2f", price)
    }
}
    
extension SummaryTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.getItemsInCurrentOrder().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! SummaryTableViewCell

        cell.title.text = String(describing: orderList.getItemsInCurrentOrder()[indexPath.row].quantity) + " X " +
            orderList.getItemsInCurrentOrder()[indexPath.row].name
        cell.backgroundColor = UIColor.clear
        cell.title.textColor = UIColor.white

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.orderList.removeItemInCurrentOrder(numbered: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            disableSubmitIfEmpty()
            updateLabelOnSubmitButton()
            expandedArr.remove(at: indexPath.row)
        }
        
        if delegate != nil {
            delegate!.updateNavBarPrice()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedArr[indexPath.row] == true {
            return CGFloat(expandedRowHeight)
        } else {
            return CGFloat(defaultRowHeight)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0...expandedArr.count - 1 {
            if index == indexPath.row {
                expandedArr[index] = !expandedArr[index]
            } else {
                expandedArr[index] = false
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

