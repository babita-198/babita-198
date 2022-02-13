//
//  CountryManager.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit
// Country manager class for
class CountryManager {
  
  // MARK: - VARIABLES
  private(set) var countriesArray = [Country]()
  
  static var  shared: CountryManager = {
    //intancitaed wheneEver neened
    let countryManager = CountryManager()
    countryManager.loadCountries()
    return countryManager
  }()
  
  /// - Returns: some string
  open var lastCountrySelected: Country?
  
  func loadCountries() {
    //Add activity indicator here
    let methodStart = Date()
    let bundle = Bundle(for: type(of: self))
    if let countriesPath = bundle.path(forResource: "CLCountryPickerController.bundle/countries", ofType: "plist") {
      if let  array = (NSArray(contentsOfFile: countriesPath) as? [String]) {
        self.countriesArray.removeAll()
        for item in array {
          let country = Country(countryCode: item)
          self.countriesArray.append(country)
        }
        self.countriesArray = self.countriesArray.sorted(by: {
          $0.countryName() < $1.countryName()
        })
        /* ... FOR CHECK TIME ... */
        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        let notification = Notification(name: Notification.Name(rawValue: "notificationImagesUploadSuccessfully"))
        NotificationCenter.default.post(notification)
        print("Execution time: \(executionTime)")
        //Hide your activity indicator here
      } else {
        print("Add array of countries plist in your project")
        return
      }
    } else {
      print("Countries could not be loaded from plist, please check path")
    }
    
  }
  /**
   return all countries in plist.
   - returns: array of countries
   */
  func allCountries() -> [Country] {
    return countriesArray
  }
  /**
   Give the current country instance.
   - returns: A country instance.
   */
  
  // MARK: - Public functions
  class func country(withCountry code: String) -> Country {
    return Country(countryCode: code)
  }
  
  class var currentCountry: Country? {
    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
      let country = Country(countryCode: countryCode)
      return country
    }
    return nil
  }
  
  class func country(withDialling code: String) -> Country? {
    
    let diallingCode = code.replacingOccurrences(of: "+", with: "")
    
    var countryCode: String?
    for (key, value) in isoToDigitCountryCodeDictionary {
      if let valueStr = value as? String, valueStr == diallingCode {
        if let code = key as? String {
          countryCode = code// country code -- ex: US, IN, uk
          break
        }
      }
    }
    
    if let code = countryCode {
      return Country(countryCode: code)
    }
    return nil
  }
  
}
