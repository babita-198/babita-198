//
//  MenuViewModel.swift
//  CLApp
//
//  Created by cl-macmini-68 on 17/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

class MenuViewModel {
  
  var title: String?
  var image: UIImage?
  var isSelected: Bool?
  var controller: UIViewController?
  init() {
  }
  
  convenience init(title: String?, image: UIImage?, isSelected: Bool?, controller: UIViewController?) {
    self.init()
    self.title = title
    
    self.image = image
    self.isSelected = isSelected
    self.controller = controller
    if let navController = self.controller as? UINavigationController {
      if let viewController = navController.viewControllers.first {
        viewController.menuItem = self
      }
    } else {
      self.controller?.menuItem = self
    }
  }
  
}
