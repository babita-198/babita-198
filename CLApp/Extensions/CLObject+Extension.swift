//
//  CLObject+Extension.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation
import UIKit

typealias Meters = Double
extension Meters {
  var meters: Meters { return self }
  var km: Meters { return self * 1_000.0 }
  var cm: Meters { return self / 100.0 }
  var mm: Meters { return self / 1_000.0 }
  var ft: Meters { return self / 3.28084 }
}

extension Date {
  var age: Int? {
    if let year = Calendar.current.dateComponents([.year], from: self, to: Date()).year {
      return year
    }
    return nil
  }
  
  struct Formatter {
    static let iso8601: DateFormatter = {
      let formatter = DateFormatter()
      formatter.calendar = Calendar(identifier: .iso8601)
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
      return formatter
    }()
  }
  
  var iso8601: String {
    return Formatter.iso8601.string(from: self)
  }
  
}

public extension DispatchQueue {
  
  private static var _onceTracker = [String]()
  
  /**
   Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
   only execute the code once even in the presence of multithreaded calls.
   
   - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
   - parameter block: Block to execute once
   */
  class func once(token: String, block: () -> Void) {
    objc_sync_enter(self); defer { objc_sync_exit(self) }
    if _onceTracker.contains(token) {
      return
    }
    _onceTracker.append(token)
    block()
  }
  
  private class func delay(delay: TimeInterval, closure: @escaping () -> Void) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
  }
  
  class func performAction(after seconds: TimeInterval, callBack: @escaping ((Bool) -> Void) ) {
    DispatchQueue.delay(delay: seconds) {
      callBack(true)
    }
  }
  
}

public extension NSObject {
  
}

// MARK: -
extension UIImage {
  
  enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
  }
  
  /// Returns the data for the specified image in PNG format
  /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
  ///
  /// Returns a data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var pngData: Data? { return self.pngData() }
  
  /// Returns the data for the specified image in JPEG format.
  /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
  /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
  func jpegData(_ quality: JPEGQuality) -> Data? {
    return self.jpegData(compressionQuality: quality.rawValue)
  }
  
  func reduce(maxSize: Int = 250) -> Data? {
    
    let currentImage = self
    var compression: Float = 0.9
    let maxCompression: Float = 0.1
    let maxFileSize: Int = maxSize*1024
    
    if let data = currentImage.jpegData(compressionQuality: 0.99) {
      var imageData = data
      while (imageData.count > maxFileSize) && (compression > maxCompression) {
        compression -= 0.1
        if let newData = currentImage.jpegData(compressionQuality: CGFloat(compression)) {
          imageData = newData
        }
      }
      return imageData
    }
    
    return nil
    
  }
  
}
