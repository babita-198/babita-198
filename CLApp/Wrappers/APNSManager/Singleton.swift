//
//  Singleton.swift
//  FoodFox
//
//  Created by Nishant Raj on 14/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

class Singleton: NSObject, CAAnimationDelegate {
    static let sharedInstance = Singleton()
    //MARK: FUNCTION TO SHOW PUSH NOTOFICATION VIEW
    func showPushNotificationView(message: String, onclickAction:@escaping () -> Void) {
        if PushNotificationView.notiFicationView != nil {
            if PushNotificationView.notiFicationView?.superview != nil {
                PushNotificationView.notiFicationView?.removeFromSuperview()
            }
        }
        PushNotificationView.notiFicationView = PushNotificationView.showPush(message: message, actionOnClick: onclickAction)
       if let pushView = PushNotificationView.notiFicationView {
         UIApplication.shared.keyWindow?.addSubview(pushView)
        }
        UIView.animate(withDuration: 0.5, animations: {
            PushNotificationView.notiFicationView?.alpha = 1
          guard let textFont = UIFont(name: customFontRegular, size: 13) else {
           return
          }
          guard let boldFont = UIFont(name: fontStyleSemiBold, size: 13) else {
            return
          }
            let size = message.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font: textFont)
            let titleSize = "FOOD STAR".heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font: boldFont)
            if let screenWidth = UIApplication.shared.keyWindow?.frame.width {
            PushNotificationView.notiFicationView?.frame =  CGRect(x: 25, y: 10, width: screenWidth - 40, height: size.height + titleSize.height + 60)
            }
            if PushNotificationView.notiFicationView?.superview != nil {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
                   PushNotificationView.notiFicationView?.hideNotification()
                })
            }
        })
    }
}
