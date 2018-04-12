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
    var colour: UIColor?
    var image: UIImage?
    
    func unpackItem(_ item: MenuItem) {
        name = item.name
        number = item.number
        price = item.unitPrice
        options = item.options
        let rgb = item.colour
        image = item.getImage()
        colour = UIColor(red: CGFloat(rgb.r), green:  CGFloat(rgb.g), blue:  CGFloat(rgb.b), alpha: 1)
    }
}
