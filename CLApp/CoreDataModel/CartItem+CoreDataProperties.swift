//
//  CartItem+CoreDataProperties.swift
//  FoodFox
//
//  Created by Nishant Raj on 02/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var cartItemId: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemPrice: Double
    @NSManaged public var itemQuantity: Int32
    @NSManaged public var resturentId: String?
    @NSManaged public var cartItemAddOns: NSSet?
    @NSManaged public var branchId: String?
    @NSManaged public var vat: String?
    @NSManaged public var image: String?
    @NSManaged public var branchName: String?
    @NSManaged public var resturentDesc: String?
    @NSManaged public var estimateTime: Double
     @NSManaged public var addNotMessage: String
  

}

// MARK: Generated accessors for cartItemAddOns
extension CartItem {

    @objc(addCartItemAddOnsObject:)
    @NSManaged public func addToCartItemAddOns(_ value: CartItemAddOn)

    @objc(removeCartItemAddOnsObject:)
    @NSManaged public func removeFromCartItemAddOns(_ value: CartItemAddOn)

    @objc(addCartItemAddOns:)
    @NSManaged public func addToCartItemAddOns(_ values: NSSet)

    @objc(removeCartItemAddOns:)
    @NSManaged public func removeFromCartItemAddOns(_ values: NSSet)

}
