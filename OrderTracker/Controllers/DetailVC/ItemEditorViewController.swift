//
//  ItemEditorViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
import EFColorPicker

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "opCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onDoneButtonPressed(_:)))
    }
    
    @objc func onDoneButtonPressed(_ sender: Any?) {
        print("done")
    }
    
    func setUpView() {
        switch type! {
        case .addNew(let newIndex):
            navigationController?.topViewController?.title = "New Item"
            itemIndex = newIndex
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
            return itemEditorModel.options.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let header = Bundle.main.loadNibNamed("EditorItemTableViewHeaderCell", owner: self, options: nil)!.first as! EditorItemTableViewHeaderCell
            header.selectionStyle = .none
            if let image = itemEditorModel.image {
                header.itemImageView.image = image
            } else {
                // new item, use place holder image
                header.itemImageView.image = #imageLiteral(resourceName: "placeholder")
            }
            header.configure(itemName: itemEditorModel.name, itemNumber: itemIndex! + 1, itemPrice: itemEditorModel.price)
            return header
        } else if indexPath.section == 1 {
            // section for colours
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemEditorInputCell
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            cell.accessoryType = .disclosureIndicator
            cell.layer.cornerRadius = 10
            if let colour = itemEditorModel.colour {
                cell.setColour(colour)
            } else {
                cell.setColour(UIColor(red: 1, green: 0, blue: 0, alpha: 1))
            }
            
            return cell
        } else {
            // section for options
            let cell = tableView.dequeueReusableCell(withIdentifier: "opCell", for: indexPath)
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            if indexPath.row == 0 {
                cell.textLabel?.text = "Add Option"
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.textColor = Scheme.editorThemeColour
            } else {
                cell.textLabel?.text = itemEditorModel.options[indexPath.row - 1].description
                cell.accessoryType = .none
                cell.textLabel?.tintColor = .black
            }
            
            if itemEditorModel.options.count == 0 {
                // if this cell is the only cell, all four corners are rounded
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                return cell
            }
            
            if indexPath.row == 0 {
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == itemEditorModel.options.count {
                cell.layer.cornerRadius = 10
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.cornerRadius = 0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let sender = tableView.cellForRow(at: indexPath)!
            let colorSelectionController = EFColorSelectionViewController()
            let navCtrl = UINavigationController(rootViewController: colorSelectionController)
            navCtrl.navigationBar.backgroundColor = UIColor.white
            navCtrl.navigationBar.isTranslucent = false
            navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
            navCtrl.popoverPresentationController?.sourceView = sender
            navCtrl.popoverPresentationController?.sourceRect = sender.bounds
            
            colorSelectionController.delegate = self
            colorSelectionController.color = itemEditorModel.colour ?? UIColor.red
            
            self.present(navCtrl, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
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

extension ItemEditorViewController: EFColorSelectionViewControllerDelegate {
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        itemEditorModel.colour = color
        tableView.reloadSections([1], with: .automatic)
    }
}
