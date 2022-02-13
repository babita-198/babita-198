//
//  CLViewController+Extension.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation
import UIKit

func associatedObject<ValueType: AnyObject>(
  base: AnyObject,
  key: UnsafePointer<UInt8>,
  initialiser: () -> ValueType)
  -> ValueType {
    if let associated = objc_getAssociatedObject(base, key)
      as? ValueType { return associated }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated,
                             .OBJC_ASSOCIATION_RETAIN)
    return associated
}

func associateObject<ValueType: AnyObject>(
  base: AnyObject,
  key: UnsafePointer<UInt8>,
  value: ValueType) {
  objc_setAssociatedObject(base, key, value,
                           .OBJC_ASSOCIATION_RETAIN)
}

private var menuItemKey: UInt8 = 0 // We still need this boilerplate

extension UIViewController {
  var menuItem: MenuViewModel {
    get {
      return associatedObject(base: self, key: &menuItemKey) { return MenuViewModel() } // Set the initial value of the var
    }
    set { associateObject(base: self, key: &menuItemKey, value: newValue) }
  }
}
