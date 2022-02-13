//
//  CartModel.swift
//  FoodFox
//
//  Created by clicklabs on 04/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

typealias CreateTaskCallBack = ((_ response: [String: Any]?, _ error: Error?) -> Void)

class CartModel {
  
  static func createTaskAction(parameters: [String: Any], callBack: @escaping CreateTaskCallBack) {
    HTTPRequest(method: .post,
                path: API.createTask,
                parameters: parameters,
                encoding: .json,
                files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) {(response: HTTPResponse) in
        
        if response.error != nil {
          callBack(nil, response.error)
            print(response.error)
            return
        }
        guard let value = response.value as? [String: Any] else {
          return
        }
        guard let data = value["data"] as? [String: Any] else {
          return
        }
        if let amount = data["walletAmount"] as? Double {
          LoginManagerApi.share.me?.walletAmount = amount
        }
        callBack(data, nil)
        return
    }
  }

}
