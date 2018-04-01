//
//  BillModel.swift
//  OrderTracker
//
//  Created by Siyu Liu on 1/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

class BillModel {
    var numberOfSplits: Int {
        return selected.count
    }
    
    var selected: [Bool]
    var totalPrice: Double
    var numSelected = 0
    var pricePerSplit: Double {
        return totalPrice / Double(numberOfSplits)
    }
    
    init(totalPrice price: Double, numberOfItems number: Int) {
        selected = Array(repeating: false, count: number)
        totalPrice = price
    }
    
    private func cellSelected(atIndex index: Int) {
        selected[index] = true
        numSelected += 1
    }
    
    private func cellDeselectec(atIndex index: Int) {
        guard numSelected > 0 else { return }
        selected[index] = false
        numSelected -= 1
    }
    
    func toggleSelected(atIndex index: Int) {
        selected[index] ? cellDeselectec(atIndex: index) : cellSelected(atIndex: index)
    }
    
    func getAmountForSelectedItems() -> Double {
        return totalPrice * Double(numSelected) / Double(numberOfSplits)
    }
    
}
