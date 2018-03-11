//
//  Data.swift
//  OrderTracker
//
//  Created by macOS on 23/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

func resetToDefault(forItem number: Int,  in items: [Int: MenuItem]) -> [Int: MenuItem] {
    var menuItems = items
    switch number {
    case 1:
        menuItems[1] = MenuItem(named: "Rice Noodle Soup with Sliced Pork", numbered: 1, itemType: .type1, pricedAt: 11.95, image: "1.png")
    case 2:
        menuItems[2] = MenuItem(named: "Rice Noodle Soup with Slow Cooked Pork", numbered: 2, itemType: .type1, pricedAt: 11.95, image: "2.png")
    case 3:
        menuItems[3] = MenuItem(named: "Signature Noodle Soup", numbered: 3, itemType: .type1veg, pricedAt: 11.95, image: "3.jpg")
    case 4:
        menuItems[4] = MenuItem(named: "Steamed Dumplings", numbered: 4, itemType: .type3, pricedAt: 12.50, image: "4.png")
    case 5:
        menuItems[5] = MenuItem(named: "Wonton Soup", numbered: 5, itemType: .type2, pricedAt: 10.95, image: "5.png")
    case 6:
        menuItems[6] = MenuItem(named: "Signature Noodle Soup", numbered: 6, itemType: .type1veg, pricedAt: 11.95, image: "6.png")
    case 7:
        menuItems[7] = MenuItem(named: "Sauced Noodles", numbered: 7, itemType: .type1, pricedAt: 11.95, image: "7.png")
    default:
        menuItems[1] = MenuItem(named: "Rice Noodle Soup with Sliced Pork", numbered: 1, itemType: .type1, pricedAt: 11.95, image: "1.png")
        menuItems[2] = MenuItem(named: "Rice Noodle Soup with Slow Cooked Pork", numbered: 2, itemType: .type1, pricedAt: 11.95, image: "2.png")
        menuItems[3] = MenuItem(named: "Signature Noodle Soup", numbered: 3, itemType: .type1veg, pricedAt: 11.95, image: "3.jpg")
        menuItems[4] = MenuItem(named: "Steamed Dumplings", numbered: 4, itemType: .type3, pricedAt: 12.50, image: "4.png")
        menuItems[5] = MenuItem(named: "Wonton Soup", numbered: 5, itemType: .type2, pricedAt: 10.95, image: "5.png")
        menuItems[6] = MenuItem(named: "Signature Noodle Soup", numbered: 6, itemType: .type1veg, pricedAt: 11.95, image: "6.png")
        menuItems[7] = MenuItem(named: "Sauced Noodles", numbered: 7, itemType: .type1, pricedAt: 11.95, image: "7.png")
    }
    return menuItems
}

func addDefaultOptionsUtl(for itemType: ItemType) -> [Option] {
    var options: [Option] = []
    switch itemType {
    case .type1:
        options.append(Option(of: "No Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "No Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "No Chive", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Noodles", selected: false, pricedAt: 2.00, imageAt: ""))
        options.append(Option(of: "Extra Meat", selected: false, pricedAt: 3.00, imageAt: ""))
        options.append(Option(of: "Extra Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Chive", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Vegies", selected: false, pricedAt: 0.00, imageAt: ""))
        
    case .type1veg:
        options.append(Option(of: "No Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Vegetarian", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "No Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "No Chive", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Noodles", selected: false, pricedAt: 2.00, imageAt: ""))
        options.append(Option(of: "Extra Meat", selected: false, pricedAt: 3.00, imageAt: ""))
        options.append(Option(of: "Extra Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Chive", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Vegies", selected: false, pricedAt: 0.00, imageAt: ""))
        
    case .type2:
        options.append(Option(of: "Pork & Seafood", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Chicken & Seafood", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Mushroom & Egg", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "No Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "No Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "No Chive", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Noodles", selected: false, pricedAt: 2.00, imageAt: ""))
        options.append(Option(of: "Extra Meat", selected: false, pricedAt: 3.00, imageAt: ""))
        options.append(Option(of: "Wonton Noodle Soup", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Coriander", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Spring Onion", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Chive", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Extra Vegies", selected: false, pricedAt: 0.00, imageAt: ""))
        
    case .type3:
        options.append(Option(of: "Pork & Seafood", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Chicken & Seafood", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Mushroom & Egg", selected: false, pricedAt: 0.00, imageAt: ""))
        options.append(Option(of: "Half Serving", selected: false, pricedAt: -5.5, imageAt: ""))
    }
    return options
}
