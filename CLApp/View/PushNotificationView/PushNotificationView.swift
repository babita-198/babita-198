//
//  PushNotificationView.swift
//  TookanVendor
//
//  Created by cl-macmini-57 on 23/12/16.
//  Copyright © 2016 clicklabs. All rights reserved.
//

import UIKit

class PushNotificationView: UIView {
  
  //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationMessage: UILabel!
    @IBOutlet var appIcon: UIImageView!
    @IBOutlet var line: UILabel!
  
  //MARK: Variables
    var action:(() -> Void)?
    static var notiFicationView: PushNotificationView?
  
  //MARK: AwakeFromNib
    override func awakeFromNib() {
        notificationMessage.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        titleLabel.textColor = darkPinkColor
         notificationMessage.font = UIFont(name: fontNameRegular, size: 13)
        titleLabel.font = UIFont(name: fontStyleSemiBold, size: 14)
        titleLabel.text = "FOOD STAR"
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 0.5
        self.appIcon.layer.cornerRadius = 4.0
        self.appIcon.layer.masksToBounds = true
        self.line.backgroundColor = UIColor.white
    }
  
    //MARK: STATIC FUNCTION TO SHOW THE NOTIFICATION POPUP
    static func showPush(message: String, actionOnClick: @escaping() -> Void) -> PushNotificationView {
        let viewToBeloaded = Bundle.main.loadNibNamed(Identifier.pushView, owner: self, options: nil)?[0] as? PushNotificationView
        guard let fontRegular = UIFont(name: fontNameRegular, size: 14) else {
          fatalError()
         }
      guard let fontSemibold = UIFont(name: fontStyleSemiBold, size: 14) else {
        fatalError()
      }
        let size = message.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font: fontRegular)
        let titleSize = "FOOD STAR".heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font: fontSemibold)
        viewToBeloaded?.alpha = 0
      if let viewWidth = (UIApplication.shared.keyWindow?.frame.width) {
        viewToBeloaded?.frame = CGRect(x: 20, y: -(size.height + titleSize.height + 40), width: viewWidth - 20, height: size.height + titleSize.height + 40)
      }
        viewToBeloaded?.notificationMessage.text = message
        viewToBeloaded?.action = actionOnClick
      guard let view = viewToBeloaded else {
       fatalError()
       }
        return view
    }

    // FUNCTION TO HIDE THE POPUP
    func hideNotification() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            if let viewWidth = (UIApplication.shared.keyWindow?.frame.width) {
            self.frame = CGRect(x: 20, y: -60, width: (viewWidth) - 40, height: self.frame.height)
            }
            }) {(true) in
              self.removeFromSuperview()
        }
    }
  
  //MARK: Tab on Notification View
    @IBAction func tapAction(_ sender: AnyObject) {
        if let actionCall = action {
            actionCall()
        }
        hideNotification()
    }
  
  //MARK: Tab on Cancel Notification
    @IBAction func cancelNotificationButton(_ sender: UIButton) {
        hideNotification()
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox
    }
}
