//
//  CLValidationRules.swift
//  CLApp
//
//  Created by cl-macmini-68 on 30/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

struct CLValidation {
  
  static func blankRulesSet(with message: String) {
    
  }
  
  // MARK: - Blank validation.
  static var blankRulesSet: ValidationRuleSet<String> {
    let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: "All field is mendatory".localizedString))
    var validateRuelsSet = ValidationRuleSet<String>()
    validateRuelsSet.add(rule: ruleRequired)
    return validateRuelsSet
  }
  
  // MARK: - Email validations.
  static var emailRulesSet: ValidationRuleSet<String> {
    
    //Email cannot blank
    let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: "Email is required".localizedString))
    //Email format validation
    let validateRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message: "Email is not valid".localizedString))
    
    //Set of rules
    var validateRuelsSet = ValidationRuleSet<String>()
    validateRuelsSet.add(rule: ruleRequired)
    validateRuelsSet.add(rule: validateRule)
    return validateRuelsSet
    
  }
  
  // MARK: - Phone number validations.
  static var phoneRulesSet: ValidationRuleSet<String> {
    
    //Email cannot blank
    let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: "Email/Phone is required".localizedString))
    //Email format validation
    let digitPattern = ContainsNumberValidationPattern()
    
    let validateRule = ValidationRulePattern(pattern: digitPattern, error: ValidationError(message: "Phone number is not valid".localizedString))
    let rule = ValidationRuleLength(min: 10, max: 12, error: ValidationError(message: "Enter Minimum 10 character".localizedString))
    //Set of rules
    var validateRuelsSet = ValidationRuleSet<String>()
    validateRuelsSet.add(rule: rule)
    validateRuelsSet.add(rule: ruleRequired)
    validateRuelsSet.add(rule: validateRule)
    return validateRuelsSet
    
  }
  
  
  // MARK: - Phone number validations.
  static var phoneRulesSetValue: ValidationRuleSet<String> {
    
    //Email cannot blank
    let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: "Phone Numner is required".localizedString))
    //Email format validation
    let digitPattern = ContainsNumberValidationPattern()
    let validateRule = ValidationRulePattern(pattern: digitPattern, error: ValidationError(message: "Phone number is not valid".localizedString))
     let rule = ValidationRuleLength(min: 10, max: 12, error: ValidationError(message: "Please enter valid phone number".localizedString))
    //Set of rules
    var validateRuelsSet = ValidationRuleSet<String>()
    validateRuelsSet.add(rule: rule)
    validateRuelsSet.add(rule: ruleRequired)
    validateRuelsSet.add(rule: validateRule)
    return validateRuelsSet
    
  }
    
    static var ruleNotBlank:(_ error: String) ->  ValidationRuleSet<String>  = { error in
        let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: error.localized))
        let ruleDecimal =  ValidationRuleDecimal(error: ValidationError(message: "ErrorValidExperience".localizedString))
        var validateRuelsSet = ValidationRuleSet<String>()
        validateRuelsSet.add(rule: ruleRequired)
        validateRuelsSet.add(rule: ruleDecimal)
        return validateRuelsSet
        
    }
  
  // MARK: - First Name Validations
  static var firstNameRuleSet: ValidationRuleSet<String> {
    var nameRules = ValidationRuleSet<String>()
    //Name cannot be blank
    let ruleRequired = ValidationRuleBlank(error: ValidationError(message: "First name is required".localizedString))
    //Name cannot contain digits //.*?[A-Za-z0-9]
    //let firstNameValidation = ValidationRulePattern(pattern: ".*?[A-Za-z0-9]", error: ValidationError(message: "Invalid first name".localizedString))
     nameRules.add(rule: ruleRequired)
    //nameRules.add(rule: firstNameValidation)
    
    return nameRules
  }
  
  // MARK: - LastName Validations
  static var lastNameRuleSet: ValidationRuleSet<String> {
    var nameRules = ValidationRuleSet<String>()
    //Name cannot be blank
    let ruleRequired = ValidationRuleBlank(error: ValidationError(message: "Last name is required".localizedString))
    //Name cannot contain digits
    //let lastNameValidation = ValidationRulePattern(pattern: ".*?[A-Za-z0-9]", error: ValidationError(message: "Invalid last name".localizedString))
    
    nameRules.add(rule: ruleRequired)
   // nameRules.add(rule: lastNameValidation)
    return nameRules
  }
    //MARK: - OTP Validation
    static var otpCodeSet:(_ error: String) ->  ValidationRuleSet<String>  = { error in
        let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: error.localized))
        var validateRuelsSet = ValidationRuleSet<String>()
        validateRuelsSet.add(rule: ruleRequired)
        
        let rule = ValidationRuleLength(min: 4, max: 4, error: ValidationError(message: "ErrorCorrectCode".localizedString))
        validateRuelsSet.add(rule: rule)
        return validateRuelsSet
    }
  
  // MARK: - Pasword validations.
  static var passwordRulesSet: ValidationRuleSet<String> {
    let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: "Email/Phone is required".localizedString))
    var passRules = ValidationRuleSet<String>()
    
    //Password length
    let digitPattern = ContainsNumberValidationPattern()
    let validateRule = ValidationRulePattern(pattern: digitPattern, error: ValidationError(message: "Password must be digits only".localizedString))
    let  passValidation = ValidationRuleLength(min: 6,
                                               max: 6,
                                            error: ValidationError(message: "Password must be six characters".localizedString))

    passRules.add(rule: passValidation)
    passRules.add(rule: ruleRequired)
    passRules.add(rule: validateRule)
    
    //Special character required.
    //        let specialSymbol = ValidationRulePattern(pattern: ".*[^A-Za-z0-9].*",
    //                                              error: ValidationError(message: "Password must contain at least one special character".localized))
    //        passRules.add(rule: specialSymbol)
    
    //A digit is required.
    //        let digitRule = ValidationRulePattern(pattern: ".*?[0-9]",
    //                                              error: ValidationError(message: "Password must contain at least one digit character".localized))
    //        passRules.add(rule: digitRule)
    
    //A UpperCase is required.
    //        let oneUpperCase  = ValidationRulePattern(pattern: ".*?[A-Z]",
    //                                              error: ValidationError(message: "Password must contain at least  one upper case character".localized))
    //        passRules.add(rule: oneUpperCase)
    
    //A lowerCase is required.
    //        let onelowerCase  = ValidationRulePattern(pattern: ".*?[a-z]",
    //                                                  error: ValidationError(message: "Password must contain at least  one upper case character".localized))
    //        passRules.add(rule: onelowerCase)
    return passRules
  }
    static var newPasswordRulesSet: ValidationRuleSet<String> {
        
        var passRules = ValidationRuleSet<String>()
        
        //Password length
        let digitPattern = ContainsNumberValidationPattern()
        let validateRule = ValidationRulePattern(pattern: digitPattern, error: ValidationError(message: "Password must be digits only".localizedString))
 
        let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: "ErrorNewPassword".localizedString))
        let  passValidation = ValidationRuleLength(min: 6,
                                                   max: 6,
                                                   error: ValidationError(message: "Password must be six characters".localizedString))
        
        passRules.add(rule: ruleRequired)
        passRules.add(rule: passValidation)
        passRules.add(rule: validateRule)
        //Pattern validation..
//        let validateRule = ValidationRulePattern(pattern: PasswordPattern, error: ValidationError(message: "ErrorValidNewPassword".localized))
//        passRules.add(rule: validateRule)
        
        return passRules
    }
  
}
