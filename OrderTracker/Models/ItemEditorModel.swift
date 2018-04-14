//
//  ItemEditorModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 12/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class ItemEditorModel {
    var name: String?
    var number: Int?
    var price: Double?
    var options: [Option] = []
    var colour = UIColor.red
    var image: UIImage?
    var hash = Scheme.Util.randomString(length: 8)
    
    func unpackItem(_ item: MenuItem) {
        name = item.name
        number = item.number
        price = item.unitPrice
        options = item.options
        hash = item.typeHash!
        let rgb = item.colour
        image = item.getImage()
        colour = UIColor(red: CGFloat(rgb.r), green:  CGFloat(rgb.g), blue:  CGFloat(rgb.b), alpha: 1)
    }
    
    func insertOption(named name: String, pricedAt price: Double) {
        options.insert(Option(of: name, selected: false, pricedAt: price, imageAt: ""), at: 0)
    }
    
    func deleteOption(at index: Int) {
        options.remove(at: index)
    }
    
    func editItem(at index: Int, name: String, price: Double) {
        var option = options[index]
        option.description = name
        option.price = price
        options[index] = option
    }
    
    func pack() -> MenuItem? {
        guard name != nil else { return nil }
        guard number != nil else { return nil }
        guard price != nil else { return nil }
        // deal with images later
        return MenuItem(named: name!, numbered: number!, pricedAt: price!, typeHash: hash, options: options, colour: colour)
    }
}
