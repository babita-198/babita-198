//
//  CLCollection+Extension.swift
//  CLApp
//
//  Created by Cl-macmini-100 on 12/16/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

// MARK: - Collection
extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Iterator.Element? {
    return index >= startIndex && index < endIndex ? self[index] : nil
  }
}

extension Dictionary {
  
  //Append Dictionary
  mutating func appendDictionary(other: Dictionary) {
    for (key, value) in other {
      self.updateValue(value, forKey: key)
    }
  }
  
  static func += <K, V> ( left: inout [K: V], right: [K: V]) {
    for (kVar, vVar) in right {
      left.updateValue(vVar, forKey: kVar)
    }
  }
}
