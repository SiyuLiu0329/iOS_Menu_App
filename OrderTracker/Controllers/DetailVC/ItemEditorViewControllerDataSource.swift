//
//  ItemEditorViewControllerDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 13/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ItemEditorViewControllerDataSource: NSObject, UITableViewDataSource {
    let itemEditorModel = ItemEditorModel()
    let headers = ["Basic", "Colour", "Options"]
    var itemIndex: Int
    init(itemIndex index: Int) {
        itemIndex = index
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 2 else { return false }
        guard indexPath.row != 0 else { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let indexToDelete = indexPath.row - 1
        itemEditorModel.deleteOption(at: indexToDelete)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
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
            header.configure(itemName: itemEditorModel.name, itemNumber: itemEditorModel.number!, itemPrice: itemEditorModel.price, textInputViewDelegate: self)
            return header
        } else if indexPath.section == 1 {
            // section for colours
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemEditorInputCell
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            cell.accessoryType = .disclosureIndicator
            cell.layer.cornerRadius = 10
            cell.setColour(itemEditorModel.colour)
            
            return cell
        } else {
            // section for options
            let cell = tableView.dequeueReusableCell(withIdentifier: "opCell", for: indexPath)
            cell.selectionStyle = .none
            cell.clipsToBounds = true
            if indexPath.row == 0 {
                cell.textLabel?.text = "Add Option"
                cell.textLabel?.textColor = Scheme.editorThemeColour
            } else {
                cell.textLabel?.text = itemEditorModel.options[indexPath.row - 1].description
                cell.accessoryType = .none
                cell.textLabel?.tintColor = .black
            }
            cell.accessoryType = .disclosureIndicator
            
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}

extension ItemEditorViewControllerDataSource: TextFieldDelegate {
    func textDidChange(sender: TextInputView) {
        switch sender.titleLabel.text! {
        case "Item Name:":
            if sender.text.isEmpty {
                itemEditorModel.name = nil
            } else {
                itemEditorModel.name = sender.text
            }
        case "Price ($):":
            if let price = Double(sender.text) {
                itemEditorModel.price = price
            } else {
                itemEditorModel.price = nil
            }
        default:
            // this should never happen
            fatalError()
        }
    }
}
