//
//  ResetPasswordController.swift
//  FoodFox
//
//  Created by socomo on 10/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordController: UIViewController {
  
    // MARK: - variables
    fileprivate var validatorManager: CLValidatorManager = CLValidatorManager()
  
    //    let me = Me()
    // MARK: - IBOutlet
    @IBOutlet weak var oldpassword: CLTextField! {
        didSet {
            oldpassword.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var newpassword: CLTextField! {
        didSet {
            newpassword.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var confirmpassword: CLTextField! {
        didSet {
            confirmpassword.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var saveBtn: UIButton! {
        didSet {
            saveBtn.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var topView: UIView!
     @IBOutlet weak var backGroundImage: UIImageView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
      super.viewDidLoad()
      self.oldpassword.delegate = self
      self.newpassword.delegate = self
      self.confirmpassword.delegate = self
      self.addValidationRules()
      oldpassword.changeAlignment()
      newpassword.changeAlignment()
      confirmpassword.changeAlignment()
      oldpassword.keyboardType = .default
      newpassword.keyboardType = .numberPad
      confirmpassword.keyboardType = .numberPad
      navTitle.text = "Change Password".localizedString
      saveBtn.setTitle("SAVE PASSWORD".localizedString, for: .normal)
      backBtn.changeBackBlackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.topView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0, blue: 0.2352941176, alpha: 1)
            self.confirmpassword.placeHolderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.newpassword.placeHolderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.oldpassword.placeHolderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.confirmpassword.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.newpassword.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.oldpassword.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            self.backGroundImage.backgroundColor = lightBlackColor
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
        } else {
            self.topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            self.backGroundImage.backgroundColor = .white
            
            self.confirmpassword.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.newpassword.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.oldpassword.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.confirmpassword.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.newpassword.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.oldpassword.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        }
    }
    
  
  // MARK: - Api of ChangePassword
    func submitRequest(parameters: [String: Any]) {
        
        var param: [String: Any] = [:]
        param["oldPassword"] = oldpassword.text
        param["newPassword"] = newpassword.text
        LoginManagerApi.share.changePassword(parameters: param) { (object: Any?, error: Error?) in
            print("object is \(String(describing: object))")
            
            if let response = object as? [String: Any] {
                if let status = response["statusCode"] as? Int {
                    switch status {
                    case 200:
                        if let message = response["message"] as? String {
                            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ -> Void in
                               _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    default:
                        break
                    }
                }
                
            }
        }
    }
  
    // MARK: - Add Validation Rules
    func addValidationRules() {
        let oldPasswordHolder = ResultHolder(idientifier: "oldPassword",
                                             behavior: .password, validationRuleSet: CLValidation.ruleNotBlank("ErrorOldPassword".localizedString),
                                             value: "", isOptional: false, validatorManager: self.validatorManager)
        oldpassword.set(reusltHolder: oldPasswordHolder)
        oldpassword.placeholder = "Old Password".localizedString
        let   passwordHolder = ResultHolder(idientifier: "newpassword",
                                            behavior: .password,
                                            validationRuleSet: CLValidation.newPasswordRulesSet,
                                            validatorManager: self.validatorManager)
        newpassword.set(reusltHolder: passwordHolder)
        newpassword.placeholder = "New Password(6 Digit password)".localizedString
        let confirmPasswordHolder = ResultHolder(idientifier: "confirmPassword",
                                                 behavior: .password, validationRuleSet: CLValidation.ruleNotBlank("ErrorConfirmPassword".localizedString),
                                                 value: "", isOptional: false, validatorManager: self.validatorManager)
        confirmpassword.set(reusltHolder: confirmPasswordHolder)
       confirmpassword.placeholder = "Confirm New Password(6 Digit password)".localizedString
    }
  
    // MARK: - UIActions
    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
  // MARK: Action to submit details
    @IBAction func actionSubmit(_ sender: Any) {
        self.validatorManager.startValidation(success: { (parame: [String: Any]) in
            if self.newpassword.stringMatched(txtField: self.confirmpassword) {
                self.submitRequest(parameters: parame)
            }
        })
    }
}

// MARK: - TextField Delegate
extension ResetPasswordController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text {
            let finalString = (text as NSString).replacingCharacters(in: range, with: string)
            if (textField.isMaxLenth() || finalString.hasSpace()) && string.length > 0 {
                return false
            }
        }
        if textField == newpassword && !textField.isValidPasswordLenth() && string.length > 0 {
             
            return false
        }
        if textField == confirmpassword && !textField.isValidPasswordLenth() && string.length > 0 {
             
            return false
        }
        return true
    }
}
