//
//  ValidationRuleDecimal.swift
//  Kitch
//
//  Created by soc-macmini-30 on 23/06/17.
//  Copyright © 2017 Click-labs. All rights reserved.
//

import Foundation
public struct ValidationRuleDecimal: ValidationRule {
    
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
        if input == "." {
            return false
        } else {
            return true
        }
    }
    
}
