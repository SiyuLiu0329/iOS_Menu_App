//
//  MasterTableViewController.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var itemNumber: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var overlay: UIImageView!
    
}

protocol ItemSelectedDelegate: class {
    func itemSelected(_ newItem: MenuItem)
}


class MasterViewController: UITableViewController {
    let orderList = OrderList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.selectRow(at: [0, 0], animated: true, scrollPosition: .top)
        tableView.backgroundColor = UIColor.darkGray
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderList.menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuCell
        if let item = orderList.menuItems[indexPath.row + 1] {
            cell.itemNumber.text = String(describing: item.number)
            cell.itemImg.image = UIImage(named: item.imageURL)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MenuCell
        guard let cellIndexPath = tableView.indexPath(for: cell) else { fatalError() }
        if segue.identifier == "segue1" {
            let controller = segue.destination as! UINavigationController
            let detailViewController = controller.topViewController as! DetailViewController
            detailViewController.item = self.orderList.menuItems[cellIndexPath.row + 1]
            detailViewController.orderList = orderList
        }
    }

}
