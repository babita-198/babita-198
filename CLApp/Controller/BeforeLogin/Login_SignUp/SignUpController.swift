
//
//  SignUpController.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 19/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import FRHyperLabel

class SignUpController: UIViewController {
    
    // MARK: - IBOutlet
    
    
    @IBOutlet weak var tosLbl: FRHyperLabel! {
        didSet {
            tosLbl.font = AppFont.regular(size: 13)
        }
     }
    
   
    @IBOutlet weak var lblSignUp: UILabel! {
        didSet {
            lblSignUp.font = AppFont.semiBold(size: 26)
        }
    }
    
    @IBOutlet weak var mainView: UIView!
     @IBOutlet weak var userNameView: UIView!
     @IBOutlet weak var emailView: UIView!
     @IBOutlet weak var mobileNumView: UIView!
     @IBOutlet weak var passwordView: UIView!
     @IBOutlet weak var scrollIndView: UIScrollView!
     @IBOutlet weak var confirmPasswordView: UIView!
     @IBOutlet weak var btnCountryCode: UIButton!
     @IBOutlet weak var txtFirstName: CLTextField! {
        didSet {
            txtFirstName.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var txtLastName: CLTextField! {
        didSet {
            txtLastName.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var txtEmail: CLTextField! {
        didSet {
            txtEmail.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var txtPhone: CLTextField! {
        didSet {
            txtPhone.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var txtConfirmPwd: CLTextField! {
        didSet {
            txtConfirmPwd.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var txtPwd: CLTextField! {
        didSet {
            txtPwd.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var btnSignUp: UIButton! {
        didSet {
            btnSignUp.titleLabel?.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var applyReferral: CLTextField! {
        didSet {
            applyReferral.font = AppFont.light(size: 18)
        }
    }
  
  // MARK: - Variables
    var signUpViaSocial: Bool?
    fileprivate let me = Me()
    fileprivate var imgPicker: UIImagePickerController? = UIImagePickerController()
    fileprivate var isImageAdded: Bool = false
    var firstName = ""
    var lastName = ""
    var email = ""
    var profilepic = ""
    var socialId = ""
    var socialMode = ""
    
    // Height Constraints
    var socialValidationManager: CLValidatorManager = CLValidatorManager()
    var emailValidationManager: CLValidatorManager = CLValidatorManager()
    
    var validatorManager: CLValidatorManager {
        return signUpViaSocial == false ? emailValidationManager : socialValidationManager
    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defalutSettings()
        if self.signUpViaSocial == true {
            self.passwordView.isHidden = true
            self.confirmPasswordView.isHidden = true
            if validatorManager.removeHolder(forIdientifier: "password") && validatorManager.removeHolder(forIdientifier: "confirmPassword") {
                print("removed Holder")
            }
        }
        self.txtFirstName.text = firstName
        self.txtLastName.text = lastName
        if email.isEmpty == false {
            self.txtEmail.text = email
        }
        if let url = URL(string: profilepic) {
            self.imgProfile.kf.setImage(with: url)
        }
        btnCancel.changeBackWhiteButton()
        changeAlignmentText()
    }
    
  func changeAlignmentText() {
    txtFirstName.changeAlignment()
    txtEmail.changeAlignment()
    txtPwd.changeAlignment()
    txtConfirmPwd.changeAlignment()
    txtPhone.changeAlignment()
    txtLastName.changeAlignment()
    applyReferral.changeAlignment()
  }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //sizeHeaderToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     // lblTos.text = "By Signing up you agree to our Terms of Service & that you have read our Privacy Policy".localizedString
      lblSignUp.text = "Sign up".localizedString
      btnSignUp.setTitle("SIGN UP".localizedString, for: .normal)
        
        checkStatusForDarkMode()
    }
  
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.view.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.mainView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.emailView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.scrollIndView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.userNameView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.passwordView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.mobileNumView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.confirmPasswordView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.txtFirstName.placeHolderColor = lightWhite
            self.txtLastName.placeHolderColor = lightWhite
            self.txtEmail.placeHolderColor = lightWhite
            txtPhone.placeHolderColor = lightWhite
            txtConfirmPwd.placeHolderColor = lightWhite
            txtPwd.placeHolderColor = lightWhite
            self.txtFirstName.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.txtLastName.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.txtEmail.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            txtPhone.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            txtConfirmPwd.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            txtPwd.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.applyReferral.placeHolderColor = lightWhite
            self.applyReferral.textColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.btnCountryCode.setTitleColor(#colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1), for: .normal)
            
            
        } else {
            self.view.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.mainView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.emailView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.scrollIndView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.userNameView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.passwordView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.mobileNumView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.confirmPasswordView.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
            self.txtFirstName.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.txtLastName.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.txtEmail.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            txtPhone.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            txtConfirmPwd.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            txtPwd.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.txtFirstName.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.txtLastName.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.txtEmail.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            txtPhone.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            txtConfirmPwd.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            txtPwd.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.applyReferral.placeHolderColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.applyReferral.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.btnCountryCode.setTitleColor(#colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1), for: .normal)
        }
        
    }
    
  @objc func moveToOTPVC() {
    if let otpVC = R.storyboard.main.oTPViewController() {
      otpVC.isFromSignUp = true
      self.navigationController?.pushViewController(otpVC, animated: true)
    }
  }
  
    //MARK:- Methods
    func defalutSettings() {
        self.addValidationRules()
        self.addGesture()
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
        termsTapped()
       // setUnderLine()
    }
  
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapedImageView))
        self.imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapedImageView() {
        imgPicker?.delegate = self
        if let imagepicker = imgPicker {
            getImage(picker: imagepicker)
        }
    }
    
    func termsTapped() {
        let text = "By Signing up you agree to our Terms of Service & that you have read our Privacy Policy".localizedString
        let tos = "Terms of Service".localizedString
        let pp = "Privacy Policy".localizedString
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            let attributes = [NSAttributedString.Key.foregroundColor: lightWhite,
                              NSAttributedString.Key.font: AppFont.regular(size: 14)]
             tosLbl.attributedText = NSAttributedString(string: text, attributes: attributes)
        } else {
            let attributes = [NSAttributedString.Key.foregroundColor: lightBlackColor,
                              NSAttributedString.Key.font: AppFont.regular(size: 14)]
             tosLbl.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            print(substring ?? "")
            if tos == substring?.localizedString {
                self.openTermAndCondition(title: tos)
            } else if pp == substring?.localizedString {
                self.openTermAndCondition(title: pp)
            }
        }
        tosLbl.setLinksForSubstrings([pp, tos], withLinkHandler: handler)
    }

    
    //MARK: Open Term and Condition on clicked link
    func openTermAndCondition(title: String) {
        let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.contactSupport) as? ContactSupportViewController else {
            return
        }
        let tos = "Terms of Service".localizedString
        let pp = "Privacy Policy".localizedString
        if tos == title {
            vc.urlString = Info.tc.infoUrl
        } else if pp == title {
            vc.urlString = ppURL
        }
        vc.navString = title
        self.navigationController?.pushViewController(vc, animated: true)
    }

  // MARK: - Add Validation Rules
    func addValidationRules() {
        let firstName = ResultHolder(idientifier: "firstName", behavior: .name,
                                     validationRuleSet: CLValidation.firstNameRuleSet,
                                     value: "", isOptional: false, validatorManager: self.validatorManager)
        txtFirstName.set(reusltHolder: firstName)
        txtFirstName.placeholder = "First name".localizedString
      
      let promoCode = ResultHolder(idientifier: "customerReferralCode", behavior: .default,
                                   validationRuleSet: CLValidation.blankRulesSet,
                                   value: "", isOptional: true, validatorManager: self.validatorManager)
      applyReferral.set(reusltHolder: promoCode)
      applyReferral.placeholder = "Referral Code (Optional)".localizedString
      applyReferral.autocapitalizationType = .allCharacters
      
      let lastNameHolder = ResultHolder(idientifier: "LastName",
                                          behavior: .name,
                                          validationRuleSet: CLValidation.lastNameRuleSet,
                                          value: "",
                                          isOptional: false,
                                          validatorManager: self.validatorManager)
        
        txtLastName.set(reusltHolder: lastNameHolder)
        txtLastName.placeholder = "Last name".localizedString
        
        let  emailHolder = ResultHolder(idientifier: "email", behavior: .email,
                                        validationRuleSet: CLValidation.emailRulesSet,
                                        validatorManager: self.validatorManager)
        txtEmail.set(reusltHolder: emailHolder)
        txtEmail.placeholder = "Email".localizedString
        
      
        let mobileHolder = ResultHolder(idientifier: "phoneNo",
                                        behavior: .phoneNumber,
                                        validationRuleSet: CLValidation.phoneRulesSet,
                                        isOptional: false,
                                        validatorManager: self.validatorManager)
       
        txtPhone.set(reusltHolder: mobileHolder)
        txtPhone.placeholder = "Phone number".localizedString
        txtPhone.isUserInteractionEnabled = true
        txtPhone.shouldChangeCharacterCondition(custom: { (field: CLTextField, range: NSRange, new: String) -> Bool in
            if new.length < 10{
                self.txtPhone.set(reusltHolder: mobileHolder)
            }
            return true

        })
//
        
        if self.signUpViaSocial == true {
            let passwordHolder = ResultHolder(idientifier: "password",
                                              behavior: .password,
                                              validationRuleSet: CLValidation.passwordRulesSet,
                                              isOptional: true,
                                              validatorManager: self.validatorManager)
            txtPwd.set(reusltHolder: passwordHolder)
            txtPwd.shouldChangeCharacterCondition(custom: { (field: CLTextField, range: NSRange, new: String) -> Bool in
                if new.length < 6{
                    self.txtPwd.set(reusltHolder: passwordHolder)
                }
                return true

            })
        } else {
            let passwordHolder = ResultHolder(idientifier: "password",
                                              behavior: .password,
                                              validationRuleSet: CLValidation.passwordRulesSet,
                                              validatorManager: self.validatorManager)
            txtPwd.set(reusltHolder: passwordHolder)
            txtPwd.shouldChangeCharacterCondition(custom: { (field: CLTextField, range: NSRange, new: String) -> Bool in
                if new.length < 6{
                    self.txtPwd.set(reusltHolder: passwordHolder)
                }
                return true

            })
        }
        
        txtPwd.placeholder = "Password (6 Digit Password)".localizedString
        txtPwd.keyboardType = .numberPad
        
        if self.signUpViaSocial == true {
            let confirmPassword = ResultHolder(idientifier: "confirmPassword",
                                               behavior: .password,
                                               validationRuleSet: CLValidation.ruleNotBlank("ErrorConfirmPassword"),
                                               value: "", isOptional: true, validatorManager: self.validatorManager)
            
            txtConfirmPwd.set(reusltHolder: confirmPassword)
        } else {
            let confirmPassword = ResultHolder(idientifier: "confirmPassword",
                                               behavior: .password, validationRuleSet: CLValidation.ruleNotBlank("ErrorConfirmPassword"),
                                               value: "", isOptional: false, validatorManager: self.validatorManager)
            txtConfirmPwd.set(reusltHolder: confirmPassword)
        }
        
        txtConfirmPwd.keyboardType = .numberPad
        txtConfirmPwd.placeholder = "Confirm Password (6 Digit Password)".localizedString
    }
   

  // MARK: - Api of SignUp
    func submitRequest(parameters: [String: Any]) {
      
      var tokan = "iOSToken"
      if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
        tokan = deviceToken
      }
      
        var param: [String: Any] = [:]
        param["deviceType"] = deviceType
        param["deviceToken"] = tokan
        param["countryCode"] = self.btnCountryCode.titleLabel?.text
        param["appVersion"] = "\(appVersionValue)"
        
        if self.signUpViaSocial == true {
            param["socialId"] = self.socialId
            param["socialMode"] = self.socialMode
           // param["SocialProfilePic"] = self.profilepic
        }
        param["latitude"] = LocationTracker.shared.currentLocationLatitude
        param["longitude"] = LocationTracker.shared.currentLocationLongitude
        param.appendDictionary(other: parameters)
        param.removeValue(forKey: "confirmPassword")
        
        var imageArray: [CLFile]? = nil
        if isImageAdded {
            if let image = self.imgProfile.image {
                if let fileImage = image.pngData() {
                    let file = CLFile(data: fileImage, name: "profilePic", fileName: "profilePic", mimeType: "image/jpeg")
                    imageArray = [CLFile]()
                    imageArray?.append(file)
                }
            }
        }
        
        print("sign up params \(String(describing: imageArray))")
        print("sign up params \(param)")
        LoginManagerApi.share.signup(parameters: param, files: imageArray, password: "") { (object: Any?, error: Error?) in
            print("sign up Error \(String(describing: error))")
            if  error != nil {
                return
            }
        }
    }
    
    //MARK:- UIActions
    @IBAction func actionCancel(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        self.validatorManager.startValidation(success: { (parame: [String: Any]) in
            if self.txtPwd.stringMatched(txtField: self.txtConfirmPwd) {
                
                self.submitRequest(parameters: parame)
            }
        })
    }
    
    @IBAction func diallingCodeButtonClicked(_ sender: Any) {
        
        let controller = CLCountryPickerController.presentController(on: self) { (country: Country) in
            self.btnCountryCode.setTitle(country.dialingCode(), for: .normal)
        }
        controller.tintColor = AppColor.themePrimaryColor
        controller.isHideFlagImage = false
        controller.isHideDiallingCode = false
        controller.separatorLineColor = UIColor.lightGray.withAlphaComponent(0.5)
        controller.labelColor = AppColor.themePrimaryColor
        controller.labelFont = AppFont.regular(size: 16)
        controller.detailColor = AppColor.themeSecondaryColor
    }
    
    // MARK: - Get Image
    
    func getImage(picker: UIImagePickerController) {
        
        let alert = UIAlertController(title: "", message: "OPTIONS".localized, preferredStyle: .actionSheet)
        
        let type = ["Camera".localized,
                    "Gallery".localized]
        
        
        for index in 0..<type.count {
            let button = UIAlertAction(title: type[index], style: .default, handler: { (action) in
                if index == 0 {
                    
                    self.openCamera(picker: picker)
                } else {
                    
                    self.openGallary(picker: picker)
                }
                
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in }
        alert.addAction(cancel)
        self.present(alert, animated: true) { }
        
    }
    
    // MARK: ActionSheet
    
    func openGallary(picker: UIImagePickerController?) {
        if let imgPicker = picker {
            imgPicker.allowsEditing = true
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            self.present(imgPicker, animated: true, completion: nil)
        }
        
    }
    
    func openCamera(picker: UIImagePickerController?) {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            if let imgpicker = picker {
                imgpicker.allowsEditing = true
                imgpicker.sourceType = UIImagePickerController.SourceType.camera
                imgpicker.cameraCaptureMode = .photo
                self.present(imgpicker, animated: true, completion: nil)
            }
            
        } else {
            UIAlertController.presentAlert(title: nil, message: "AlertNoCamera".localized, style: UIAlertController.Style.alert).action(title: "Ok".localized, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            })
            
        }
    }
    
}
// MARK: - ImagePickerControllerDelegate and NavigationControllerDelegate
extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            self.imgProfile.contentMode = .scaleToFill
            self.imgProfile.image = pickedImage
            isImageAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextFieldDelegate
extension SignUpController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let finalString = (text as NSString).replacingCharacters(in: range, with: string)
            print(textField.isMaxLenth())
            print(finalString.hasSpace())
            print(string.length)
            if (textField.isMaxLenth() || finalString.hasSpace()) && string.length > 0 {
                return false
            }
        }
        if (textField == txtLastName || textField == txtFirstName) && string.length > 0 {
            //let badCharacters = NSCharacterSet.letters.inverted
            //string.rangeOfCharacter(from: badCharacters)
            if string != " " {
                return true
            } else {
                return false
            }
        }
        
        if textField == txtPhone && !textField.isValidMobileLenth() && string.length > 0 {
             
            return false
        }
        if textField == txtPwd && !textField.isValidPasswordLenth() && string.length > 0 {
             
            return false
        }
        if textField == txtConfirmPwd && !textField.isValidPasswordLenth() && string.length > 0 {
             
            return false
        }
        
        return true
    }
    
    
}
