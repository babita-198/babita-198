//
//  ContactSupportPresenter.swift
//  FoodFox
//
//  Created by Anand Verma on 03/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import Foundation

enum ChatType: Int, CaseCountable {
  case order
  case delivery
  case payment
  case other
  
  var titleChat: String {
    switch self {
    case .order:
      return "Order Issue"
    case .delivery:
      return "Delivery Issue"
    case .payment:
      return "Payment Issue"
    case .other:
      return "Any other issue"
    }
  }
  var descriptionChat: String {
    switch self {
    case .order:
      return "Hi! Please share your ID"
    case .delivery:
      return "Hi! How may I assist you ?"
    case .payment:
      return "Hi! How may I assist you ?"
    case .other:
      return "Hi! How may I assist you ?"
    }
  }
  
  var chatImage: UIImage {
    switch self {
    case .order:
      return #imageLiteral(resourceName: "orderDone")
    case .delivery:
      return #imageLiteral(resourceName: "ic_delivery")
    case .payment:
      return #imageLiteral(resourceName: "paymentImage")
    case .other:
      return #imageLiteral(resourceName: "ic_Other")
    }
  }
}

class ContactSupportPresenter: NSObject {
  
  override init() {
    
  }
  
  
}
