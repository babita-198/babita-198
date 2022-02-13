//
//  CLAlertController+Extension.swift
//  CLApp
//
//  Created by cl-macmini-68 on 27/02/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

extension UIAlertController {
  
    
    func presentAdmin(on viewController: UIViewController?) {
        
        if let  controller = viewController {
            controller.present(self, animated: true, completion: nil)
            return
        }
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(self, animated: true, completion: nil)
        }
        
    }
    
  func present(viewController: UIViewController) {
      viewController.present(self, animated: true, completion: nil)
  }
  
  func present() {
    if let viewController = UIApplication.shared.keyWindow?.rootViewController {
//        appDelegate.topViewController()?.present(viewController, animated: false, completion: nil)
      self.present(viewController: viewController)
    }
  }
  
  @discardableResult
    func action(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
    let action: UIAlertAction = UIAlertAction(title: title, style: style, handler: handler)
    self.addAction(action)
    return self
  }
  
  @discardableResult
    class func alert(title: String?, message: String?, style: UIAlertController.Style) -> UIAlertController {
    let alertController: UIAlertController  = UIAlertController(title: title, message: message, preferredStyle: style)
    return alertController
  }
  
  @discardableResult
    class func presentAlert(title: String?, message: String?, style: UIAlertController.Style) -> UIAlertController {
    let alertController = UIAlertController.alert(title: title, message: message, style: style)
    alertController.present()
    return alertController
  }
  
}
