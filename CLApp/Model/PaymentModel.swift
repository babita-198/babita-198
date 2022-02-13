//
//  PaymentModel.swift
//  FoodFox
//
//  Created by clicklabs on 28/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

typealias List = ((_ data: PaymentModel?, _ error: Error?) -> Void)

class PaymentModel {
  var paymentList: [String] = []
  var vat: Double?
  var tax: Double?
  var deliveryPrice: Double?
  var minOrder: Double?
  var walletAmount: Double?
    var cancellationCharges: Double?
    
  init(param: [String: Any]) {
   if let data = param["restaurantData"] as? [String: Any] {
      if let list = data["paymentMethods"] as? [String] {
        self.paymentList = list
      }
      if let vat = data["vat"] as? String {
        self.vat = Double(vat)
      }
      if let tax = data["tax"] as? Int {
        self.tax = Double(tax)
      }
      if let deliveryPrice = data["deliveryCharge"] as? Double {
        self.deliveryPrice = deliveryPrice
      }
      if let minOrder = data["minimumOrderValue"] as? Double {
        self.minOrder = minOrder
      }
    }
  
    if let customerData = param["customerData"] as? [String: Any] {
        if let amount = customerData["walletAmount"] as? Int {
            self.walletAmount = Double(amount)
        }
        if let amount = customerData["walletAmount"] as? Double {
            self.walletAmount = Double(amount)
        }
        if let cancellationCharges = customerData["cancellationCharges"] as? Double{
            self.cancellationCharges = Double(cancellationCharges)
        }
    }
  }
  
  static func getList(param: [String: Any], callBack: @escaping List) {
    var param: [String: Any] = param
    let language = Localize.currentLang()
    if language == .english {
      param["language"] = "en"
    } else {
      param["language"] = "en"
    }
    print(param)
    HTTPRequest(method: .get,
                path: API.paymentList,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
            let obj = PaymentModel(param: data)
              callBack(obj, nil)
              return
          }
        }
        callBack(nil, response.error)
        return
    }
    
  }
}
