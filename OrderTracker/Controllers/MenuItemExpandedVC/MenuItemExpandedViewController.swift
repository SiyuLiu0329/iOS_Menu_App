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
    @IBOutlet weak var customOptionButton: UIButton!
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
            delegate!.addItemToOrder(optionDataSource.getItemForBilling())
        }
    }
    
    @IBAction func onCustomOptionPressed(_ sender: Any) {
        let alert = UIAlertController(title: "New Custom Option", message: "Give some description and a price.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Option Description"
            // limite length here
            $0.delegate = self
            
        })
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Price"
            $0.keyboardType = .numberPad
            $0.delegate = self
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let nameField = alert!.textFields![0]
            let priceField = alert!.textFields![1]
            let price = Double(priceField.text!) ?? 0 // cannot be empty
            let name = nameField.text!
            let option = Option(of: name, selected: true, pricedAt: price)
            self.optionDataSource.customOptions.append(option)
            self.optionTableView.insertRows(at: [IndexPath(row: self.optionTableView.numberOfRows(inSection: 1), section: 1)], with: .automatic)
            self.priceLabel.text = Scheme.Util.twoDecimalPriceText(self.optionDataSource.getDisplayedPrice())
        })
        
        okAction.isEnabled = false
        alert.addAction(okAction)
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: alert.textFields?[0], queue: OperationQueue.main) { (notification) in
            let textField = alert.textFields![0]
            okAction.isEnabled = !textField.text!.isEmpty
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        menuModel.menuItems[itemId!].deselectAllOptions()
        if popoverDelegate != nil {
            popoverDelegate!.popoverDidDisappear()
        }
    }
    
    @IBAction func quickBillPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.quickBillItem(optionDataSource.getItemForBilling())
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
        customOptionButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if popoverDelegate != nil {
            popoverDelegate!.popoverWillAppear()
        }
    }
}

extension MenuItemExpandedViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let prospectiveText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        
        if string.count > 0 {
            if textField.keyboardType == .numberPad {
                let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.count <= 9
                
                let scanner = Scanner(string: prospectiveText)
                let resultingTextIsNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
                
                result = replacementStringIsLegal &&
                    resultingStringLengthIsLegal &&
                resultingTextIsNumeric
            } else {
                result = prospectiveText.count <= 20
            }
            
        }
        return result
    }
}


extension MenuItemExpandedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            menuModel.toggleOptionValue(at: indexPath.row, inPendingItem: itemId!)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
//             if this option is a custom option, remove on tap
            print(indexPath.row)
            optionDataSource.customOptions.remove(at: indexPath.row)
            optionTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        priceLabel.text = Scheme.Util.twoDecimalPriceText(optionDataSource.getDisplayedPrice())
        
    }
}
