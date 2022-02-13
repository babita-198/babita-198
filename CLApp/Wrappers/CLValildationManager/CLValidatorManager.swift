//
//  CLValidatorManager.swift
//  CLApp
//
//  Created by cl-macmini-68 on 30/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation

class CLValidatorManager {
  
  /// Result holder for queue.
  private var listOfResult: [ResultHolder]
  
  private var isIgnoreEmptyField: Bool = false
  
  private var errorOnFailed: String?
  
  private var allFormFieldsAreFilledCallBack: ((Bool) -> Void)?
  private var allFormValuesAreValidateCallBack: ((Bool) -> Void)?
  
  private var failedCallBack: ((String) -> Void)?
  private var successCallBack: (([String: Any]) -> Void)?
  
  init() {
    self.listOfResult = [ResultHolder]()
  }
  
  // MARK: -
  
  /// <#Description#>
  ///
  /// - Parameter message: <#message description#>
  private func showMessage(message: String) {
    if let callBack = failedCallBack {
      callBack(message)
    } else {
//        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
//        alertController.addAction(defaultAction)
//        
//        appDelegate.topViewController()?.present(alertController, animated: true, completion: {
//        })
        UIAlertController.presentAlert(title: nil, message: message, style: UIAlertController.Style.alert).action(title: "Ok".localized, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
      })
    }
  }
  
  /// After validate all fileds.
  private func genrateParameters() {
    var parameters: Dictionary = [String: Any]()
    for holder in self.listOfResult {
      if let value = holder.value, value.isBlank {
        if self.isIgnoreEmptyField {
          continue
        }
      }
      parameters[holder.idientifier] = holder.value
    }
    
    if let callBack = successCallBack {
      callBack(parameters)
    }
    
  }
  
  private func trackFields() {
    var allFieldFilled: Bool = true
    for holder in self.listOfResult where holder.isFielld == false {
      allFieldFilled = false
      break
    }
    
    if let allFormFieldsAreFilledCallBack = allFormFieldsAreFilledCallBack {
      allFormFieldsAreFilledCallBack(allFieldFilled)
    }
    
    if allFieldFilled == false {
      if let allFormValuesAreValidateCallBack = allFormValuesAreValidateCallBack {
        allFormValuesAreValidateCallBack(false)
      }
      return
    }
    
    var allIsValid: Bool = true
    for holder in self.listOfResult where holder.isValid == false {
      allIsValid = false
      break
//      if holder.isValid == false {
//      }
    }
    
    if let allFormValuesAreValidateCallBack = allFormValuesAreValidateCallBack {
      allFormValuesAreValidateCallBack(allIsValid)
    }
    
  }
  
  // MARK: - Public actions
  
  /// Empty Field
  ///
  /// - Parameter ignore: <#ignore description#>
  /// - Returns: <#return value description#>
  @discardableResult
  func emptyField( ignore: @autoclosure () -> Bool) -> CLValidatorManager {
    isIgnoreEmptyField = ignore()
    return self
  }
  
  /// Register result Hodler
  ///
  /// - Parameter holder: Register a new result holder or will replace existing result holder
  func register(holder: ResultHolder) {
    let index = self.listOfResult.index {$0 == holder}
    if let index = index {
      self.listOfResult[index] = holder
    } else {
      self.listOfResult.append(holder)
    }
  }
  
  /// <#Description#>
  ///
  /// - Parameter textField: <#textField description#>
  func update(field textField: CLTextField) {
    let newHolder = textField.getHolder
    let index = self.listOfResult.index {$0 == newHolder}
    if let index = index {
      self.listOfResult[index] = newHolder
    } else {
      self.listOfResult.append(newHolder)
    }
    
    if self.allFormFieldsAreFilledCallBack != nil ||
      self.allFormValuesAreValidateCallBack != nil {
      self.trackFields()
    }
    
  }
  
  /// <#Description#>
  ///
  /// - Parameter success: <#success description#>
  /// - Returns: <#return value description#>
  func failure(_ callBack: @escaping ((String) -> Void)) {
    self.failedCallBack = callBack
  }
  
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - success: <#success description#>
  ///   - failure: <#failure description#>
  func startValidation(success: @escaping ([String: Any]) -> Void, failure: ((String) -> Void)? = nil) {
    
    self.successCallBack = success
    self.failedCallBack = failure
    
    var isValidate: Bool = true
    for holder in self.listOfResult {
      if let errors = holder.isError {
        errorOnFailed = errors.first
        isValidate = false
        break
      }
    }
    if isValidate == true {
      self.genrateParameters()
    } else {
      
      if let errorOnFailed = errorOnFailed {
        DispatchQueue.performAction(after: 0.1, callBack: {[weak self] (success: Bool) -> Void in
          self?.showMessage(message: errorOnFailed)
        })
      }
    }
  }
  
  /// All fields are filled or not
  ///
  /// - Parameter callBack: call back will fire on character did change every field. If all filled then it will retrun True otherwise False
  @discardableResult
  func allFieldsFilled(_ callBack: @escaping (Bool) -> Void) -> CLValidatorManager {
    self.allFormFieldsAreFilledCallBack = callBack
    return self
  }
  
  ///  All fields value is validated or not
  ///
  /// - Parameter callBack: call back will fire on character did change every field. If all fields value valid then it will return True otherwise, False.
  @discardableResult
  func allFieldsValidate(_ callBack: @escaping (Bool) -> Void) -> CLValidatorManager {
    self.allFormValuesAreValidateCallBack = callBack
    return self
  }
  
  /// Remove particulare holder for idientifier.
  func removeHolder(forIdientifier idientifier: String) -> Bool {
    let index = self.listOfResult.index {$0.idientifier == idientifier }
    if let index = index { self.listOfResult.remove(at: index)
      return true
    }
    return false
  }
  
  /// Retrun Holder for identifier.
  ///
  /// - Parameter withIdientifier: unique idientifier or parameters name
  /// - Returns: Retrun Holder for identifier is registered otherwise, it will return nil
  func reusableHolder(withIdientifier identifier: String) -> ResultHolder? {
    let index = self.listOfResult.index {$0.idientifier == identifier}
    if let index = index {
      return self.listOfResult[index]
    }
    return nil
  }
  
}

// MARK: -
/// Validation custom error message will retrun on failed validation.
struct ValidationError: Error {
  public let message: String
  public init(message string: String) {
    message = string
  }
}

// MARK: -
/// Resulst hodler will hold validations, behavior and value of field.
class ResultHolder {
  
  //Unique idientifier for each filed.
  private(set) var idientifier: String = ""
  
  //Behavior of field
  var behavior: FieldBehavior = .default
  
  //Contains multiple validation rules
  var validationRuleSet: ValidationRuleSet<String>?
  
  var value: String? {
    didSet {
      valueDidChanged?(self)
    }
  }
  
  ///Call back will fire on value did changed.
  var valueDidChanged: ((_ holder: ResultHolder) -> Void)?
  
  //Field is optional or not.
  var isOptional: Bool = false
  
  /// <#Description#>
  weak var validatorManager: CLValidatorManager?
  
  ///Retrun object of ValidationResult
  var validationResult: ValidationResult? {
    
    if let value = value {
      if isOptional && value.isBlank {
        return ValidationResult.valid
      }
    }
    
    if let validationRuleSet = validationRuleSet {
      return self.value?.validate(rules: validationRuleSet)
    } else {
      return ValidationResult.valid
    }
    
  }
  
  ///If value is Field then return true otherwise false.
  var isFielld: Bool {
    if self.isOptional {
      return true
    }
    if let valueIs = self.value {
      return !valueIs.isBlank
    }
    return false
  }
  
  ///Holder value is valid then retrun true otherwise flase.
  var isValid: Bool {
    
    if let validationResult = validationResult {
      switch validationResult {
      case .valid:
        return true
      case .invalid(_):
        return false
      }
    }
    
    return false
    
  }
  
  ///Holder value is not valid then it will return error otherwise nil
  var isError: [String]? {
    
    if let validationResult = validationResult {
      switch validationResult {
      case .valid:
        return nil
      case .invalid(let failures):
        let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
        return messages
      }
    }
    
    return nil
    
  }
  
  /// Init ResultHolder for specific param.
  ///
  /// - Parameters:
  ///   - idientifier: Idientifier should be unique,
  ///   - behavior: Behavoiur of filed.
  ///   - validationRuleSet: Set of reules.
  ///   - value: file value.
  ///   - isOptional: If is true, means field is optional.
  ///   - validatorManager: Validator manager hold all refrence fields results.
  init(idientifier: String,
       behavior: FieldBehavior,
       validationRuleSet: ValidationRuleSet<String>?,
       value: String? = "",
       isOptional: Bool = false,
       validatorManager: CLValidatorManager) {
    self.idientifier = idientifier
    self.behavior = behavior
    self.validationRuleSet = validationRuleSet
    self.value = value
    self.isOptional = isOptional
    self.validatorManager = validatorManager
    self.validatorManager?.register(holder: self)
    
  }
  
}

// MARK: - ResultHolder compared for value
extension ResultHolder: Equatable {
  static func == (lhs: ResultHolder, rhs: ResultHolder) -> Bool {
    return lhs.idientifier == rhs.idientifier
  }
}
