//
//  ItemEditorViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ItemEditorViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var type: ItemEditorOperationType!
    var menuModel: MenuModel!
    var itemIndex: Int?
    var itemEditorModel = ItemEditorModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        let cell = UINib(nibName: "ItemEditorInputCell", bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
    }
    
    func setUpView() {
        switch type! {
        case .addNew:
            navigationController?.topViewController?.title = "New Item"
        case .editExisting(itemIndex: let index):
            itemIndex = index
            navigationController?.topViewController?.title = menuModel.menuItems[index].name
            itemEditorModel.unpackItem(menuModel.menuItems[itemIndex!])
        }
    }
}

extension ItemEditorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return itemEditorModel.options.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let header = Bundle.main.loadNibNamed("EditorItemTableViewHeaderCell", owner: self, options: nil)!.first as! EditorItemTableViewHeaderCell
            header.selectionStyle = .none
            if let index = itemIndex {
                header.itemImageView.image = UIImage(named: menuModel.menuItems[index].imageURL)
            } else {
                // new item, use place holder image
            }
            header.configure(itemName: itemEditorModel.name, itemNumber: itemEditorModel.number, itemPrice: itemEditorModel.price)
            return header
        } else if indexPath.section == 1 {
            // section for colours
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemEditorInputCell
            cell.clipsToBounds = true
            cell.accessoryType = .disclosureIndicator
            cell.layer.cornerRadius = 10
            return cell
        } else {
            // section for options
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            if indexPath.row == 0 {
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == itemEditorModel.options.count - 1 {
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.cornerRadius = 0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}
