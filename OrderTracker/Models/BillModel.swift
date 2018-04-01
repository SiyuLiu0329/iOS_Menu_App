//
//  BillModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 1/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

class BillModel {
    var totalPrice: Double
    var numberOfSplits: Int
    
    init(totalPrice price: Double, nSplits n: Int) {
        self.totalPrice = price
        self.numberOfSplits = n
    }
}
