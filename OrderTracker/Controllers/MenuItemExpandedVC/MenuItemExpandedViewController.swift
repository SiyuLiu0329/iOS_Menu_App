//
//  MenuItemExpandedViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 20/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class MenuItemExpandedViewController: UIViewController {
    var orderList: OrderList?
    var itemId: Int?
    var themeColour: UIColor?
    var optionDataSource: OptionaTableViewDataSource!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private var item: MenuItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        optionDataSource = OptionaTableViewDataSource(data: orderList!.menuItems[itemId!]!)
        optionTableView.delegate = self
        optionTableView.dataSource = optionDataSource
        
        // rounded window
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        themeColour = Scheme.getColour(withSeed: itemId!)
        
        // configure nav bar (tint, text and text colour)
        navBar.barTintColor = themeColour
        navBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .light),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
       
        
        // add blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        contentView.addSubview(blurEffectView)
        contentView.backgroundColor = themeColour?.withAlphaComponent(0.6)
        contentView.sendSubview(toBack: blurEffectView)
        
        optionTableView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        optionTableView.separatorColor = UIColor.clear
        
        guard item != nil else { return }
         navBar.topItem?.title = item!.name
    }
}

extension MenuItemExpandedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
