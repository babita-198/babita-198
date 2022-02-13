//
//  MenuQuantityDetails.swift
//  FoodFox
//
//  Created by socomo on 16/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//
//
import Foundation
import UIKit


class MenuQuantityDetails: NSObject {
    
    var itemName: String?
    var menuItemId: String?
    var quantity: Int = 1
    var price: Double?
    var items = [PerItem]()
    
    init(params: [String: Any]) {
        if let menuItemId = params["menuItemId"] as? String {
            self.menuItemId = menuItemId
        }
        if let itemName = params["itemName"] as? String {
            self.itemName = itemName
        }
        if let quantity = params["quantity"] as? String {
            if let menuquantity = Int(quantity) {
                  self.quantity = menuquantity
            }
        }
        if let menuItemPrice = params["price"] as? Double {
            self.price = menuItemPrice
        }
        if let itemsArray = params["items"] as? [[String: Any]] {
            self.items = itemsArray.map({ PerItem(params: $0)})
        }
        
    }
}
struct PerItem {
    var addOnItemName: String?
    var addOnItemId: String?
    var price: Double = 0.0
    
    init(params: [String: Any]) {
        if let extraItemName = params["itemName"] as? String {
            self.addOnItemName = extraItemName
        }
        if let extraItemId = params["addOnid"] as? String {
            self.addOnItemId = extraItemId
        }
        if let price = params["addOnPrice"] as? Double {
            self.price = price
        }
    }
}
