//
//  CLString+Extension.swift
//  CLApp
//
//  Created by cl-macmini-68 on 09/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

// MARK: -
extension String {
  var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
}


//#if swift(>=3.1)
//  extension Optional where Wrapped == String {
//    var isBlank: Bool {
//      return self?.isBlank ?? true
//    }
//  }
//#endif


// MARK: -
// Basic functions
extension String {
  
  // Return ISO fromated date.
  var dateFromISO8601: Date? {
    return Date.Formatter.iso8601.date(from: self)
  }
  
  var daySuffix: String {
    
    if self == "11" || self == "12" || self == "13" {
      return "th"
    }
    let lastChar: Character =  self[self.index(before: self.endIndex)]
    switch lastChar {
    case "1":
      return self.appending("st")
    case "2":
      return self.appending("nd")
    case "3":
      return self.appending("rd")
    default:
      return self.appending("th")
    }
  }
    
    func hasSpace() -> Bool {
        
        let whitespace = NSCharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        // range will be nil if no whitespace is found
        if range != nil {
            
            return true
        } else {
            
            return false
        }
    }

  
  // Character count
    var length: Int {
    return self.count
  }
  
  // Count of word
  public var countOfWords: Int {
    let regex = try? NSRegularExpression(pattern: "\\w+", options: NSRegularExpression.Options())
    return regex?.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.length)) ?? 0
  }
  
  // Checks if string is empty or consists only of whitespace and newline characters
  public var isBlank: Bool {
    let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty
  }
  
  // Trims white space and new line characters, returns a new string
  public func trimmed() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  // Trims white space and new line characters
  public mutating func trim() {
    self = self.trimmed()
  }
  
  // Capitalizes first character of String, returns a new string
  public func capitalizedFirst() -> String {
    guard self.count > 0 else {
      return self
    }
    var result = self
    result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    return result
  }
  
  /// Returns if String is a number
  public func isNumber() -> Bool {
    if NumberFormatter().number(from: self) != nil {
      return true
    }
    return false
  }
  
  //URL encode a string (percent encoding special chars)
  public func urlEncoded() -> String {
    
    if let encodingString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
      return encodingString
    }
    fatalError("Failed to encode string")
  }
  
  //URL encode a string (percent encoding special chars) mutating version
  mutating func urlEncode() {
    self = urlEncoded()
  }
  
  // MARK: -
  //Returns hight of rendered string
  func height(_ width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?) -> CGFloat {
    var attrib: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
    
    if let lineBreakMode = lineBreakMode {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineBreakMode = lineBreakMode
        attrib.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
    }
    
    let size = CGSize(width: width, height: CGFloat())
    return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrib, context: nil).height)
  }
  
}
