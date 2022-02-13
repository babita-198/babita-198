//
//  CLValidationRules.swift
//  CLApp
//
//  Created by cl-macmini-68 on 30/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import XCTest
@testable import CLApp

class CLValidationRules: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmailValidation() {

        //Rule: 1
        let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: "Email is required"))

//        //Rule: 2
        let validateRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message: "Email is not valid"))
//
//        //Rules set
        var validateRuelsSet = ValidationRuleSet<String>()
        validateRuelsSet.add(rule: ruleRequired)
        validateRuelsSet.add(rule: validateRule)

       let result: ValidationResult =   "sfdsf@gmail.com".validate(rule: validateRule)
        XCTAssertTrue(result.isValid)

    }

    func testPasswordValidation() {
       //Special character required.
       let digitRule = ValidationRulePattern(pattern: ".*[^A-Za-z0-9].*",
                                          error: ValidationError(message: "A special symbol is requuired".localized))
    }

}
