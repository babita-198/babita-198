//
//  AppVersionData.swift
//  Food-Star
//
//  Created by komal on 31/07/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import Foundation

class AppVersion {
    
    var appVersion: String?
    var criticalAppVersion: String?
    var forceUpdate : Bool?
    
    init(with appVersionData: [String: Any]) {
        if let criticalVersion = appVersionData["criticalVersion"] as? String {
            self.criticalAppVersion = criticalVersion
        }
        if let appVersion = appVersionData["latestVersion"] as? String {
            self.appVersion = appVersion
        }
        if let forceUpdate = appVersionData["isforceUpdate"] as? Bool {
            self.forceUpdate = forceUpdate
        }

//        if let criticalVersion = appVersionData["criticalVersion"] as? Int {
//            self.criticalAppVersion = criticalVersion
//        }
//        if let appVersion = appVersionData["latestVersion"] as? Int {
//            self.appVersion = appVersion
//        }
    }
}

