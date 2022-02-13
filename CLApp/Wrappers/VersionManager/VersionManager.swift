//
//  VersionManager.swift
//  CLApp
//  Created by cl-macmini-79 on 24/05/17.
//  Copyright © 2017 Click-labs. All rights reserved.
//
//*****************************  Version:- 1.0  *****************************
//

import Foundation
import UIKit

class VersionManager {
    
    private var newVersion: String
    private var forceUpdateVersion: String
    private var message: String = "New version available".localized
    private var showMessage: Bool = true
    private var appStoreUrl: String
    private var isForceUpdate: Bool?
    var callBack: ((_ result: Bool) -> Void)?
    
    init(newVersion: String, forceUpdateVersion: String, appStoreURL: String) {
        self.newVersion = newVersion
        self.forceUpdateVersion = forceUpdateVersion
        self.appStoreUrl = appStoreURL
    }
    
    func message(message: String) -> VersionManager {
        self.message = message
        return self
    }
    
    func config(showAlert: Bool) -> VersionManager {
        self.showMessage = showAlert
        return self
    }
    
    func appStoreURL(url: String) -> VersionManager {
        self.appStoreUrl = url
        return self
    }
    
    //  func newVersionAvailable(result: (Bool) -> Void) {
    //    if forceUpdateVersion > appDelegate.currentAppVersion {
    //      if showMessage {
    //        showAlertForForceUpdate()
    //      }
    //      result(true)
    //    } else {
    //      checkForLatestVersion()
    //    }
    //    result(false)
    //  }
    
    func newVersionAvailable(result: @escaping (Bool) -> Void) {
        callBack = result
        if forceUpdateVersion > appVersionValue ?? "1" {
            if showMessage {
                showAlertForForceUpdate()
            }
        } else if newVersion > appVersionValue ?? "1" {
            if showMessage {
                self.showAlert()
            }
        } else {
            self.callBack?(false)
        }
    }
    
    //  private func checkForLatestVersion() {
    //    if newVersion > appDelegate.currentAppVersion {
    //      if showMessage {
    //        self.showAlert()
    //      }
    //    }
    //  }
    
    private func showAlertForForceUpdate() {
        let alertController = UIAlertController(title: "Update".localized, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Update".localized, style: .default, handler: { (_) in
            self.gotoAppStore()
            self.callBack?(true)
        })
        alertController.addAction(defaultAction)
        appDelegate.topViewController()?.present(alertController, animated: true, completion: {
        })
    }
    
    private func showAlert() {
        DispatchQueue.main.async(execute: { () -> Void in
            let alertController = UIAlertController(title: "Update".localized, message: self.message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Later".localized, style: .default, handler: { (_) in
                self.callBack?(false)
                       //self.isForceUpdate = false
            })
            alertController.addAction(defaultAction)
            let updateAction = UIAlertAction(title: "Update", style: .default, handler: { (_) in
                self.gotoAppStore()
                self.callBack?(true)
                       // self.isForceUpdate = true
            })
            alertController.addAction(updateAction)
            appDelegate.topViewController()?.present(alertController, animated: true, completion: {
            })
        })
    }
    
    private func gotoAppStore() {
        guard let url  = URL(string: appStoreUrl) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.openURL(url)
        }
    }
    
}
//
// HOW USE VersionManager
// Example:-
class CheckCode {
    
    
    class func checkVersion(appVersion: String, appCriticalVersion: String, completion: @escaping (Bool) -> Void) {
        //let version = VersionManager(newVersion: appVersion, forceUpdateVersion: appCriticalVersion, appStoreURL: "https://itunes.apple.com/us/app/foodstar-delivery-pickup/id1357536246")
        let version = VersionManager(newVersion: appVersion, forceUpdateVersion: appCriticalVersion, appStoreURL: "https://apps.apple.com/us/app/id1509260018")
        let isForceUpdate = appCriticalVersion > appVersionValue ?? ""
       // let isForceUpdate = appCriticalVersion > Int(appVersionValue) ?? 1
        version.message(message: isForceUpdate ? "There is a new Update available, Please update your app to continue": "To proceed further, Please open App's Settings and set Location access to 'Always'.").config(showAlert: true).newVersionAvailable { force in
            completion(force)
        }
    }
}
