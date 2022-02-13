//
//  SignupViewController.swift
//  CLApp
//
//  Created by cl-macmini-68 on 14/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

enum SignupSectionType: Int, CaseCountable {
  case email
  case username
  case firstName
  case lastName
  case password
  case confirmPassword
  case phoneNumber
  case submitButton
}

class SignupViewController: CLBaseViewController {
    // MARK: - IBOutlets
  @IBOutlet var tableView: UITableView!
  var signupDataSource: SignupFormDataSource?
  
  // MARK: - ************ HOW to use ValidatorManager ***************************
  // MARK: - Craete a CLValidatorManager object.
  
  fileprivate var validatorManager: CLValidatorManager = CLValidatorManager()
  
  //private let emailValidatorManager: CLValidatorManager = CLValidatorManager()
  
  deinit {
    print("SignupViewController diinit deinit")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(true)
    print("viewWillDisappear")
  }
    // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = R.string.localizable.signUp()
    // Do any additional setup after loading the view.
    tableView.registerCell("FieldCell")
    tableView.delegate = self
    tableView.hideLastCellLine()
    tableView.separatorStyle = .none
    
    //Table View Data Source
    signupDataSource = SignupFormDataSource(manager: self.validatorManager)
    tableView.dataSource = signupDataSource
    
    // MARK: 1 - allFieldsFilled
    self.validatorManager.allFieldsFilled { (filled: Bool) in
      //Tracking all fields are filled or not.
      //print(R.string.localizable.allFieldsAREFilled(filled))
      //print(R.string.localizable.allFieldsAREFilled(filled? "Filled": "NO"))
    }
    
    // MARK: 2 - allFieldsValidate
    self.validatorManager.allFieldsValidate { (validate: Bool) in
      //Tracking all fields are validate or not.
      print("All Fields Are Validate = \(validate) ")
      print("All Fields Are Validate = \(validate) ")
    }
    
  }
  
  // MARK: - Submit button clicked
  func submitButtonClicked() {
    
    // MARK: 3 - Remove for Idientifier.
    // self.validatorManager.removeHolder(forIdientifier: "")
    
    //******************** Start Validation **************
    // MARK: 4 - emptyField ignore or not
    self.validatorManager.emptyField(ignore: true)
    
    // MARK: 5 - startValidation
    self.validatorManager.startValidation(success: { (parame: [String: Any]) in
      
      for (key, value) in parame {
        cllog("\(key): \(value)")
      }
      self.submitRequest(parameters: parame)
      
    })
  }
  
  func submitRequest(parameters: [String: Any]) {
    
    var tokan = "iOSToken"
    
    if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
      tokan = deviceToken
    }
    
    var param: [String: Any] = [:]
    param["deviceType"] = deviceType
    param["deviceToken"] = tokan
    param["countryCode"] = countryCode
    param.appendDictionary(other: parameters)
    param["confirmPassword"] = nil
    
    LoginManagerApi.share.signup(parameters: param, files: [], password: "") { (object: Any?, error: Error?) in
      
      if error != nil {
        return
      }
      NotificationCenter.default.post(name: Notification.Name.RootControllerState.openMenu, object: nil)
    }
    
  }
  
}

// MARK: - UITableViewDelegate
extension SignupViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if SignupSectionType.count == indexPath.section - 1 {
      return 100.0
    }
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    guard let sectionType: SignupSectionType = SignupSectionType(rawValue: indexPath.section) else {
      fatalError("Section not avaliable for index path \(indexPath.section) - \(indexPath.row)")
    }
    
    if sectionType == .submitButton {
      self.submitButtonClicked()
    }
    
  }
  
}
