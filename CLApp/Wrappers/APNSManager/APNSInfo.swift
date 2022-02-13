//
//  APNSInfo.swift
//  APNSManager
//
//  Created by cl-macmini-68 on 26/04/17.
//  Copyright © 2017 Hardeep Singh. All rights reserved.
//

import Foundation

struct AlertBody: Alert {
  var alertText: String?
  var body: String?
  var title: String?
}

struct APNSInfo: APNSPayload {
  var alert: Alert?
  var sound: String?
  var badge: Int = 0
  var contentAvailable: Bool = false
  var bookingId: String?
  
  init(userInfo: [AnyHashable: Any]) {
    
    if let aps = userInfo["aps"] as? [String: Any] {
      sound = aps["sound"] as? String
      
      if let alert = aps["alert"] as? String {
        self.alert = AlertBody(alertText: alert, body: "", title: "")
      }
      
      sound = aps["sound"] as? String
      if let badge = aps["badge"] as? Int {
        self.badge = badge
      }

    }
    
    bookingId = userInfo["bookingId"] as? String
    
  }
  
}
