//
//  LogsConstant.swift
//  CLApp
//
//  Created by click Labs on 7/7/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

enum LogCategory: String {
  case appLifeCycle = "AppLifeCycle"
  case function = "Function"
  case nilCat = "Nil"
}

enum LogFunctionType {
  case nslog
  case print
  
  @available(iOS 10.0, *)
  case oslog // Avalabile in ios 10 and above
  
}

let logFunctionType: LogFunctionType = .nslog
