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
    var orderList: OrderList! {
        didSet {
            prepareDataForTableView()
        }
    }
    
    weak var delegate: SummaryViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    private var expanded: [Bool]!

    private func prepareDataForTableView() {
        expanded = Array(repeating: false, count: orderList.getItemsInCurrentOrder().count)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 500, height: 700)
        tableView.delegate = self
        tableView.dataSource = self
        disableSubmitIfEmpty()
        updateLabelOnSubmitButton()
        btnSubmit.setTitle("Order is Empty", for: .disabled)
        addBlur()

    }
    
    private func addBlur() {
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)

        if let popover = navigationController?.popoverPresentationController {
            popover.backgroundColor = UIColor.clear
        }

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
        if expanded[indexPath.row] {
            return createExpandedCell(atIndexPath: indexPath)
        } else {
            return createContractedCell(atIndexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.orderList.removeItemInCurrentOrder(numbered: indexPath.row)
            self.expanded.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.disableSubmitIfEmpty()
            self.updateLabelOnSubmitButton()
            
            if self.delegate != nil {
                self.delegate!.updateNavBarPrice()
            }
        }
        
        return [delete]
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expanded[indexPath.row] {
            return 250
        }
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expanded[indexPath.row] = !expanded[indexPath.row]
    
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.left)
        tableView.endUpdates()
    }
    
    // table view delegate utils
    private func createExpandedCell(atIndexPath indexPath: IndexPath) -> SummaryExpandedTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seCell", for: indexPath) as! SummaryExpandedTableViewCell
        cell.backgroundColor = UIColor.clear

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.4)
        cell.selectedBackgroundView = bgColorView
        cell.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.4)
        return cell
    }
    
    private func createContractedCell(atIndexPath indexPath: IndexPath) -> SummaryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! SummaryTableViewCell
        
        cell.title.text = String(describing: orderList.getItemsInCurrentOrder()[indexPath.row].quantity) + " X " +
            orderList.getItemsInCurrentOrder()[indexPath.row].name
        cell.backgroundColor = UIColor.clear
        cell.title.textColor = UIColor.white

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.4)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
}

