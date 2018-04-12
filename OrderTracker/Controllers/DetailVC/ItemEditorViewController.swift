//
//  ItemEditorViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ItemEditorViewController: UIViewController {

    var type: ItemEditorOperationType!
    var menuModel: MenuModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
    }
    
    func setUpTitle() {
        switch type! {
        case .addNew:
            navigationController?.topViewController?.title = "New Item"
        case .editExisting(itemIndex: let index):
            navigationController?.topViewController?.title = menuModel.menuItems[index].name
        }
    }
}
