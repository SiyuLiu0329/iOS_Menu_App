//
//  BillModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 1/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

class BillModel {
    var numberOfSplits: Int
    var totalPrice: Double
    
    init(totalPrice price: Double, numberOfItems number: Int) {
        numberOfSplits = number
        totalPrice = price
    }
    
}
