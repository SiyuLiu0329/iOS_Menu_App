//
//  ItemEditorViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
import EFColorPicker

protocol ItemEditorViewControllerDelegate: class {
    func itemEdited(item: MenuItem)
}

class ItemEditorViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var type: ItemEditorOperationType!
    weak var delegate: ItemEditorViewControllerDelegate?
    private var dataSource: ItemEditorViewControllerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = UINib(nibName: "ItemEditorInputCell", bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: "cell")
        setUpView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "opCell")
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorColor = .clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onDoneButtonPressed(_:)))
    }
    
    @objc func onDoneButtonPressed(_ sender: Any?) {
        if let item = dataSource.itemEditorModel.pack() {
            if delegate != nil {
                delegate!.itemEdited(item: item)
            }
            navigationController?.popViewController(animated: true)

        }
    }
    
    func setUpView() {
        switch type! {
        case .addNew(let newIndex):
            navigationController?.topViewController?.title = "New Item"
            dataSource = ItemEditorViewControllerDataSource()
            dataSource.itemEditorModel.number = newIndex + 1
        case .editExisting(item: let item):
            navigationController?.topViewController?.title = item.name
            dataSource = ItemEditorViewControllerDataSource()
            dataSource.itemEditorModel.unpackItem(item)
        }
    }
}

extension ItemEditorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        return 44
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
            colorSelectionController.color = dataSource.itemEditorModel.colour
            
            self.present(navCtrl, animated: true, completion: nil)
            return
        }
        
        if indexPath.section == 2 {
            let newOptionVC = NewOptionViewController(nibName: "NewOptionViewController", bundle: Bundle.main)
            if indexPath.row != 0 {
                let option = dataSource.itemEditorModel.options[indexPath.row - 1]
                newOptionVC.loadInitialInfo(name: option.description, price: option.price, index: indexPath.row - 1)
            }
            newOptionVC.delegate = self
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(newOptionVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}

extension ItemEditorViewController: EFColorSelectionViewControllerDelegate {
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        dataSource.itemEditorModel.colour = color
        tableView.reloadSections([1], with: .none)
    }
}

extension ItemEditorViewController: NewOptionViewControllerDelegate {
    func didCreateNewOption(named name: String, pricedAt price: Double) {
        dataSource.itemEditorModel.insertOption(named: name, pricedAt: price)
        tableView.insertRows(at: [IndexPath(row: 1, section: 2)], with: .automatic)
    }
    
    func didEditOption(at index: Int, name: String, price: Double) {
        dataSource.itemEditorModel.editItem(at: index, name: name, price: price)
        tableView.reloadData()
    }
}
