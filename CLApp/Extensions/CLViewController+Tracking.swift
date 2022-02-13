//
//  CLViewController+Tracking.swift
//  CLApp
//
//  Created by cl-macmini-68 on 20/03/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

import UIKit

//private let swizzling: (UIViewController.Type) -> (Void) = { viewController in
//  
//  let originalSelector = #selector(viewController.viewWillAppear(_:))
//  let swizzledSelector = #selector(viewController.proj_viewWillAppear(animated:))
//  
//  let originalMethod = class_getInstanceMethod(viewController, originalSelector)
//  let swizzledMethod = class_getInstanceMethod(viewController, swizzledSelector)
//  
//  method_exchangeImplementations(originalMethod, swizzledMethod)
//  
//}

extension UIViewController {
//  
//  open override class func initialize() {
//    // make sure this isn't a subclass
//    guard self === UIViewController.self else {
//      return
//    }
//    swizzling(self)
//  }
//  
//  // MARK: - Method Swizzling
//  func proj_viewWillAppear(animated: Bool) {
//    self.proj_viewWillAppear(animated: animated)
//    
//    let viewControllerName = String(describing: type(of: self))
//    print("******** Display Controller:- \(viewControllerName)")
//    
//    if let paren = self.parent {
//      let viewControllerName =  String(describing: type(of: paren))
//      print("******** Parent Controller:-  \(viewControllerName)")
//    }
//    
//  }
  
}
