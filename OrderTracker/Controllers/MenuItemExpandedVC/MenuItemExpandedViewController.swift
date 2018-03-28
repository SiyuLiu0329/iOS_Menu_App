//
//  MenuItemExpandedViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 20/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
protocol ItemWithOptionsAddedDelegate: class {
    func addItemToOrder(itemNumber number: Int)
}

protocol MenuItemExpandedViewControllerDismissedDelegate: class {
    func popoverDidDisappear() // called when this view is dismissed (to animate dim)
    func popoverWillAppear()
}

class MenuItemExpandedViewController: UIViewController {
    var orderList: OrderList?
    var itemId: Int?
    var themeColour: UIColor?
    weak var delegate: DetailViewControllerDelegate?
    weak var popoverDelegate: MenuItemExpandedViewControllerDismissedDelegate?
    var optionDataSource: OptionaTableViewDataSource!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        orderList?.resetTamplateItem(itemNumber: itemId!)
        if popoverDelegate != nil {
            popoverDelegate!.popoverDidDisappear()
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if delegate != nil {
            let itemIdx = orderList?.addItemToLoadedOrder(number: itemId!)
            delegate?.orderAdded(toOrderNumbered: itemIdx!)
        }
    }
    
    private var item: MenuItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        optionDataSource = OptionaTableViewDataSource(data: orderList!, itemId: itemId!)
        optionTableView.delegate = self
        optionTableView.dataSource = optionDataSource
        addButton.tintColor = .white
        addButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addButton.layer.cornerRadius = 5
        addButton.clipsToBounds = true
        addButton.layer.maskedCorners = [.layerMinXMinYCorner]
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
        let cell = tableView.cellForRow(at: indexPath) as! OptionTableViewCell
        orderList?.toggleOptionValue(at: indexPath.row, inItem: itemId!)
        cell.value = orderList!.getValue(ofOption: indexPath.row, inItem: itemId!)
    }
}
