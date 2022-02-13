//
//  Personable.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/3/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

enum UserRole: String {
  case customer
  case driver
  case serviceProfider
}

enum Gender: String {
  case male = "Male"
  case female = "Female"
  func dispalyValue() -> (String) {
    switch self {
    case .male:
      return "Male"
    case .female:
      return "Female"
    }
  }
}

protocol LoginProtocol {
  var accessToken: String? {get set}
}

protocol Personable {
  var id: String? {get set}
  var firstName: String? {get set}
  var lastName: String? {get set}
  var middleName: String? {get set}
  var mobile: String? {get set}
  var diallingCode: String? {get set}
  var email: String? {get set}
  var dob: Date? {get set}
  var fullName: String? {get}
  var gender: Gender? {get set}
  var role: UserRole? {get set}
}
