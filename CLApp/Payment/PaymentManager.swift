//
//  PaymentManager.swift
//  al-manarah
//
//  Created by clickpass on 15/9/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class PaymentManager: NSObject {
    static func getPayementMethod(flowType: String, callBack: @escaping ((_ response: [PaymentPayModel]?, _ error: Error?) -> Void)) {
        /// Api.getPaymentMethods
        HTTPRequest(method: .get, path: "",
                    parameters: nil,
                    encoding: .url,
                    files: nil)
            .config(isIndicatorEnable: true, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                
                if response.error != nil {
                    callBack(nil, response.error)
                    return
                }
                if let jsonData = response.value as? [[String: Any]] {
                    var arrayOfObject = [PaymentPayModel]()
                    for each in jsonData {
                        let object = PaymentPayModel(jsonData: each)
                        if object.paymentType == "cash_on_delivery" || (flowType == "app_wallete") {
                            continue
                        } else {
                           arrayOfObject.append(object)
                        }
                    }
                    callBack(arrayOfObject, nil)
                } else {
                    callBack(nil, nil)
                }
        }
    }

    static func getTransactionCheckOut(amount: String,restaurantId: String, branchId:String, callBack: @escaping ((_ response: TransactionModel?, _ error: Error?) -> Void)) {
        let queryString = "com.qawafeltech.FoodStar.payments://test"
        let parameters: [String: Any] = ["amount": amount, "shopperResultUrl": queryString,"restaurantId": restaurantId
    ,"branchId":  branchId]
        HTTPRequest(method: .post, path: "api/customer/paymentCheckout",
                    parameters: parameters,
                    encoding: .url,
                    files: nil)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                if response.error != nil {
                    callBack(nil, response.error)
                    return
                }
                if let jsonData = response.value as? [String: Any] {
                    let object = TransactionModel(jsonData: jsonData)
                    callBack(object, nil)
                    return
                } else {
                    callBack(nil, nil)
                    return
                }
        }
    }
    
    static func postTransaction(paramerer: [String: Any], callBack: @escaping ((_ response: OrderModel?, _ error: Error?) -> Void)) {
        _ = "Api.getTransactionCheckOutApi"
        HTTPRequest(method: .post, path: "setAPI",
                    parameters: paramerer,
                    encoding: .url,
                    files: nil)
            .config(isIndicatorEnable: true, isAlertEnable: true)
            .cache(enable: false)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                if response.error != nil {
                    callBack(nil, response.error)
                    return
                }
                if let data = response.value as? [String: Any] {
                    print(data)
                  //  let object = OrderModel(array: data)
                    callBack(OrderModel(), nil)
                    return
                }
                //callBack(nil, nil)
        }
        
    }
}
