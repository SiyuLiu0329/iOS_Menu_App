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
    
    @IBAction func btnAddOrder(_ sender: Any) {
        guard itemNumber != nil,
            orderList.menuItems[itemNumber!]!.totalPrice != 0 else { return }
        orderList.addItem(itemNumber: itemNumber!, forTable: 0)
        item = orderList.menuItems[itemNumber!]
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    
    @IBAction func btnIncrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.menuItems[item!.number] != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: 1)
        quantity.text = String(describing: orderList.menuItems[itemNumber!]!.quantity)
        priceLabel.text = "$" + String(describing: orderList.menuItems[itemNumber!]!.totalPrice)
    }
    
    @IBAction func btnDecrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.menuItems[item!.number] != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: -1)
        quantity.text = String(describing: orderList.menuItems[itemNumber!]!.quantity)
        priceLabel.text = "$" + String(describing: orderList.menuItems[itemNumber!]!.totalPrice)
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
        priceLabel.text = "$" + String(describing: currentItem.totalPrice)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: ItemSelectedDelegate {
    func itemSelected(_ newItem: MenuItem) {
        item = newItem
    }
    
}
