//
//  CLTextField.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

enum FieldBehavior: Int {
    
    case `default`
    case email
    case phoneNumber
    case decimalNumber
    case username
    case name
    case password
    
    public var value: String {
        switch self {
        case .`default`:
            return  "`default`"
        case .email:
            return  "email"
        case .phoneNumber:
            return  "phoneNumber"
        case .decimalNumber:
            return  "decimalNumber"
        case .name:
            return  "name"
        case .username:
            return "username"
        case .password:
            return "password"
        }
    }
}

typealias ShouldChange = ((_ field: CLTextField, _ inRange: NSRange, _ withString: String) -> Bool)?

///----- In progress please use manually validations.
class CLTextField: UITextField, ValidatableInterfaceElement {
    func validate<R>(rule r: R) -> ValidationResult where R : ValidationRule, CLTextField.InputType == R.InputType {
        return ValidationResult.valid
    }
    
    
    //ValidatableInterfaceElement
    public typealias InputType = String
    open var inputValue: String? { return text }
    
    private weak var resultHolder: ResultHolder?
    func set(reusltHolder: ResultHolder) {
        self.resultHolder = reusltHolder
        self.text = self.resultHolder?.value
//        self.clearButtonMode = UITextFieldViewMode.whileEditing
        let reules = self.resultHolder?.validationRuleSet
        self.validationRules = reules
        self.behaviorChanged()
    }
    
    override public var text: String? {
        didSet {
            self.validate1(text: self)
        }
        willSet {
        }
    }
    
    /// Field Result Holder
    var getHolder: ResultHolder {
          return resultHolder!
    }
    
    //private var behavior: FieldBehavior = FieldBehavior.default
    var behaviorType: FieldBehavior {
        if let holder = resultHolder {
            return holder.behavior
        }
        return .default
    }
    
    fileprivate var validationRuleSet: ValidationRuleSet<String> {
        if let holder = resultHolder,
            let holderRule = holder.validationRuleSet {
            return holderRule
        }
        return CLValidation.blankRulesSet
    }
    
    ///Enable validation on should change character.
    var isValidationOnShouldChangeCharacters: Bool = false
    
    /// ShouldChange is callback for particular filed. Return NO to not change text.
    /// ShouldChangeCharactersIn Delegate method reponsible for Invoked it.
    fileprivate var shouldChange: ShouldChange?
    
    /// If text field is empty and isOptionalField is true then it will ignore validations.
    var isOptionalField: Bool = false
    
    ///Init Settings.
    private func initUpdate() {
        
        self.delegate = self
        
        //self.validateOnEditingEnd(enabled: true);
        self.validateOnInputChange(enabled: true)
        
        self.validationHandler = {result in
            switch result {
            case .valid:
                break
            case .invalid(let failures):
                let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
                print(messages)
            }
        }
    }
    
    /// Default
    /// - Parameter frame: CGRect
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUpdate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUpdate()
    }
    
    /// Disable clipboard methods while enable Secure text entry.
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if self.isSecureTextEntry == false {
            return super.canPerformAction(action, withSender: sender)
        }
        
        if action == #selector(cut(_:)) {
            return false
        }
        if action == #selector(paste(_:)) {
            return false
        }
        if action == #selector(select(_:)) {
            return false
        }
        if action == #selector(selectAll(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
        
    }
    
    // MARK: - Behavior
    private func behaviorChanged() {
        
        switch behaviorType {
            
        case .email:
            self.keyboardType = .emailAddress
            self.autocorrectionType = .no
            self.autocapitalizationType = .none
            self.isSecureTextEntry = false
            break
            
        case .password:
            self.keyboardType = .default
            self.autocorrectionType = .no
            self.autocapitalizationType = .none
            self.isSecureTextEntry = true
            break
            
        case .name:
            self.keyboardType = .default
            self.autocorrectionType = .default
            self.autocapitalizationType = .words
            self.isSecureTextEntry = false
            break
            
        case .username:
            self.keyboardType = .default
            self.autocorrectionType = .default
            self.autocapitalizationType = .none
            self.isSecureTextEntry = false
            break
            
        case .phoneNumber:
            self.keyboardType = .phonePad
            self.autocapitalizationType = .none
            self.autocorrectionType = .default
            self.isSecureTextEntry = false
            break
        case .decimalNumber:
            self.keyboardType = .decimalPad
            self.autocapitalizationType = .none
            self.autocorrectionType = .default
            self.isSecureTextEntry = false
            break
            
        default:
            self.keyboardType = .default
            self.autocapitalizationType = .sentences
            self.autocorrectionType = .default
            self.isSecureTextEntry = false
            break
        }
    }
    
    // MARK: -
    private func updateResult() {
        if let resultHolder = self.resultHolder,
            let manager = resultHolder.validatorManager {
            manager.update(field: self)
        }
    }
    
    func shouldChangeCharacterCondition(custom callBack: ShouldChange) {
        shouldChange = callBack
    }
    
    func stringMatched(txtField: UITextField) -> Bool {
        
        if self.text != txtField.text {
            stringNotMatchedMsg(txtField: txtField)
            return false
        } else {
            return true
        }
        
    }
    func  stringNotMatchedMsg(txtField: UITextField) {
        let alertController = UIAlertController(title: nil, message: "Confirm password does not match with new password".localizedString, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        appDelegate.topViewController()?.present(alertController, animated: true, completion: {
        })
                
    }
    
    // MARK: - Validatons
    //enable disable input change validator.
    internal func validateOnInputChange(enabled: Bool) {
        switch enabled {
        case true: addTarget(self, action: #selector(validate1), for: .editingChanged)
        case false: removeTarget(self, action: #selector(validate1), for: .editingChanged)
        }
    }
    
    internal func validateOnEditingEnd(enabled: Bool) {
        switch enabled {
        case true: addTarget(self, action: #selector(validate1), for: .editingDidEnd)
        case false: removeTarget(self, action: #selector(validate1), for: .editingDidEnd)
        }
    }
    
    @objc internal func validate1(text field: CLTextField) {
        self.resultHolder?.value = field.text
        field.validate()
        self.updateResult()
    }
    
}

// MARK: - Text Field Delegate
extension CLTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //---
        if let callBack = shouldChange {
            if let textField = textField as? CLTextField {
                return callBack!(textField, range, string)
            }
        }
        
        if self.isValidationOnShouldChangeCharacters == false {
            return true
        }
        
        if string == "" {
            return true
        }
        
        let result = string.validate(rules: self.validationRuleSet)
        switch  result {
        case .valid:
            return true
        default:
            return false
        }
        
    }
    
}
