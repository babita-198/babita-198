//
//  CartItemAddOn+CoreDataProperties.swift
//  FoodFox
//
//  Created by Nishant Raj on 02/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//
//

import Foundation
import CoreData

extension CartItemAddOn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItemAddOn> {
        return NSFetchRequest<CartItemAddOn>(entityName: "CartItemAddOn")
    }

    @NSManaged public var adonId: String?
    @NSManaged public var adonName: String?
    @NSManaged public var adonsPrice: Double
    @NSManaged public var cart: CartItem?

}
