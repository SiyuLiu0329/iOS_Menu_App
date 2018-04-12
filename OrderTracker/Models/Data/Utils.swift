//
//  Data.swift
//  OrderTracker
//
//  Created by macOS on 23/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

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
