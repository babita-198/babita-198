//
//  CLView+Extension.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation
import UIKit

//Extension UIWindow
public extension UIWindow {
  
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(viewController: self.rootViewController)
    }
  
   static func getVisibleViewControllerFrom(viewController: UIViewController?) -> UIViewController? {
    if let navViewController = viewController as? UINavigationController {
      return UIWindow.getVisibleViewControllerFrom(viewController: navViewController.visibleViewController)
    } else if let tabBarViewController = viewController as? UITabBarController {
      return UIWindow.getVisibleViewControllerFrom(viewController: tabBarViewController.selectedViewController)
    } else {
      if let presentViewController = viewController?.presentedViewController {
        return UIWindow.getVisibleViewControllerFrom(viewController: presentViewController)
      } else {
        return viewController
      }
    }
  }
  
}

extension UILabel {
  //  open override class func initialize() {
  //    // make sure this isn't a subclass
  //    print("*********>>>> UILabel")
  //    guard self === UILabel.self else {
  //      print("*********>>>> guard self === UILabel.self else")
  //      return
  //    }
  //  }
}

// MARK: -
extension UIView {
  
  class func loadNib(nibName: String!) -> UIView? {
    let loadedViews: [UIView]? = Bundle.main.loadNibNamed(nibName, owner: self, options: nil) as? [UIView]
    if loadedViews != nil {
      return loadedViews?.first
    } else {
      return nil
    }
  }
  
  func shadowPath(cornerRadius: CGFloat) {
    self.layer.cornerRadius = cornerRadius
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.white.cgColor
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowOpacity = 0.4
  }
  
  func shadowPathCustom(cornerRadius: CGFloat) {
    self.layer.cornerRadius = cornerRadius
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowOpacity = 0.4
  }
    func shadowPathCustomDark(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
    }
  
  func shadowPathRedCustom(cornerRadius: CGFloat, color: UIColor) {
    self.layer.cornerRadius = cornerRadius
    self.layer.masksToBounds = false
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowOpacity = 0.4
  }
  
  class func loadNib() -> UIView? {
    return UIView.loadNib(nibName: String(describing: UIView.self))
  }
  
  func border(width: CGFloat, color: UIColor, radius: CGFloat) {
    self.layer.borderWidth = width
    self.layer.borderColor = color.cgColor
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
  }
}

extension  UITextField {
  
  func placeHolderColor(color: UIColor!) {
    if let placeholder = self.placeholder {
        let attriStr =  NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color])
      self.attributedPlaceholder = attriStr
    }
  }
}

// MARK: - TableView
extension  UITableView {
  
  func indexPathForSubView(subview: UIView) -> IndexPath {
    if let superview = subview.superview {
      let location: CGPoint = superview.convert(subview.center, to: self)
      if let indexPath = self.indexPathForRow(at: location) {
        return indexPath
      }
    }
    
    fatalError("UITableView:- Not able find index path for row location")
    
  }
  
  func hideLastCellLine() {
    let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0.01))
    view.backgroundColor = UIColor.clear
    self.tableFooterView = view
  }
  
  func scrollEnableOnlyForExtraContent() {
    if self.contentSize.height > self.frame.size.height {
      self.isScrollEnabled = true
    } else {
      self.isScrollEnabled = false
    }
  }
  
  func registerCell(_ nibName: String, identifier: String = "", bundle: Bundle? = nil ) {
    var identifier = identifier
    if identifier.isEmpty {
      identifier = nibName
    }
    let nib: UINib = UINib(nibName: nibName, bundle: bundle)
    self.register(nib, forCellReuseIdentifier: identifier)
  }
  
  func registerHeaderFooter(_ nibName: String, identifier: String = "", bundle: Bundle? = nil ) {
    var identifier = identifier
    if identifier.isEmpty {
      identifier = nibName
    }
    let nib: UINib = UINib(nibName: nibName, bundle: bundle)
    self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
  }
  
}
extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContext(view.frame.size)
    if let context = UIGraphicsGetCurrentContext() {
      view.layer.render(in: context)
    }
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage!)!)
  }
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
extension UIView {
    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
//  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//    let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//    let mask = CAShapeLayer()
//    mask.path = path.cgPath
//    view.layer.mask = mask
//    
////    let maskLayer = CAShapeLayer()
////    maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
////    self.layer.mask = maskLayer
//   }
    
 
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOpacity = opacity
    self.layer.shadowOffset = offSet
    self.layer.shadowRadius = radius
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
