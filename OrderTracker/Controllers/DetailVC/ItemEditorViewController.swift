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
        print("done")
    }
    
    func setUpView() {
        switch type! {
        case .addNew(let newIndex):
            navigationController?.topViewController?.title = "New Item"
            itemIndex = newIndex
            dataSource = ItemEditorViewControllerDataSource(itemIndex: itemIndex!)
        case .editExisting(itemIndex: let index):
            itemIndex = index
            navigationController?.topViewController?.title = menuModel.menuItems[index].name
            dataSource = ItemEditorViewControllerDataSource(itemIndex: itemIndex!)
            dataSource.itemEditorModel.unpackItem(menuModel.menuItems[itemIndex!])
        }
    }
}

extension ItemEditorViewController: UITableViewDelegate {

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
            colorSelectionController.color = dataSource.itemEditorModel.colour ?? UIColor.red
            
            self.present(navCtrl, animated: true, completion: nil)
            return
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            print("add")
        }
        
    }
}

extension ItemEditorViewController: EFColorSelectionViewControllerDelegate {
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        dataSource.itemEditorModel.colour = color
        tableView.reloadSections([1], with: .none)
    }
}
