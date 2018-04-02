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
    var cardSales: Double = 0
    var cashSales: Double = 0
    var pricePerSplit: Double {
        return totalPrice / Double(numberOfSplits)
    }
    
    var priceForSelected: Double {
        return totalPrice * Double(numSelected) / Double(numberOfSplits)
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
    
    func billSelectedItems(withPaymentMethod method: PaymentMethod) -> [Int] {
        var res: [Int] = []
        for i in 0..<selected.count {
            if selected[i] {
                res.append(i)
                selected[i] =  false
            }
        }
        let paidAmount = totalPrice * Double(numSelected) / Double(numberOfSplits)
        totalPrice = totalPrice - paidAmount
        selected.removeLast(res.count)
        numSelected = 0

        if method == .card {
            cardSales += paidAmount
        } else {
            cashSales += paidAmount
        }
        return res
    }
    
    func appendUnselected() {
        selected.append(false)
    }
    
    func removeLast() {
        guard numberOfSplits > 0 else { return }
        let last = selected.last!
        selected.removeLast()
        if last {
            numSelected -= 1
        }
    }
}
