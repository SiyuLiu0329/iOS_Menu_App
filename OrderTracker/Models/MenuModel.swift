//
//  MenuModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

class MenuModel {
    var menuItems: [Int: MenuItem] = [:]
    var menuName: String
    
    func resetTamplateItem(itemNumber number: Int) {
        menuItems = resetToDefault(forItem: number, in: menuItems)
    }
    
    func toggleOptionValue(at optionIndex: Int, inPendingItem itemNumber: Int) {
        menuItems[itemNumber]!.toggleSelectetState(ofOption: optionIndex)
    }
    
    func getValue(ofOption optionIndex: Int, inPendingItem itemNumber: Int) -> Bool {
        return menuItems[itemNumber]!.options[optionIndex].value
    }
    
    func getOptions(inItem itemNumber: Int) -> [Option] {
        return menuItems[itemNumber]!.options
    }
    
    init(menuName name: String) {
        self.menuName = name
        resetTamplateItem(itemNumber: 0)
    }
}

