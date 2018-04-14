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
    @IBOutlet weak var quickBill: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    weak var delegate: MenuDelegate? // will perform similar actions to buttons in detailVC
    weak var popoverDelegate: MenuItemExpandedViewControllerDismissedDelegate? // used to dim / light background view
    var menuModel: MenuModel!
    var itemId: Int?
    var themeColour: UIColor?
    var optionDataSource: OptionaTableViewDataSource!
    
    @IBAction func addButtonAction(_ sender: Any) {
        if delegate != nil {
            delegate!.addItemToOrder(menuModel.menuItems[itemId!])
        }
    }


    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        menuModel.menuItems[itemId!].deselectAllOptions()
        if popoverDelegate != nil {
            popoverDelegate!.popoverDidDisappear()
        }
    }
    
    @IBAction func quickTenderAction(_ sender: Any) {
        if delegate != nil {
            delegate!.quickBillItem(menuModel.menuItems[itemId!])
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionDataSource = OptionaTableViewDataSource(data: menuModel!, itemId: itemId!)
        optionTableView.delegate = self
        optionTableView.dataSource = optionDataSource
        quickBill.tintColor = .white
        quickBill.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        quickBill.layer.cornerRadius = 10
        quickBill.clipsToBounds = true
        quickBill.layer.maskedCorners = [.layerMinXMinYCorner]
        quickBill.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .light)
        
        
        addButton.tintColor = .white
        addButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        addButton.layer.maskedCorners = [.layerMaxXMinYCorner]
        // rounded window
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        priceLabel.textColor = .white
        priceLabel.text = Scheme.Util.twoDecimalPriceText(menuModel.menuItems[itemId!].unitPrice)
        
        let rgb = menuModel.menuItems[itemId!].colour
        themeColour = UIColor(red: CGFloat(rgb.r), green:  CGFloat(rgb.g), blue:  CGFloat(rgb.b), alpha: 1)
        
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
        menuModel.toggleOptionValue(at: indexPath.row, inPendingItem: itemId!)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        priceLabel.text = Scheme.Util.twoDecimalPriceText(menuModel.menuItems[itemId!].unitPrice)
    }
}
