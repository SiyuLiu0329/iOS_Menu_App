//
//  MenuModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

class MenuModel {
    var savePath: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("menu").appendingPathComponent(menuName)
    }
    
    var menuItems: [MenuItem] = []
    var menuName: String
    
    func toggleOptionValue(at optionIndex: Int, inPendingItem index: Int) {
        menuItems[index].toggleSelectetState(ofOption: optionIndex)
    }
    
    func getValue(ofOption optionIndex: Int, inPendingItem index: Int) -> Bool {
        return menuItems[index].options[optionIndex].value
    }
    
    func getOptions(inItem index: Int) -> [Option] {
        return menuItems[index].options
    }
    
    init(menuName name: String) {
        self.menuName = name
    }
    
    func addItemToMenu(item: MenuItem) {
        if let index = menuItems.index(where: {$0.typeHash == item.typeHash}) {
            menuItems[index] = item
        } else {
            menuItems.append(item)
        }
    }

}

