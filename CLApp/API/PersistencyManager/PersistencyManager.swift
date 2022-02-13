//
//  PersistencyManager.swift
//  CLApp
//
//  Created by click Labs on 7/14/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

class PersistencyManager<Object> {

  func getObject(fileURL: URL) -> Object? {
    do {
      let fileData = try Data(contentsOf: fileURL)
      if let file = NSKeyedUnarchiver.unarchiveObject(with: fileData) as? Object {
        return file
      }
    } catch(_ ) {
      return nil
    }
    return nil
  }
  
  @discardableResult
  func save(url: URL, object: Object) -> Bool {
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object)
    do {
      try encodedData.write(to: url)
    } catch {
      return false
    }
    return true
  }
  
  @discardableResult
  func removeObject(url: URL) -> Bool {
    do {
      try FileManager.default.removeItem(at: url)
    } catch {
      return false
    }
    return true
  }
  
}
