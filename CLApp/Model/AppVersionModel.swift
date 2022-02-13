//
//  AppVersionModel.swift
//  FoodFox
//
//  Created by komal on 23/04/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import Foundation

class AppVersionModel: SerializableArray {
    
    var latestAppVersion: Int
    var criticalVersion: Int
    var forceUpdate: Bool?
    var appType: String
    
    required init?(with param: [String: Any]) {
        guard let latestAppVersion = param["latestVersion"] as? Int else {
            return nil
        }
        self.latestAppVersion = latestAppVersion
        guard let criticalVersion = param["criticalVersion"] as? Int else {
            return nil
        }
        self.criticalVersion = criticalVersion
        if let forceUpdate = param["forceUpdate"] as? Int {
            if forceUpdate == 0 {
                self.forceUpdate = false
            } else {
                self.forceUpdate = true
            }
        }
        guard let appType = param["appType"] as? String else {
            return nil
        }
        self.appType = appType
    }
}
