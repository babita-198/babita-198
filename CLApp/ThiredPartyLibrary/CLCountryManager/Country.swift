//
//  Country.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit

/// Country Object is responsible for displaying country Object
///
/// - countryName():  return  the currenty name depend on phone local.
/// - countryName(with locale: NSLocale): return country name depend on argument local
/// - countryName(withLocaleIdentifier localeIdentifier: String): return countryName with argument Local Identifier

class Country {
  
  // MARK: - Variable
  open var countryCode = String()
  open var dictionaryFromCountryCodeToCountryName =  [String: String]()
  var imagePath: String {
    return "CLCountryPickerController.bundle/\(self.countryCode)"
  }
  
  private var image: UIImage?
  /// flag for country given
  var flag: UIImage? {
    if image != nil {
      return image
    }
    let flagImg = UIImage(named: imagePath, in: nil, compatibleWith: nil)
    image  = flagImg
    return image
  }
  
  // MARK: - Functions
  init(countryCode code: String) {
    self.countryCode = code
  }
  
  func countryName() -> String {
    if let countryNamePreviouslyExist = dictionaryFromCountryCodeToCountryName[countryCode] {
      return countryNamePreviouslyExist
    } else {
      let calculateCountryName = self.countryName(withLocaleIdentifier: NSLocale.preferredLanguages[0])
      dictionaryFromCountryCodeToCountryName[countryCode] = calculateCountryName
      return calculateCountryName
    }
  }
  
  func countryName(withLocaleIdentifier localeIdentifier: String) -> String {
    let locale = NSLocale(localeIdentifier: localeIdentifier)
    return self.countryName(with: locale)
  }
  
  func countryName(with locale: NSLocale) -> String {
    if let localisedCountryName = locale.displayName(forKey: NSLocale.Key.countryCode, value: self.countryCode) {
      return localisedCountryName
    }
    return ""
  }
  
  ///Return dialing code for country instance
  func dialingCode() -> String? {
    
    if let digitCountryCode = isoToDigitCountryCodeDictionary[countryCode] as? String {
      return "+" + digitCountryCode
    }
    print("Please check your Constant file it not contain key for \(countryCode)")
    return nil
  }
}
