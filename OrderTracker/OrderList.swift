//
//  OrderList.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation

class OrderList {
    
    struct CurrentOrder {
        var items: [MenuItem] = []
        var tableNumber = 0
        var orderTotal: Double = 0
    }
    
    var allOrders: [CurrentOrder] = []
    
    var menuItems: [Int: MenuItem] = [:]
    private var currentOrder: CurrentOrder = CurrentOrder()
    
    init() {
        resetTamplateItem(itemNumber: 0)
    }
    
    func addItem(itemNumber number: Int) {
        guard let tmpItem = menuItems[number] else { return }
        currentOrder.items.append(tmpItem)
        currentOrder.orderTotal += tmpItem.totalPrice
        resetTamplateItem(itemNumber: number)
        print(currentOrder)
    }
    
    private func newOrder() {
        currentOrder = CurrentOrder()
    }

    
    private func resetTamplateItem(itemNumber number: Int) {
        switch number {
        case 1:
            menuItems[1] = MenuItem(named: "Rice Noodle Soup with Sliced Pork", numbered: 1, pricedAt: 11.95, image: "1.png")
        case 2:
            menuItems[2] = MenuItem(named: "Rice Noodle Soup with Slow Cooked Pork", numbered: 2, pricedAt: 11.95, image: "2.png")
        case 3:
            menuItems[3] = MenuItem(named: "Signature Noodle Soup", numbered: 3, pricedAt: 11.95, image: "3.jpg")
        case 4:
            menuItems[4] = MenuItem(named: "Steamed Dumplings", numbered: 4, pricedAt: 12.50, image: "4.png")
        case 5:
            menuItems[5] = MenuItem(named: "Wonton Soup", numbered: 5, pricedAt: 10.95, image: "5.png")
        case 6:
            menuItems[6] = MenuItem(named: "Signature Noodle Soup", numbered: 6, pricedAt: 11.95, image: "6.png")
        case 7:
            menuItems[7] = MenuItem(named: "Sauced Noodles", numbered: 7, pricedAt: 11.95, image: "7.png")
        default:
            menuItems[1] = MenuItem(named: "Rice Noodle Soup with Sliced Pork", numbered: 1, pricedAt: 11.95, image: "1.png")
            menuItems[2] = MenuItem(named: "Rice Noodle Soup with Slow Cooked Pork", numbered: 2, pricedAt: 11.95, image: "2.png")
            menuItems[3] = MenuItem(named: "Signature Noodle Soup", numbered: 3, pricedAt: 11.95, image: "3.jpg")
            menuItems[4] = MenuItem(named: "Steamed Dumplings", numbered: 4, pricedAt: 12.50, image: "4.png")
            menuItems[5] = MenuItem(named: "Wonton Soup", numbered: 5, pricedAt: 10.95, image: "5.png")
            menuItems[6] = MenuItem(named: "Signature Noodle Soup", numbered: 6, pricedAt: 11.95, image: "6.png")
            menuItems[7] = MenuItem(named: "Sauced Noodles", numbered: 7, pricedAt: 11.95, image: "7.png")
        }
        
    }
    
    func incrementQuantity(forItem number: Int, by amount: Int) {
        guard menuItems[number] != nil,
            menuItems[number]!.quantity >= -amount else { return } // negative number??
        menuItems[number]!.quantity += amount
    }
}
