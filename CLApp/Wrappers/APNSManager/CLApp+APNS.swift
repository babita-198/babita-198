////
////  CLAppDelegate+APNS.swift
////  CLApp
////
////  Created by cl-macmini-68 on 09/12/16.
////  Copyright © 2016 Hardeep Singh. All rights reserved.
////
//
import Foundation
import UIKit
//import SDKDemo1
//import MZFayeClient
//import Hippo

extension AppDelegate {
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    APNSManager.share.failedToRegisterForNotifications(error: error)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    APNSManager.share.successfullyRegisteredForNotifications(data: deviceToken)
   // HippoConfig.shared.registerDeviceToken(deviceToken: deviceToken)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    APNSManager.share.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }
  
  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
  }
  
}
