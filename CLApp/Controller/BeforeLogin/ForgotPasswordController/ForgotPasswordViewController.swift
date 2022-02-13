//
//  ForgotPasswordViewController.swift
//  CLApp
//
//  Created by click Labs on 7/18/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textphone: CLTextField! {
        didSet {
            textphone.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var titleDecription: UILabel! {
        didSet {
            titleDecription.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
           navTitle.font = AppFont.semiBold(size: 19)
        }
    }
    @IBOutlet weak var resetBtn: CLButton! {
        didSet {
            resetBtn.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Variables
    fileprivate var validatorManager: CLValidatorManager = CLValidatorManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.localizable.forgot_Password()
        self.navigationController?.navigationBar.isHidden = true
        addValidationRules()
        textphone.changeAlignment()
        localizedString()
        backBtn.changeBackWhiteButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.textphone.placeHolderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.textphone.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.titleDecription.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            self.backgroundImageView.backgroundColor = lightBlackColor
            
            self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
            self.countryCodeBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        } else {
            
            self.backgroundImageView.backgroundColor = .white
            
            self.textphone.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.titleDecription.textColor  = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            
            self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
            self.countryCodeBtn.setTitleColor(#colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1), for: .normal)
        }
        
    }
    
    
  //MARK: Localized String
  func localizedString() {
    titleDecription.text = "Please enter your registered Phone number to reset your password.".localizedString
    navTitle.text = "Forgot_Password".localizedString
    resetBtn.setTitle("RESET PASSWORD".localizedString, for: .normal)
  }
  
    // MARK: - Add Validation Rules
    func addValidationRules () {
        let mobileHolder = ResultHolder(idientifier: "phoneNo",
                                        behavior: .phoneNumber,
                                        validationRuleSet: CLValidation.phoneRulesSetValue,
                                        isOptional: false,
                                        validatorManager: self.validatorManager)
        textphone.set(reusltHolder: mobileHolder)
        textphone.placeholder = "Phone number".localizedString
    }
    
    // MARK: - UIActions
    
    @IBAction func diallingCodeButtonClicked(_ sender: Any) {
        
        let controller = CLCountryPickerController.presentController(on: self) { (country: Country) in
            self.countryCodeBtn.setTitle(country.dialingCode(), for: .normal)
        }
        controller.tintColor = AppColor.themePrimaryColor
        controller.isHideFlagImage = false
        controller.isHideDiallingCode = false
        controller.separatorLineColor = UIColor.lightGray.withAlphaComponent(0.5)
        controller.labelColor = AppColor.themePrimaryColor
        controller.labelFont = AppFont.regular(size: 16)
        controller.detailColor = AppColor.themeSecondaryColor
    }
    
    @IBAction func actionResetPwd(_ sender: Any) {
      validatorManager.startValidation(success: { (parameter: [String: Any]) in
        self.callForgotPassword()
      })
    }
    
    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
  
  // MARK: Send Button Clicked
    @IBAction func sendButtonClicked(_ sender: Any) {

        let text = textphone.text ?? ""
        //Email cannot blank
        let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: R.string.localizable.emailIsRequired()))

        //Email format validation
        let validateRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message: R.string.localizable.emailIsNotValid()))
        //Set of rules
        var validateRuelsSet = ValidationRuleSet<String>()
        validateRuelsSet.add(rule: ruleRequired)
        validateRuelsSet.add(rule: validateRule)

        let result = text.validate(rules: CLValidation.emailRulesSet)
        //Check result is valid or not
        if self.validate(result: result) == false {
            return
        }
    }
    
    func validate(result: ValidationResult) -> Bool {
        switch result {
        case .valid:
            return true
        case .invalid(let failures):
            let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
            if let message = messages.first {
                showMessage(errorMessage: message)
            }
            return false
        }
    }
    
    func showMessage(errorMessage: String) {
        self.textphone.resignFirstResponder()
        DispatchQueue.performAction(after: 0.2) { (completion: Bool) in
            UIAlertController.presentAlert(title: nil, message: errorMessage, style: .alert).action(title: "Ok".localizedString, style: .default, handler: { (alert: UIAlertAction) in
            })
        }
    }
  
    // MARK: - Api Of Forgot Password
    func callForgotPassword() {
        let text = textphone.text ?? ""
        let countryCode = self.countryCodeBtn.titleLabel?.text ?? ""
        let phone = text
        LoginManagerApi.share.forgotPassword(diallingCode: countryCode, phone: phone) { (response: Any?, error: Error?) in
            guard error == nil else {
                return
            }
            if let response = response as? [String: Any] {
                if let message = response["message"] as? String {
                    self.showMessage(errorMessage: message)
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - TextFieldDelegates
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let textFieldText = textField.text {
            _ = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        }
        if textField == textphone && !textField.isValidMobileLenth() && string.length > 0 {
            return false
        }
        return true
    }
}
