//
//  MenuOfRestaurant.swift
//  FoodFox
//
//  Created by socomo on 08/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit

class MenuOFRestaurant: NSObject {
  var branchId: String?
  var restaurantName: String?
    var branchName: String?
  var logoImage: String?
  var restaurantImage: String?
  var review: Int?
  var vat: String?
  var deliveryCharge: Double?
  var restaurantMenu = [RestaurantMenu]()
  var miniMumOrder: Double?
  var openingStatus: Int?
    var pickupservice: Int?
    
  init(param: [String: Any]) {
    
    if let branch = param["branchDetails"] as? [String: Any] {
        if let status = branch["openingStatus"] as? String {
            self.openingStatus = Int(status)
        }
        if let status = branch["pickupservice"] as? String {
            self.pickupservice = Int(status)
        }
    }
    
    if let data = param["restaurantDetails"] as? [String: Any] {
      if let id = data["_id"] as? String {
        self.branchId = id
      }
      if let charge = data["deliveryCharge"] as? Double {
        self.deliveryCharge = charge
      }
      
      if let min = data["minimumOrderValue"] as? Double {
        self.miniMumOrder = min
      }
      
      if let name = data["restaurantName"] as? String {
        self.restaurantName = name
      }
      if let image = data["logoURL"] as? [String: Any], let original = image["original"] as? String {
        self.logoImage = original
      }
      if let restaurantImage = data["imageURL"] as? [String: Any], let originalImage = restaurantImage["original"] as? String {
        self.restaurantImage = originalImage
      }
      if let totalReview = data["totalReview"] as? Int {
        self.review = totalReview
      }
      if let vat = data["vat"] as? String {
        self.vat = vat
      }
    }
    if let menu = param["restaurantMenu"] as? [[String: Any]] {
      self.restaurantMenu = menu.map({ RestaurantMenu(params: $0)})
    }
    
  }
}


struct RestaurantMenu {
  var menuId: String?
  var menuCategoryName: String?
  var menuItem = [MenuItem]()
  
  init(params: [String: Any]) {
    if let id = params["id"] as? String {
      self.menuId = id
    }
    if let categoryName = params["subCategoryName"] as? String {
      self.menuCategoryName = categoryName
    }
    if let item = params["meanuItems"] as? [[String: Any]] {
      for menuItem in item {
        self.menuItem.append(MenuItem(data: menuItem))
      }
    }
  }
}


struct MenuItem {
  var menuId: String?
  var isRecommended: Bool?
  var itemName: String?
  var isVeg: Bool?
  var restaurantId: String?
  var foodCategory: String?
  var foodSubCategoryId: String?
  var foodSubCategoryName: String?
  var foodEnabled: Bool?
  var description: String?
  var price: Double?
  var isEnabled: Bool?
  var menuImage: String?
  var branchId: String?
  var addOns = [AddOn]()
  
  init(data: [String: Any]) {
    if let id = data["_id"] as? String {
      self.menuId = id
    }
    if let recommended = data["IsRecommended"] as? Bool {
      self.isRecommended = recommended
    }
    if let name = data["itemName"] as? String {
      self.itemName = name
    }
    if let veg = data["IsVeg"] as? Bool {
      self.isVeg = veg
    }
    if let restaurantId = data["Restaurants"] as? String {
      self.restaurantId = restaurantId
    }
    if let foodCategoryId = data["FoodCategory"] as? String {
      self.foodCategory = foodCategoryId
    }
    if let foodSubCategory = data["FoodSubCategory"] as? [String: Any] {
      if let foodId = foodSubCategory["_id"] as? String {
        self.foodSubCategoryId = foodId
      }
      if let foodName = foodSubCategory["subCategoryName"] as? String {
        self.foodSubCategoryName = foodName
      }
      if let foodEnabled = foodSubCategory["IsEnabled"] as? Bool {
        self.foodEnabled = foodEnabled
      }
    }
    if let menuDescription = data["description"] as? String {
      self.description = menuDescription
    }
    if let price = data["price"] as? Double {
      self.price = price
    }
    if let menuIsEnabled = data["IsEnabled"] as? Bool {
      self.isEnabled = menuIsEnabled
    }
    if let image = data["imageURL"] as? [String: Any], let originalImage = image["original"] as? String {
      self.menuImage = originalImage
    }
    if let branchId = data["branchId"] as? String {
      self.branchId = branchId
    }
    if let addOn = data["addOns"] as? [[String: Any]] {
      self.addOns = addOn.map({ AddOn(params: $0)})
    }
    
  }
}

struct AddOn {
    
  var type: String?
  var addOnCategory: String?
  var addOnItem = [AddOnItems]()
  
  
  init(params: [String: Any]) {
   // _id
    if let addOnCat = params["addOnCategory"] as? String {
      self.addOnCategory = addOnCat
    }
    if let selectionType = params["type"] as? String {
      self.type = selectionType
    }
    if let addOnItems = params["addonitem"] as? [[String: Any]] {
      self.addOnItem = addOnItems.map({ AddOnItems(params: $0)})
    }
  }
  
}

struct AddOnItems {
    
    var id: String?
    var addOnItemName: String?
    var price: Double?
    
    
    init(params: [String: Any]) {
        // _id
        if let itemId = params["addOnId"] as? String {
            self.id = itemId
        }
        if let item = params["addOnName"] as? String {
            self.addOnItemName = item
        }
        if let itemPrice = params["price"] as? Double {
            self.price = itemPrice
        }
        
    }
    
}
