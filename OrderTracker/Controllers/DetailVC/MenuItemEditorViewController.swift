//
//  MenuItemEditorViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

enum ItemEditorOperationType {
    case editExisting(itemIndex: Int)
    case addNew(newIndex: Int)
}

protocol MenuEditorDelegate: class {
    func menuDidChange()
}

class MenuItemEditorViewController: UIViewController {
    var menuModel: MenuModel!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: MenuEditorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = UINib(nibName: "MenuEditorItemTableViewCell", bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        setupBarButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        if delegate != nil {
            delegate!.menuDidChange()
        }
    }
    
    private func setupBarButtons() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = Scheme.editorThemeColour
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAddButtonPressed(_:)))
        addButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = addButton
        navigationController?.topViewController?.title = menuModel.menuName
//        navigationController?.navigationBar.titleTextAttributes = [Foregra: UIColor.white]
        navigationController?.navigationBar.barStyle = .blackTranslucent
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.onCloseButtonPressed(_:)))
        self.navigationItem.leftBarButtonItem = closeButton
        closeButton.tintColor = .white
    }
    
    @objc func onCloseButtonPressed(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onAddButtonPressed(_ sender: Any?) {
        pushItemEditor(itemEditorOperationType: .addNew(newIndex: menuModel.menuItems.count))
    }

    func pushItemEditor(itemEditorOperationType type: ItemEditorOperationType) {
        let editor = ItemEditorViewController()
        editor.menuModel = menuModel
        editor.type = type
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(editor, animated: true)
    }
}

extension MenuItemEditorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuEditorItemTableViewCell
        cell.textLabel?.text = menuModel.menuItems[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushItemEditor(itemEditorOperationType: .editExisting(itemIndex: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            menuModel.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if delegate != nil {
                delegate!.menuDidChange()
            }
        }
    }
}
