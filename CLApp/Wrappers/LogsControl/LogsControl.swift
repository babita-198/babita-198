//
//  LogsControl.swift
//  CLApp
//
//  Created by click Labs on 7/6/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//
//****************************  LogsControl Version-1.1 ****************************

import Foundation

import os.log
import UIKit

@available(iOS 10.0, *)
enum LogType {
  case debug
  case `default`
  case information
  case error
  case fault
  
  var osLogType: OSLogType {
    switch self {
    case .debug:
      return OSLogType.debug
    case .default:
      return OSLogType.default
    case .error:
      return OSLogType.error
    case .fault:
      return OSLogType.fault
    case .information:
      return OSLogType.info
    }
  }
  
}

// MARK: -
private func canShowLogs() -> Bool {
  switch appDelegate.environment {
  case .develop, .test:
    return true
  default:
    return false
  }
}

private func getCompleteMessage(message: String, file: String = #file, function: String = #function, line: Int = #line) -> String {
  let fileExtension = file.ns.lastPathComponent.ns.pathExtension
  let fileName = file.ns.lastPathComponent.ns.deletingPathExtension
  var informationPart: String = ""
  informationPart = "\(fileName).\(fileExtension) \(line) \(function)"
  let completeMessage: String =  "\(informationPart) :: \(message)"
  return completeMessage
  
}

@available(iOS 10.0, *)
func clLog(_ message: String, ofType type: LogType = .debug,
           forCategory category: LogCategory = .function,
           file: String = #file,
           function: String = #function,
           line: Int = #line) {
  
  if canShowLogs() == false {
    return
  }
  guard let bundleId = Bundle.main.bundleIdentifier else {
    return
  }
  
  let logger = OSLog(subsystem: bundleId, category: category.rawValue)
  let completeMessage = getCompleteMessage(message: message, file: file, function: function, line: line )
  fileManager(message: completeMessage, type: type, logger: logger)
  
}


func cllog(_ message: String,
           file: String = #file,
           function: String = #function,
           line: Int = #line) {
  let completeMessage: String = getCompleteMessage(message: message, file: file, function: function, line: line)
  sendLog(message: completeMessage)
}

@available(iOS 10.0, *)
private func fileManager(message: String, type: LogType, logger: OSLog) {
  sendLog(message: message, type: type, logger: logger)
}

@available(iOS 10.0, *)
private func sendLog(message: String, type: LogType, logger: OSLog) {
  switch logFunctionType {
  case .print:
    print(message)
  case .oslog:
    os_log("%@", log: logger, type: type.osLogType, message)
  case .nslog:
    NSLog("%@", message)
  }
}


/// <#Description#>
///
/// - Parameter message: <#message description#>
private func sendLog(message: String) {
  switch logFunctionType {
  case .print:
    print(message)
  case .nslog:
    NSLog("%@", message)
  default:
    fatalError("oslog available only for iOS 10 and above versions")
  }
}


// MARK: - <#Description#>
extension String {
  var ns: NSString {
    return self as NSString
  }
}
