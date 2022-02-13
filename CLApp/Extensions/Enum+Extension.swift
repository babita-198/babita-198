//
//  Enum+Extension.swift
//  CLApp
//
//  Created by cl-macmini-68 on 08/03/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

/*
 For counting the number of cases on enum
 */
protocol CaseCountable { }

extension CaseCountable where Self: RawRepresentable, Self.RawValue == Int {
  
  static var count: Int {
    var count = 0
    while Self(rawValue: count) != nil { count+=1 }
    return count
  }
  
  static var allValues: [Self] {
    return (0..<count).compactMap({ Self(rawValue: $0) })
  }
      
}
