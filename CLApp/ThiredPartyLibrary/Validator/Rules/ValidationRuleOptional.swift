//
//  ValidationRuleOptional.swift
//  CLApp
//
//  Created by cl-macmini-68 on 06/01/17.
//  Copyright © 2017 Hardeep Singh. All rights reserved.
//

import Foundation

public struct ValidationRuleOptional: ValidationRule {

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
        return true
    }

}
