//
//  ValidationRuleEmpty.swift
//  CLApp
//
//  Created by cl-macmini-68 on 23/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

public struct ValidationRuleBlank: ValidationRule {

    public typealias InputType = String
    public var error: Error

    /**
     Validates the input.
     
     - Parameters:
     - input: Input to validate.
     
     - Returns:
     true if the input character count is between the minimum and maximum.
     
     */
    public func validate(input: String?) -> Bool {
        guard let input = input else {
          return false }
        return !input.isBlank
    }

}
