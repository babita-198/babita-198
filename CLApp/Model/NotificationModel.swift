//
//  NotificationModel.swift
//  FoodFox
//
//  Created by anand kumar on 05/02/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import Foundation

typealias NotificationCall = ((_ data: NotificationModel?, _ error: Error?) -> Void)
typealias UpdateNotification = ((_ data: [String: Any]?, _ error: Error?) -> Void)

class NotificationModel {
    var walletAmount: Double?
    var isNotification: Bool?
    
    init(data: [String: Any]) {
        if let amount = data["walletAmount"] as? Int {
            self.walletAmount = Double(amount)
        }
        if let amount = data["walletAmount"] as? Double {
            self.walletAmount = Double(amount)
        }
        
        if let isNotification = data["isNotificationOn"] as? Bool {
            self.isNotification = isNotification
        }
    }
    
    
    ///api/customer/updateSetting
    //MARK: Update Notification Setting
    static func updateNotificationSetting(isNotification: Bool, callBack: @escaping UpdateNotification) {
        var param: [String: Any] = [:]
        param["isNotificationOn"] = isNotification
        let language = Localize.currentLang()
        if language == .english {
            param["language"] = "en"
        } else {
            param["language"] = "en"
        }
        HTTPRequest(method: .put,
                    path: API.updateNotification,
                    parameters: param,
                    encoding: .json,
                    files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                if response.error == nil {
                    if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
                        callBack(data, nil)
                        return
                    }
                }
                callBack(nil, response.error)
                return
        }
    }
    
    
    static func updateNotificationSettingLanguage(callBack: @escaping UpdateNotification) {
        var param: [String: Any] = [:]
        let language = Localize.currentLang()
        if language == .english {
            param["language"] = "en"
        } else {
            param["language"] = "en"
        }
        HTTPRequest(method: .put,
                    path: API.updateNotification,
                    parameters: param,
                    encoding: .json,
                    files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                if response.error == nil {
                    if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
                        callBack(data, nil)
                        return
                    }
                }
                callBack(nil, response.error)
                return
        }
    }
    
    //MARK: Get Setting Data
    static func getSettingData( callBack: @escaping NotificationCall) {
        HTTPRequest(method: .get,
                    path: API.getSettingData,
                    parameters: nil,
                    encoding: .json,
                    files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                if response.error == nil {
                    if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
                        let obj = NotificationModel(data: data)
                            callBack(obj, nil)
                            return
                    }
                }
                callBack(nil, response.error)
                return
        }
    }
    
    
}
