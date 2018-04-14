//
//  MenuModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class MenuModel {
    var savePath: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("menu").appendingPathComponent(menuName)
    }
    
    var menuItems: [MenuItem] = []
    var menuName: String
    
    private func initDir() {
        do {
            try FileManager.default.createDirectory(at: savePath, withIntermediateDirectories: true, attributes: nil)
        } catch let e {
            print(e)
        }
    }
    
    private func saveItem(item: MenuItem) {
        let url = savePath.appendingPathComponent(item.typeHash! + ".json")
        do {
            let data = try JSONEncoder().encode(item)
            try data.write(to: url)
        } catch let e {
            print(e)
        }
    }
    
    private func loadItems() {
        do {
            let decoder = JSONDecoder()
            let files = try FileManager.default.contentsOfDirectory(at: savePath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for file in files {
                let json = try Data.init(contentsOf: file)
                let item = try decoder.decode(MenuItem.self, from: json)
                menuItems.append(item)
                
            }
            menuItems = menuItems.sorted(by: { $0.number < $1.number })

        } catch let error {
            print(error)
        }
    }
    
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
        initDir()
        loadItems()
    }
    
    func addItemToMenu(item: MenuItem) {
        if let index = menuItems.index(where: {$0.typeHash == item.typeHash}) {
            menuItems[index] = item
        } else {
            menuItems.append(item)
        }
        saveItem(item: item)
    }
    
    func removeItem(at index: Int) {
        deleteItem(item: menuItems[index])
        menuItems.remove(at: index)
        
    }
    
    private func deleteItem(item: MenuItem) {
        let url = savePath.appendingPathComponent(item.typeHash! + ".json")
        do {
            try FileManager.default.removeItem(at: url)
        } catch let e {
            print(e)
        }
    }


}

extension MenuModel {
    private func loadFoodItems() {
        for item in menuItems {
            deleteItem(item: item)
        }
        menuItems = []
        let item = MenuItem(named: "Rice-noodle Soup With Sliced Pork", numbered: 1, pricedAt: 11.95, typeHash: Scheme.Util.randomString(length: 8), options: [
                Option(of: "More Coriander", selected: false, pricedAt: 0, imageAt: ""),
                Option(of: "More Chive", selected: false, pricedAt: 0, imageAt: ""),
                Option(of: "More Meat", selected: false, pricedAt: 3, imageAt: ""),
                Option(of: "More Noodles", selected: false, pricedAt: 2, imageAt: ""),
                Option(of: "No Coriander", selected: false, pricedAt: 0, imageAt: ""),
                Option(of: "No Chive", selected: false, pricedAt: 0, imageAt: ""),
                Option(of: "No Meat", selected: false, pricedAt: 0, imageAt: "")
            ], colour: getColour(withSeed: 1))
        menuItems.append(item)
        saveItem(item: item)
        
        let item2 = MenuItem(named: "Rice-noodle Soup With Slow-cooked Pork", numbered: 2, pricedAt: 11.95, typeHash: Scheme.Util.randomString(length: 8), options: [
            Option(of: "More Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Meat", selected: false, pricedAt: 3, imageAt: ""),
            Option(of: "More Noodles", selected: false, pricedAt: 2, imageAt: ""),
            Option(of: "No Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Meat", selected: false, pricedAt: 0, imageAt: "")
            ], colour: getColour(withSeed: 2))
        menuItems.append(item2)
        saveItem(item: item2)
        
        let item3 = MenuItem(named: "Signature Rice Noodle Soup", numbered: 3, pricedAt: 10.95, typeHash: Scheme.Util.randomString(length: 8), options: [
            Option(of: "More Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Meat", selected: false, pricedAt: 3, imageAt: ""),
            Option(of: "More Noodles", selected: false, pricedAt: 2, imageAt: ""),
            Option(of: "No Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Meat", selected: false, pricedAt: 0, imageAt: "")
            ], colour: getColour(withSeed: 3))
        menuItems.append(item3)
        saveItem(item: item3)
        
        let item4 = MenuItem(named: "Steamed Dumplings", numbered: 4, pricedAt: 12.50, typeHash: Scheme.Util.randomString(length: 8), options: [
            Option(of: "Pork & Seafood", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "Chicken & Seafood", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "Mushroom & Egg", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "Half Serving", selected: false, pricedAt: -5.5, imageAt: ""),

            ], colour: getColour(withSeed: 4))
        menuItems.append(item4)
        saveItem(item: item4)
        
        let item5 = MenuItem(named: "Wonton Soup", numbered: 5, pricedAt: 12.50, typeHash: Scheme.Util.randomString(length: 8), options: [
            Option(of: "Pork & Seafood", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "Chicken & Seafood", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "Mushroom & Egg", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "Wonton Noodle Soup", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Noodles", selected: false, pricedAt: 2, imageAt: ""),
            
            ], colour: getColour(withSeed: 5))
        menuItems.append(item5)
        saveItem(item: item5)
        
        let item6 = MenuItem(named: "Signature Noodle Soup", numbered: 6, pricedAt: 11.95, typeHash: Scheme.Util.randomString(length: 8), options: [
            Option(of: "More Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Meat", selected: false, pricedAt: 3, imageAt: ""),
            Option(of: "More Noodles", selected: false, pricedAt: 2, imageAt: ""),
            Option(of: "No Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Meat", selected: false, pricedAt: 0, imageAt: "")
            ], colour: getColour(withSeed: 6))
        menuItems.append(item6)
        saveItem(item: item6)
        
        let item7 = MenuItem(named: "Sauced Noodles", numbered: 7, pricedAt: 11.95, typeHash: Scheme.Util.randomString(length: 8), options: [
            Option(of: "More Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "More Meat", selected: false, pricedAt: 3, imageAt: ""),
            Option(of: "More Noodles", selected: false, pricedAt: 2, imageAt: ""),
            Option(of: "No Coriander", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Chive", selected: false, pricedAt: 0, imageAt: ""),
            Option(of: "No Meat", selected: false, pricedAt: 0, imageAt: "")
            ], colour: getColour(withSeed: 7))
        menuItems.append(item7)
        saveItem(item: item7)
    }
    
    private func loadDrinks() {
        
    }
    
    func loadDefaultItems() {
        if menuName == "Food" {
            loadFoodItems()
        } else {
            loadDrinks()
        }
    }
    
    func getColour(withSeed number: Int) -> UIColor {
        let nColour = 7
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        if number % nColour == 0 {
            r = 80
            g = 80
            b = 80
        } else if number % nColour == 1 {
            r = 104
            g = 81
            b = 116
        } else if number % nColour == 2 {
            r = 34
            g = 139
            b = 34
        } else if number % nColour == 3 {
            r = 24
            g = 61
            b = 97
        } else if number % nColour == 4 {
            r = 152
            g = 80
            b = 60
        } else if number % nColour == 5 {
            r = 78
            g = 97
            b = 114
        } else {
            r = 88
            g = 35
            b = 53
            
        }
        
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
