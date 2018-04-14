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


}

