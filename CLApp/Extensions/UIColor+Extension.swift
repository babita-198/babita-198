//
//  UIColor+Extension.swift
//  CLApp
//
//  Created by cl-macmini-68 on 09/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  convenience init(netHex: Int) {
    self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
  }
    
    class var themeColor: UIColor {
        return UIColor(red: 198, green: 0, blue: 60)
    }
  
  class func ratingColor(rating: Double) -> UIColor {
    if rating <= 3.5 {
    return UIColor(red: 255, green: 175, blue: 68)
    } else if rating <= 4 {
    return UIColor(red: 255, green: 114, blue: 40)
    } else {
    return UIColor(red: 104, green: 181, blue: 19)
    }
  }
    
    
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
