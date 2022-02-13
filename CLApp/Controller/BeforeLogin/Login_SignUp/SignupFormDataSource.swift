//
//  SignupFormDataSource.swift
//  CLApp
//
//  Created by cl-macmini-68 on 20/04/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

class SignupFormDataSource: NSObject {
  
  private weak var manager: CLValidatorManager?
  private weak var controller: UIViewController?

  var validatorManager: CLValidatorManager {
    if let manager = self.manager {
      return manager
    }
    fatalError("Validator Manager is nil")
  }
  
  //
  init(manager: CLValidatorManager) {
    self.manager = manager
  }

  
  // MARK: - Load Cell for indexPath
  func loadCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FieldCell {
    guard let fieldCell: FieldCell = tableView.dequeueReusableCell(withIdentifier: "FieldCell") as? FieldCell else {
      fatalError("Couldn't load FieldCell")
    }
    return fieldCell
  }
  
  func cellForStartValidation(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
    }
    cell.textLabel?.text = R.string.localizable.signUp()
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.textColor = .blue
    return cell
  }
  
  // Tracking all status of email ResultHolder
  func trackEmailField(_ fieldCell: FieldCell, cellForRowAt indexPath: IndexPath) {
    
    // MARK: 7 - Set idientifier for field
    var email1Holder: ResultHolder! = self.validatorManager.reusableHolder(withIdientifier: "email")
    if email1Holder == nil {
      // MARK: 7.1 - Create holder object if nil.
      email1Holder = ResultHolder(idientifier: "email", behavior: .email,
                                  validationRuleSet: CLValidation.emailRulesSet,
                                  value: "email@gmail.com",
                                  validatorManager: self.validatorManager)
      // MARK: 7.2 - Register call back (valueDidChanged) for holder
      email1Holder.valueDidChanged = {(holder: ResultHolder) in
        
        // MARK: 7.2.1 - field is fielld
        if holder.isFielld {
          fieldCell.textField.backgroundColor = UIColor.gray
          // MARK: 7.2.2 - value is valid
          if holder.isValid {
            fieldCell.textField.backgroundColor = UIColor.green
          }
        } else {
          fieldCell.textField.backgroundColor = UIColor.red
        }
      }
    }
    
    // MARK: 7.3 - Give holder to the text field.
    fieldCell.textField.set(reusltHolder: email1Holder)
    fieldCell.textField.placeholder = R.string.localizable.email()
    
  }
  
  // Confirm Password
  func trackConfirmEmailField(_ fieldCell: FieldCell, cellForRowAt indexPath: IndexPath) {
    var confirmEmailHolder: ResultHolder! = self.validatorManager.reusableHolder(withIdientifier: "confirmPassword")
    if confirmEmailHolder == nil {
      confirmEmailHolder = ResultHolder(idientifier: "confirmPassword", behavior: .email, validationRuleSet: CLValidation.passwordRulesSet, validatorManager: self.validatorManager)
    }
    fieldCell.textField.set(reusltHolder: confirmEmailHolder)
    fieldCell.textField.placeholder = R.string.localizable.password()
  }
  
  // Username holder..
  func trackUserName(_ fieldCell: FieldCell, cellForRowAt indexPath: IndexPath) {
    var usernameHolder: ResultHolder! = self.validatorManager.reusableHolder(withIdientifier: "userName")
    if usernameHolder == nil {
      usernameHolder = ResultHolder(idientifier: "userName",
                                    behavior: .username,
                                    validationRuleSet: CLValidation.firstNameRuleSet,
                                    validatorManager: self.validatorManager)
    }
    
    fieldCell.textField.set(reusltHolder: usernameHolder)
    fieldCell.textField.placeholder = R.string.localizable.username()
  }
  
  // First name
  func trackFirstName(_ fieldCell: FieldCell, cellForRowAt indexPath: IndexPath) {
    var firstNameHolder: ResultHolder! = self.validatorManager.reusableHolder(withIdientifier: "name")
    if firstNameHolder == nil {
      firstNameHolder = ResultHolder(idientifier: "name",
                                     behavior: .name,
                                     validationRuleSet: CLValidation.firstNameRuleSet,
                                     validatorManager: self.validatorManager)
    }
    
    fieldCell.textField.set(reusltHolder: firstNameHolder)
    fieldCell.textField.placeholder = R.string.localizable.firstName()
    fieldCell.textField.isValidationOnShouldChangeCharacters = true
  }
  
  // Last name
  func trackLastName(_ fieldCell: FieldCell, cellForRowAt indexPath: IndexPath) {
    var lastNameHolder: ResultHolder! = self.validatorManager.reusableHolder(withIdientifier: "lastName")
    if lastNameHolder == nil {
      lastNameHolder = ResultHolder(idientifier: "lastName",
                                    behavior: .name,
                                    validationRuleSet: CLValidation.lastNameRuleSet,
                                    validatorManager: self.validatorManager)
    }
    fieldCell.textField.set(reusltHolder: lastNameHolder)
    fieldCell.textField.placeholder = R.string.localizable.lastName()
  }
  
  // Password
  func trackPassword(_ fieldCell: FieldCell, cellForRowAt indexPath: IndexPath) {
    var passwordHolder: ResultHolder! = self.validatorManager.reusableHolder(withIdientifier: "password")
    if passwordHolder == nil {
      passwordHolder = ResultHolder(idientifier: "password",
                                    behavior: .password,
                                    validationRuleSet: CLValidation.passwordRulesSet,
                                    validatorManager: self.validatorManager)
    }
    fieldCell.textField.set(reusltHolder: passwordHolder)
    fieldCell.textField.placeholder = R.string.localizable.password()
  }
  
  
  // Phone number holder..
  func trackPhoneNumber(_ fieldCell: FieldCell, cellForRowAt indexPath: IndexPath) {
    var emailHolder: ResultHolder! = self.validatorManager.reusableHolder(withIdientifier: "mobile")
    if emailHolder == nil {
      emailHolder = ResultHolder(idientifier: "mobile",
                                 behavior: .phoneNumber,
                                 validationRuleSet: CLValidation.phoneRulesSet,
                                 isOptional: true,
                                 validatorManager: self.validatorManager)
    }
    fieldCell.textField.set(reusltHolder: emailHolder)
    fieldCell.textField.placeholder = R.string.localizable.phoneNumber()
    
    fieldCell.textField.shouldChangeCharacterCondition(custom: { (field: CLTextField, range: NSRange, new: String) -> Bool in
      return true
    })
  }

}


extension SignupFormDataSource: UITableViewDataSource {
  
  // MARK: -
  func numberOfSections(in tableView: UITableView) -> Int {
    return SignupSectionType.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let sectionType: SignupSectionType = SignupSectionType(rawValue: indexPath.section) else {
      fatalError("Section not avaliable for index path \(indexPath.section) - \(indexPath.row)")
    }
    
    if sectionType == .submitButton {
      return self.cellForStartValidation(tableView, cellForRowAt: indexPath)
    }
    
    let fieldCell: FieldCell  = self.loadCell(tableView, cellForRowAt: indexPath)
    
    switch sectionType {
    case .email:
      self.trackEmailField(fieldCell, cellForRowAt: indexPath)
      
      
    case .confirmPassword:
      self.trackConfirmEmailField(fieldCell, cellForRowAt: indexPath)
      
      
    case .username:
      self.trackUserName(fieldCell, cellForRowAt: indexPath)
     
      
    case .firstName:
      self.trackFirstName(fieldCell, cellForRowAt: indexPath)
      
    case .lastName:
      self.trackLastName(fieldCell, cellForRowAt: indexPath)
      
      
    case .password:
      self.trackPassword(fieldCell, cellForRowAt: indexPath)
      
      
    case .phoneNumber:
      self.trackPhoneNumber(fieldCell, cellForRowAt: indexPath)
      
      
    default:
      break
    }
    return fieldCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44.0
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.selectionStyle = .none
  }

}
