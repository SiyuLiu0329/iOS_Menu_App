//
//  MenuItemExpandedViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 20/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol MenuItemExpandedViewControllerDismissedDelegate: class {
    func popoverDidDisappear() // called when this view is dismissed (to animate dim)
    func popoverWillAppear()
}

class MenuItemExpandedViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var quickTender: UIButton!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    weak var delegate: DetailViewControllerDelegate? // will perform similar actions to buttons in detailVC
    weak var popoverDelegate: MenuItemExpandedViewControllerDismissedDelegate? // used to dim / light background view
    private var item: MenuItem?
    var orderList: OrderList?
    var itemId: Int?
    var themeColour: UIColor?
    var optionDataSource: OptionaTableViewDataSource!
    
    @IBAction func addButtonAction(_ sender: Any) {
        let number = orderList?.pendItemToLoadedOrder(number: itemId!)
        if delegate != nil {
            delegate!.itemAdded(toIndex: number!)
        }
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderList?.resetTamplateItem(itemNumber: itemId!)
        if popoverDelegate != nil {
            popoverDelegate!.popoverDidDisappear()
        }
    }
    
    @IBAction func quickTenderAction(_ sender: Any) {
        if delegate != nil {
            delegate!.itemWillQuickTender(itemNumber: itemId!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionDataSource = OptionaTableViewDataSource(data: orderList!, itemId: itemId!)
        optionTableView.delegate = self
        optionTableView.dataSource = optionDataSource
        quickTender.tintColor = .white
        quickTender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        quickTender.layer.cornerRadius = 5
        quickTender.clipsToBounds = true
        quickTender.layer.maskedCorners = [.layerMinXMinYCorner]
        quickTender.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        quickTender.setTitle(Scheme.Util.twoDecimalPriceText(orderList!.menuItems[itemId!]!.unitPrice), for: .normal)
        
        
        addButton.tintColor = .white
        addButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addButton.layer.cornerRadius = 5
        addButton.clipsToBounds = true
        addButton.layer.maskedCorners = [.layerMaxXMinYCorner]
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        // rounded window
        contentView.layer.cornerRadius = 5
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
    
    override func viewWillAppear(_ animated: Bool) {
        if popoverDelegate != nil {
            popoverDelegate!.popoverWillAppear()
        }
    }
}


extension MenuItemExpandedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // changes are made to template items and will persist until this view is dimissed
        let cell = tableView.cellForRow(at: indexPath) as! OptionTableViewCell
        orderList?.toggleOptionValue(at: indexPath.row, inPendingItem: itemId!)
        cell.value = orderList!.getValue(ofOption: indexPath.row, inPendingItem: itemId!)
        quickTender.setTitle(Scheme.Util.twoDecimalPriceText(orderList!.menuItems[itemId!]!.unitPrice), for: .normal)
    }
}
