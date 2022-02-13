
  //
  //  SignInController.swift
  //  FoodFox
  //
  //  Created by Ritu Grodia on 17/09/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

import UIKit
//import MZFayeClient
//import Hippo
import GoogleSignIn
import CoreData
import AuthenticationServices

  import IQKeyboardManagerSwift

  struct Login {
      let email: String
      let socialMode: SocialMode
      let socialId: String
    
  }


class SignInController: UIViewController {
    
      //MARK:- Outlets
      @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet var btnApple: UIButton!
       @IBOutlet weak var btnCreateAccount: UIButton! {
        didSet {
            btnCreateAccount.titleLabel?.font = AppFont.bold(size: 18)
        }
    }
    @IBOutlet weak var btnForgotPwd: UIButton! {
        didSet {
            btnForgotPwd.titleLabel?.font = AppFont.bold(size: 18)
        }
    }
    @IBOutlet weak var lblSignIn: UILabel! {
        didSet {
            lblSignIn.font = AppFont.bold(size: 26)
        }
    }
      @IBOutlet weak var txtEmail: CLTextField! {
        didSet {
            txtEmail.font = AppFont.light(size: 18)
        }
      }
    @IBOutlet weak var txtPwd: CLTextField! {
        didSet {
            txtPwd.font = AppFont.light(size: 18)
        }
    }
      @IBOutlet weak var btnShow: UIButton! {
        didSet {
            btnShow.titleLabel?.font = AppFont.bold(size: 15)
        }
      }
     @IBOutlet weak var btnSignIn: UIButton! {
        didSet {
            btnSignIn.titleLabel?.font = AppFont.semiBold(size: 18)
        }
     }
    
     @IBOutlet weak var previousNextView: UIView!
    
    
      // MARK: - Variables
      fileprivate var isFromLogin = false
      fileprivate var fromSocial = ""
      fileprivate var socialType = ""
      fileprivate var firstname = ""
      fileprivate var lastname = ""
      fileprivate var profilepic = ""
      fileprivate var window: UIWindow?
      fileprivate var isSignUpViaSocial: Bool = false
      fileprivate var validatorManager: CLValidatorManager = CLValidatorManager()
      fileprivate var phoneNumberValidatorManager: CLValidatorManager = CLValidatorManager()
    
      //MARK:- LifeCycle
      override func viewDidLoad() {
        super.viewDidLoad()
        btnCreateAccount.layer.borderWidth = 2
        btnCreateAccount.layer.borderColor = UIColor(red: 240/255, green: 140/255, blue: 05/255, alpha: 1.0).cgColor
        btnCreateAccount.layer.cornerRadius = 20
        btnCreateAccount.setTitleColor(UIColor(red: 240/255, green: 140/255, blue: 05/255, alpha: 1.0), for: .normal)
        //let image = UIImage(named: "sign up with email")?.withRenderingMode(.alwaysTemplate)
        //btnCreateAccount.setImage(UIImage(named: "sign up with email"), for: .normal)
        //btnCreateAccount.tintColor = UIColor(red: 240, green: 140, blue: 05, alpha: 1.0)
        self.navigationController?.navigationBar.isHidden = true
        self.defaultSettings()
        self.googleDefalutSetting()
        self.accessTokenApi()
        txtPwd.changeAlignment()
        txtEmail.changeAlignment()
        btnCancel.changeBackWhiteButton()
        self.localizedStr()
        
        //Google sign-in initialize 
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = Keys.googleClietId
        
      }
    
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        self.btnForgotPwd.isHidden = false
         checkStatusForDarkMode()
      }
    

  //MARK:- CHECK STATUS FOR NIGHT MODE

  func checkStatusForDarkMode( ) {
    
    let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
    
    if isDarkMode == true {
        
        self.view.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        self.previousNextView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        self.txtEmail.placeHolderColor = lightWhite
        self.txtPwd.placeHolderColor = lightWhite
        self.txtEmail.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
        self.txtPwd.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
        btnCreateAccount.setTitleColor(#colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1), for: .normal)
        
    } else {
        self.view.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
        self.previousNextView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
        self.txtEmail.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        self.txtPwd.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        self.txtEmail.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        self.txtPwd.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
         btnCreateAccount.setTitleColor(#colorLiteral(red: 0.9913015962, green: 0.6188052893, blue: 0, alpha: 1), for: .normal)
    }
    
  }
    
    
    //MARK: Localized String
    func localizedStr() {
        btnSignIn.cornerRadius = 22
        btnSignIn.clipsToBounds = true
        //btnCreateAccount.setTitle("Create an Account?".localizedString, for: .normal)
        lblSignIn.text = "Log in".localizedString
        btnForgotPwd.setTitle("Forgot Password?".localizedString, for: .normal)
        btnSignIn.setTitle("LOG IN".localizedString, for: .normal)
        txtEmail.placeholder = "Email ID/ Phone Number".localizedString
        txtPwd.placeholder = "Password (6 Digit Password)".localizedString
    }
    
      // MARK: - Api of AccessToken
      func accessTokenApi() {
        var tokan = "iOSToken"
        if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
          tokan = deviceToken
        }
          if LoginManagerApi.share.me?.accessToken != nil {
              var param: [String: Any] = [:]
              param["deviceToken"] = tokan
              param["deviceType"] = deviceType
              param["appVersion"] = "\(appVersionValue)"
              param["latitude"] = LocationTracker.shared.currentLocationLatitude
              param["longitude"] = LocationTracker.shared.currentLocationLongitude
              print("accessToken params...... \(param)")
            
              LoginManagerApi.share.accessToken(parameters: param) { (object: Any?, error: Error?) in
                  if error != nil {
                      return
                  }
                  print("updateProfile Error \(String(describing: error))")
                
              }
          } else {
              return
          }
      }

      func googleDefalutSetting() {
          //GIDSignIn.sharedInstance().delegate = self
          //GIDSignIn.sharedInstance().uiDelegate = self
      }
    
      //MARK:- Methods
      func defaultSettings() {
          self.navigationController?.navigationBar.isHidden = true
          self.txtEmail.text = ""
          self.txtPwd.text = ""
          self.setPwdVisibility(val: false)
          addNotifications()
          addRulesForEmail()
          addRulesForPhonenumber()
      }
    
      func setPwdVisibility(val: Bool) {
          if val {
              self.txtPwd.isSecureTextEntry = false
              self.btnShow.setTitle("Hide".localizedString, for: .normal)
          } else {
              self.txtPwd.isSecureTextEntry = true
              self.btnShow.setTitle("Show".localizedString, for: .normal)
          }
      }
    
      func checkAccessToken() {
          if LoginManagerApi.share.isAccessTokenValid {
            openMenuController()
          }
      }
    
      func addNotifications() {
          //NotificationCenter.default.removeObserver(self, name: Notification.Name.RootControllerState.openMenu, object: nil)
          NotificationCenter.default.removeObserver(self, name: Notification.Name.LoginManagerStatus.logout, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.OtpControllerState.moveToOtp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToOTPVC), name: Notification.Name.OtpControllerState.moveToOtp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMenuController), name: Notification.Name.RootControllerState.openMenu, object: nil)
//          NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: Notification.Name.LoginManagerStatus.logout, object: nil)
      }
    
      //MARK:- Add Rules
      func addRulesForPhonenumber() {
          let emailHolder = ResultHolder(idientifier: "phoneNumber",
                                         behavior: .email,
                                         validationRuleSet: CLValidation.phoneRulesSet,
                                         value: self.txtEmail.text ?? "",
                                         isOptional: false,
                                         validatorManager: self.phoneNumberValidatorManager)
          txtEmail.keyboardType = .default
          txtEmail.set(reusltHolder: emailHolder)
        
          let password = ResultHolder(idientifier: "password",
                                      behavior: .password,
                                      validationRuleSet: CLValidation.passwordRulesSet,
                                      value: self.txtPwd.text ?? "",
                                      isOptional: false,
                                      validatorManager: self.phoneNumberValidatorManager)
          txtPwd.keyboardType = .default
          txtPwd.set(reusltHolder: password)
      }

    func addRulesForEmail() {
          let emailHolder = ResultHolder(idientifier: "confirmEmail",
                                         behavior: .email,
                                         validationRuleSet: CLValidation.emailRulesSet,
                                         value: self.txtEmail.text ?? "",
                                         isOptional: false,
                                         validatorManager: self.validatorManager)
          txtEmail.keyboardType = .default
          txtEmail.set(reusltHolder: emailHolder)
        
          let password = ResultHolder(idientifier: "password",
                                      behavior: .password,
                                      validationRuleSet: CLValidation.passwordRulesSet,
                                      value: self.txtPwd.text ?? "",
                                      isOptional: false,
                                      validatorManager: self.validatorManager)
          txtPwd.keyboardType = .default
          txtPwd.set(reusltHolder: password)
      }
    
      //MARK:- UIActions
    
      @IBAction func actionGoogle(_ sender: Any) {
          self.view.endEditing(true)
          GIDSignIn.sharedInstance().clientID = Keys.googleClietId
          GIDSignIn.sharedInstance().delegate=self
          GIDSignIn.sharedInstance()?.presentingViewController = self
          GIDSignIn.sharedInstance().signIn()
      }
    
      @IBAction func actionSignIn(_ sender: Any) {
        let badCharacters = NSCharacterSet(charactersIn: "1234567890+").inverted
        if self.txtEmail.text?.rangeOfCharacter(from: badCharacters) == nil {
            addRulesForPhonenumber()
          
            //self.phoneNumberValidatorManager.startValidation(success: {_ in
                self.login()
            //})
        } else {
            addRulesForEmail()
            self.validatorManager.startValidation(success: { _ in
                self.login()
            })
        }
      }
    
      @IBAction func actionCancel(_ sender: Any) {
        guard let viewControllers = self.navigationController?.viewControllers else {
          return
        }
        for controller in viewControllers {
          if controller.isKind(of: ViewCartController.self) {
            self.navigationController?.popToViewController(controller, animated: true)
            return
          }
        }
        if let rootViewController = R.storyboard.main().instantiateInitialViewController() as? UINavigationController {
          if let vc = R.storyboard.main.chooseDeliveryController() {
            if !rootViewController.viewControllers.contains(vc) {
              rootViewController.viewControllers.removeAll()
              rootViewController.viewControllers.append(vc)
              UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
          }
        }
    }
    
      @IBAction func actionForgotPwd(_ sender: Any) {
          if let viewController: ForgotPasswordViewController = R.storyboard.main.forgotPasswordViewController() {
              self.navigationController?.pushViewController(viewController, animated: true)
          }
      }
    
      @IBAction func actionFacebook(_ sender: Any) {
          FacebookManager.share.getUserProfile(from: self) { (error: Error?, fbData: Any?) in
              //             print(fbData)
              var emailId = ""
              guard let fbResult = fbData as? [String: Any], let firstname = fbResult["first_name"] as? String, let lastname = fbResult["last_name"] as? String, let id = fbResult["id"]
                  as? String else {
                      return
              }
              if let email = fbResult["email"] as? String {
                  emailId = email
                  print(emailId)
              }
            
              var image = ""
              if let picture = fbResult["picture"] as? [String: Any], let data = picture["data"] as? [String: Any], let imgStr = data["url"] as? String {
                  image = imgStr
              }
              let social = Social(firstName: firstname, lastName: lastname, email: emailId, socialMode: .facebook, socialId: id, socialpicture: image, isTwitter: false)
            
              self.loginViaSocial(social: social)
          }
      }
    
    
      @IBAction func actionShowPassword(_ sender: UIButton) {
          sender.isSelected = !sender.isSelected
          self.setPwdVisibility(val: sender.isSelected)
      }
    
    @IBAction func actionAppleSignIN(_ sender: UIButton){
        
        if #available(iOS 13.0, *){
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.email, .fullName]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            
        }
    }

    // MARK: -  Google Integration
      func login() {
        
        
        var tokan = "iOSToken"
        if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
          tokan = deviceToken
        }
          LoginManagerApi.share.me?.socialLogin = false
          let email = self.txtEmail.text ?? ""
          let password = self.txtPwd.text ?? ""
      
          var param: [String: Any] = ["email": email,
                                      "password": password,
                                      "appVersion": appDelegate.appVersion,
                                      "deviceType": deviceType,
                                      "deviceToken": tokan,
                                      "latitude": LocationTracker.shared.currentLocationLatitude,
                                      "longitude": LocationTracker.shared.currentLocationLongitude,
                                      "flushPreviousSessions": true]
        let language = Localize.currentLang()
        if language == .english {
          param["language"] = "en"
        } else {
          param["language"] = "en"
        }
          LoginManagerApi.share.login(parameter: param) { (object: Any?, error: Error?) in
              print(object as Any)
             UserDefaults.standard.set(true, forKey: "LoginStatus")
          }
      }

    func loginViaSocial(social: Social) {
        var tokan = "iOSToken"
        if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
          tokan = deviceToken
        }
        
          var emailId = " "
          var param: [String: Any] = [:]
          if social.isTwitter == false {
              if social.email.length != 0 {
                  emailId = social.email
                  param["email"] = emailId
              }
          }
          param["socialId"] = social.socialId
          param["deviceType"] = deviceType
          param["deviceToken"] = tokan
          param["appVersion"] = appDelegate.appVersion
          param["socialMode"] = social.socialMode.rawValue
          param["flushPreviousSessions"] = true
          param["latitude"] = LocationTracker.shared.currentLocationLatitude
          param["longitude"] = LocationTracker.shared.currentLocationLongitude
      
      let language = Localize.currentLang()
      if language == .english {
        param["language"] = "ar"
      } else {
        param["language"] = "en"
      }
      
          print(" param is....\(param)")
          LoginManagerApi.share.socialLogin(parameter: param) { (object: Any?, error: Error?) in
              self.isSignUpViaSocial = true
              print(object as Any)
              guard let me = LoginManagerApi.share.me else {
                  return
              }
              print("is Social \(me.isSocial)")
              if me.isSocial == false {
                  if let viewController = R.storyboard.main.signUpController() {
                      viewController.signUpViaSocial = self.isSignUpViaSocial
                      viewController.firstName = social.firstName
                      if let pic = social.socialpicture {
                          viewController.profilepic = pic
                      }
                    
                      viewController.socialId = social.socialId
                      viewController.socialMode = social.socialMode.rawValue
                      if social.isTwitter == false {
                          viewController.lastName = social.lastName
                      }
                      if social.email.length != 0 {
                          emailId = social.email
                          viewController.email = emailId
                      }
                    
                      self.navigationController?.pushViewController(viewController, animated: true)
                  }
              }
            
          }
      }
    
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

    //    private
      func profileVerify() -> Bool {
          if LoginManagerApi.share.me?.isVerified == false {
              print("not verified")
              
              if let viewController = R.storyboard.main.oTPViewController() {
                  self.navigationController?.pushViewController(viewController, animated: true)
              }
              return false
          }
          print("verified")
          return true
      }
    
      @objc func userDidLogout() {
        self.deleteAllRecords()
     //   HippoConfig.shared.clearHippoUserData()
        navigationController?.navigationBar.isHidden = false
          if let rootViewController = R.storyboard.main().instantiateInitialViewController() as? UINavigationController {
              if let vc = R.storyboard.main.signInController() {
                  if !rootViewController.viewControllers.contains(vc) {
                      rootViewController.viewControllers.removeAll()
                      rootViewController.viewControllers.append(vc)
                      UIApplication.shared.keyWindow?.rootViewController = rootViewController
                  }
              }
          }
      }
    
    
    //MARK: Delete all records from Local Storage
    func deleteAllRecords() {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      if #available(iOS 10.0, *) {
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
          try context.execute(deleteRequest)
          try context.save()
        } catch {
          print("Error")
        }
      }
    }
    
      @objc func moveToOTPVC() {
          if let otpVC = R.storyboard.main.oTPViewController() {
             otpVC.isFromSignUp = true
              self.navigationController?.pushViewController(otpVC, animated: true)
          }
      }
    
      // MARK: - Root controller actions..
    @objc func openMenuController() {
          let isProfileVerified = profileVerify()
          if !isProfileVerified {
              return
          }
        guard let viewControllers = self.navigationController?.viewControllers else {
          return
        }
        for controller in viewControllers {
          if controller.isKind(of: ViewCartController.self) {
            self.navigationController?.popToViewController(controller, animated: true)
            return
          }
        }

      if let rootViewController = R.storyboard.main().instantiateInitialViewController() as? UINavigationController {
        if let vc = R.storyboard.main.chooseDeliveryController() {
          if !rootViewController.viewControllers.contains(vc) {
            rootViewController.viewControllers.removeAll()
            rootViewController.viewControllers.append(vc)
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
          }
        }
       }
      }
  }

// MARK: - TextFielsDelegate

extension SignInController: UITextFieldDelegate {
      func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          self.btnForgotPwd.isHidden = false
          if textField == txtPwd {
              btnShow.isHidden = false
          }
          return true
      }
      func textFieldDidEndEditing(_ textField: UITextField) {
          //        self.topSpaceEmail.constant = 236.0
      }
  }

  // MARK: - Google SignIn Delegate

extension SignInController: GIDSignInDelegate {
      func sign(_ signIn: GIDSignIn!,
                present viewController: UIViewController!) {
          self.present(viewController, animated: true, completion: nil)
      }
      func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
          self.dismiss(animated: true, completion: nil)
      }
      func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
          if error == nil {
              let name = user.profile.name.components(separatedBy: " ")
              var lastName = ""
              let firstName = name[0]
              if name.count > 1 {
                  lastName = name[1]
              }
              var image = ""
              if user.profile.hasImage {
                  let dimension = UInt(round(100 * UIScreen.main.scale))
                  image = user.profile.imageURL(withDimension: dimension).absoluteString
              }
              print(user.profile.email)
              let socialData = Social(firstName: firstName, lastName: lastName, email: user.profile.email, socialMode: .googleplus, socialId: user.userID, socialpicture: image, isTwitter: false )
              print(socialData)
              self.loginViaSocial(social: socialData)
          } else {
              UIAlertController.presentAlert(title: nil, message: error.localizedDescription, style: .alert).action(title: R.string.localizable.ok(), style: .default, handler: { (alert: UIAlertAction) in
              })
          }
      }
      func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
          UIAlertController.presentAlert(title: nil, message: error.localizedDescription, style: .alert).action(title: R.string.localizable.ok(), style: .default, handler: { (alert: UIAlertAction) in
          })
      }
  }

@available(iOS 13.0, *)
extension SignInController : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        let appleID = appleIDCredential.user
        var email = ""
        var fname = ""
        var lname = ""
        if appleIDCredential.email != nil {
            email = appleIDCredential.email!
        }
        if appleIDCredential.fullName?.givenName != nil {
            fname = appleIDCredential.fullName!.givenName!
        }
        if appleIDCredential.fullName?.familyName != nil {
            lname = appleIDCredential.fullName!.familyName!
        }
        
        let socialData = Social(firstName: fname, lastName: lname, email: email, socialMode: .apple, socialId: appleID, socialpicture: "", isTwitter: false )
        print(socialData)
        self.loginViaSocial(social: socialData)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("fail")
        UIAlertController.presentAlert(title: nil, message: error.localizedDescription, style: .alert).action(title: R.string.localizable.ok(), style: .default, handler: { (alert: UIAlertAction) in
        })
    }
}
@available(iOS 13.0, *)
extension SignInController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
