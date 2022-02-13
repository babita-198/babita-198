//
//  LoginViewController.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import IQKeyboardManagerSwift

class LoginViewController: CLBaseViewController {
  
  @IBOutlet var passwordTextField: CLTextField!
  @IBOutlet var emailTextField: CLTextField!
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var forgotButton: UIButton!
  @IBOutlet weak var fbButton: UIButton!
  @IBOutlet weak var googleButton: UIButton!
//  @IBOutlet weak var scrView: UIScrollView!
  
  
  var dataRequest: DataRequest?
  var validatorManager: CLValidatorManager = CLValidatorManager()
  
  // MARK: -
  override func viewDidLoad() {
    super.viewDidLoad()
    passwordTextField.text = "Qwerty@123"
    let user: User = User()
    print(user.toJSON() ?? "JSON -- ")
    
     passwordTextField.changeAlignment()
      emailTextField.changeAlignment()
    // super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.title = R.string.localizable.login()
    
    //Email
    let emailHolder = ResultHolder(idientifier: "email",
                                   behavior: .email,
                                   validationRuleSet: CLValidation.emailRulesSet,
                                   value: "email3@gmail.com",
                                   validatorManager: self.validatorManager)
    emailTextField.set(reusltHolder: emailHolder)
    
    //password
    passwordTextField.isSecureTextEntry = true
    ///passwordTextField.addDoneOnKeyboardWithTarget(<#T##target: AnyObject?##AnyObject?#>, action: <#T##Selector#>)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: -
  /// Use validations manually.
  ///
  /// - Parameter result: ValidationResult
  /// - Returns: If result is valid, it will return true.
  func validate(result: ValidationResult) -> Bool {
    switch result {
    case .valid:
      return true
    case .invalid(let failures):
        let messages = failures.compactMap { $0 as? ValidationError }.map { $0.message }
      print(messages)
      if let message = messages.first {
        UIAlertController.presentAlert(title: nil, message: message, style: .alert).action(title: R.string.localizable.ok(), style: .default, handler: { (alert: UIAlertAction) in
        })
      }
      return false
    }
  }
  
  // MARK: - Actions
  @IBAction func loginButtonClicked(_ sender: AnyObject) {
    
    //Email cannot blank
    let ruleRequired =  ValidationRuleBlank(error: ValidationError(message: R.string.localizable.emailIsRequired()))
    
    //Email format validation
    let validateRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message: R.string.localizable.emailIsNotValid()))
    //Set of rules
    var validateRuelsSet = ValidationRuleSet<String>()
    validateRuelsSet.add(rule: ruleRequired)
    validateRuelsSet.add(rule: validateRule)
    
    let email = self.emailTextField.text ?? ""
    let result = email.validate(rules: CLValidation.emailRulesSet)
    
    //Check result is valid or not
    if self.validate(result: result) == false {
      return
    }
    
    
    //----2
    let password = self.passwordTextField.text ?? ""
    let passwordReuslt = password.validate(rules: CLValidation.passwordRulesSet)
    if self.validate(result: passwordReuslt) == false {
      return
    }
    
    var tokan = "iOSToken"
    
    if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
      tokan = deviceToken
    }
    
    let param: [String: String] = ["email": email,
                                   "role": UserRole.customer.rawValue,
                                   "password": password,
                                   "appVersion": appDelegate.appVersion,
                                   "deviceType": deviceType,
                                   "deviceToken": tokan]
    
    //"rememberMe": "",
    // "primaryMobile": "",
    
    LoginManagerApi.share.login(parameter: param) { (object: Any?, error: Error?) in
      if error != nil {
        return
      }
   
      NotificationCenter.default.post(name: Notification.Name.RootControllerState.openMenu, object: nil)
    }
    
  }
  
  @IBAction func forgotButtonClicked(_ sender: AnyObject) {
    
    if let forgotPasswordController = R.storyboard.main.forgotPasswordViewController() {
      self.navigationController?.pushViewController(forgotPasswordController, animated: true)
    }
    
  }
  
  // MARK:  Facebook Login
  @IBAction func fbButtonCicked(_ sender: Any) {
    FacebookManager.share.getUserProfile(from: self, handler: { (error: Error?, response: Any?) in
      
      print(response ?? "Response = nil")
      
    })
    
  }
  
  // MARK:  Google Login
  @IBAction func googleButtonClicked(_ sender: Any) {
    
  }
}
