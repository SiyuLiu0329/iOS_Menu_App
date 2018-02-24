//
//  SummaryTableViewController.swift
//  OrderTracker
//
//  Created by macOS on 24/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SummaryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var orderList: OrderList!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        addBlur()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderList.getItemsInCurrentOrder().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath)

        cell.textLabel?.text = String(describing: orderList.getItemsInCurrentOrder()[indexPath.row].quantity) + " X " +
            orderList.getItemsInCurrentOrder()[indexPath.row].name
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:20)
        return cell
    }


}

