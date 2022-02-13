//
//  EditProfilecontroller.swift
//  FoodFox
//
//  Created by socomo on 10/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class EditProfileController: UIViewController {
    
    // MARK: - Variables
    fileprivate var userlat = CLLocationDegrees()
    fileprivate var userlong = CLLocationDegrees ()
    fileprivate var imgPicker: UIImagePickerController? = UIImagePickerController()
    fileprivate var isImageAdded: Bool = false
    fileprivate var validatorManager: CLValidatorManager = CLValidatorManager()
    fileprivate let me = Me()
    fileprivate let autocompleteController = GMSAutocompleteViewController()
    
    // MARK: - IBOutlets
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var firstname: CLTextField! {
        didSet {
            firstname.font = AppFont.regular(size: 19)
        }
    }
    @IBOutlet weak var lastname: CLTextField! {
        didSet {
            lastname.font = AppFont.regular(size: 19)
        }
    }
    @IBOutlet weak var emailid: CLTextField! {
        didSet {
            emailid.font = AppFont.regular(size: 19)
        }
    }
    @IBOutlet weak var mobileno: CLTextField! {
        didSet {
            mobileno.font = AppFont.regular(size: 19)
        }
    }
    @IBOutlet weak var userlocation: CLTextField! {
        didSet {
            userlocation.font = AppFont.regular(size: 19)
        }
    }
    @IBOutlet weak var changePassword: UIButton! {
        didSet {
        changePassword.titleLabel?.font = AppFont.semiBold(size: 19)
        }
    }
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
           navTitle.font = AppFont.semiBold(size: 19)
        }
    }
    @IBOutlet weak var saveBtn: UIButton! {
        didSet {
            saveBtn.titleLabel?.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var countryCodeBtn: UIButton! {
        didSet {
            countryCodeBtn.titleLabel?.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var changeAddress: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
     @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backgroundImageViewView: UIImageView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGesture()
        self.addValidationRules()
        self.setData()
        arrowButton.changeBackRedEditButton()
        self.profilepic.layer.cornerRadius = self.profilepic.frame.size.height/2
        self.userlocation.isUserInteractionEnabled = false
        if LoginManagerApi.share.me?.socialLogin == true {
            changePassword.isHidden = true
        }
        
        firstname.delegate = self
        lastname.delegate = self
        mobileno.delegate = self
        self.emailid.isUserInteractionEnabled = false
        
      changeAlignmentText()
      localizedString()
      backBtn.changeBackBlackButton()
    }
    
  func localizedString() {
    navTitle.text = "My Profile".localizedString
    changePassword.setTitle("CHANGE PASSWORD".localizedString, for: .normal)
    saveBtn.setTitle("SAVE".localizedString, for: .normal)
    userlocation.placeholder = "Click here and select Address".localizedString
  }
  
  func changeAlignmentText() {
    firstname.changeAlignment()
    lastname.changeAlignment()
    emailid.changeAlignment()
    mobileno.changeAlignment()
    userlocation.changeAlignment()
  }
  // MARK: Add Gesture Fucntion
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapedImageView))
        self.profilepic.isUserInteractionEnabled = true
        profilepic.addGestureRecognizer(tapGesture)
    }
  
  // MARK: Taped ImageView Notification
    @objc func tapedImageView() {
        imgPicker?.delegate = self
        if let image = imgPicker {
            getImage(picker: image)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        autocompleteController.delegate = self
        checkStatusForDarkMode()
    }
    
    //MARK:- CHECK STATUS OF DARK MODE
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)

            backgroundImageViewView.backgroundColor = lightBlackColor
            backBtn.setImage( #imageLiteral(resourceName: "back"), for: .normal)
            self.firstname.placeHolderColor = lightWhite
            self.lastname.placeHolderColor = lightWhite
            self.mobileno.placeHolderColor = lightWhite
            self.emailid.placeHolderColor = lightWhite
            self.userlocation.placeHolderColor = lightWhite
            self.firstname.textColor = lightWhite
            self.lastname.textColor = lightWhite
            self.mobileno.textColor = lightWhite
            self.emailid.textColor = lightWhite
            self.userlocation.textColor = lightWhite
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.countryCodeBtn.setTitleColor(lightWhite, for: .normal)
        } else {
            topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            backgroundImageViewView.backgroundColor = .white
            backBtn.setImage( #imageLiteral(resourceName: "ic_back"), for: .normal)
            self.firstname.placeHolderColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.lastname.placeHolderColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.mobileno.placeHolderColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.emailid.placeHolderColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.userlocation.placeHolderColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.firstname.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.lastname.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.mobileno.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.emailid.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.userlocation.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.countryCodeBtn.setTitleColor(#colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1), for: .normal)
        }
        
    }
    
    
    // MARK :- checking validation of all fields
    func addValidationRules() {
          let firstName = ResultHolder(idientifier: "firstName", behavior: .name,
                                     validationRuleSet: CLValidation.firstNameRuleSet,
                                     value: "", isOptional: false, validatorManager: self.validatorManager)
      firstname.placeholder = "FirstName".localizedString
        firstname.set(reusltHolder: firstName)
        
        let lastNameHolder = ResultHolder(idientifier: "LastName", behavior: .name,
                                          validationRuleSet: CLValidation.lastNameRuleSet,
                                          isOptional: true,
                                          validatorManager: self.validatorManager)
        lastname.placeholder = "LastName".localizedString
        lastname.set(reusltHolder: lastNameHolder)
        
        let  emailHolder = ResultHolder(idientifier: "email", behavior: .email,
                                        validationRuleSet: CLValidation.emailRulesSet,
                                        value: "",
                                        validatorManager: self.validatorManager)
        emailid.set(reusltHolder: emailHolder)
        
        
        let mobileHolder = ResultHolder(idientifier: "phoneNo",
                                        behavior: .phoneNumber,
                                        validationRuleSet: CLValidation.phoneRulesSet,
                                        isOptional: false,
                                        validatorManager: self.validatorManager)
        mobileno.set(reusltHolder: mobileHolder)
        mobileno.placeholder = "Phone number".localizedString
        
        mobileno.shouldChangeCharacterCondition(custom: { (field: CLTextField, range: NSRange, new: String) -> Bool in
            return true
        })
        
    }
  
  // MARK: Save to Data Model
    func saveDataToModel() {
        if let firstname = firstname.text {
            me.firstName = firstname
        }
        if let lastname = lastname.text {
            me.lastName = lastname
        }
        if let email = emailid.text {
            me.email = email
        }
        if let mobile = mobileno.text {
            me.mobile = mobile
        }
        if let address = userlocation.text {
            me.address = address
        }
        if let countryCode = countryCodeBtn.titleLabel?.text {
            me.diallingCode = countryCode
        }
    }
  
  // MARK: Set to Data Model
    func setData() {
        guard let me = LoginManagerApi.share.me else {
            return
        }
        self.firstname.text = me.firstName
        self.lastname.text = me.lastName
        self.emailid.text = me.email
        self.userlocation.text = me.address
        self.countryCodeBtn.setTitle(me.diallingCode, for: .normal)
        
        if LoginManagerApi.share.me?.socialLogin == true {
            if me.mobile != nil {
                self.mobileno.text = me.mobile
            }
        } else {
            if let mobileNo = me.mobile {
                if mobileNo != "" {
                    self.mobileno.text = "\(mobileNo)"
                }
            }
            
        }
        if let imageUrl = me.imageUrl {
            profilepic.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholder"))
            
        }
        
    }
  
  // MARK: Submit the Request to Server
    func submitRequest(parameters: [String: Any]) {
        var param: [String: Any] = [:]
        param["firstName"] = me.firstName
        if me.lastName != ""{
            param["LastName"] = me.lastName
        }
        param["email"] = me.email
        param["phoneNo"] = me.mobile
        if self.userlat != 0.0 {
        param["address"] = ["address": me.address ?? "", "locationLat": self.userlat, "locationLong": self.userlong]
        }
        param["countryCode"] = self.countryCodeBtn.titleLabel?.text
        
        var imageArray: [CLFile]? = nil
        if isImageAdded {
            if let image = self.profilepic.image {
                if let fileImage = image.pngData() {
                    let file = CLFile(data: fileImage, name: "profilePic", fileName: "profilePic", mimeType: "image/jpg")
                    imageArray = [CLFile]()
                    imageArray?.append(file)
                }
            }
        }
        print(param)
        LoginManagerApi.share.updateProfile(parameters: param, files: imageArray, password: "") { (object: Any?, error: Error?) in
            print("updateProfile Error \(String(describing: error))")
            if error != nil {
                return
            }
            UIAlertController.presentAlert(title: nil, message: "Profile updated successfully".localizedString, style: UIAlertController.Style.alert).action(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        
    }
  
  // MARK: Get Image from Camera or Gallery
    func getImage(picker: UIImagePickerController) {
        let alert = UIAlertController(title: "", message: "OPTIONS".localizedString, preferredStyle: .actionSheet)
        
        let type = ["Camera",
                    "Gallery"]
        
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
        let cancel = UIAlertAction(title: "Cancel".localizedString, style: .cancel) { (action) in }
        alert.addAction(cancel)
        self.present(alert, animated: true) { }
        
    }
    // MARK: ActionSheet
    
    func openGallary(picker: UIImagePickerController?) {
        if let imagePicker = picker {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
  
  // MARK: Open Camera to take Image
    func openCamera(picker: UIImagePickerController?) {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            if let imgpick = picker {
                imgpick.allowsEditing = true
                imgpick.sourceType = UIImagePickerController.SourceType.camera
                imgpick.cameraCaptureMode = .photo
                self.present(imgpick, animated: true, completion: nil)
            }
            
        } else {
            UIAlertController.presentAlert(title: nil, message: cameraAlert, style: UIAlertController.Style.alert).action(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            })
        }
    }

  // MARK: - UIActions
    @IBAction func actionSubmit(_ sender: Any) {
        self.validatorManager.startValidation(success: { (parame: [String: Any]) in
            self.saveDataToModel()
            self.submitRequest(parameters: parame)
            
        })
    }
    
    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
  
  // MARK: Change Password
    @IBAction func actionChangePassword(_ sender: Any) {
        
        if let viewcontroller = R.storyboard.main.resetPasswordController() {
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
  
    @IBAction func actionLocation(_ sender: Any) {
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//          UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields

//        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK: - Open Country Picker
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
}

// MARK: - TextField Delegate
extension EditProfileController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if let text = textField.text {
            let finalString = (text as NSString).replacingCharacters(in: range, with: string)
            if (textField.isMaxLenth() || finalString.hasSpace()) && string.length > 0 {
                return false
            }
        }
        guard let textFieldText = textField.text  else {
            return false
        }
        if (textField == lastname || textField == firstname) && textFieldText.count < 31 {
            return true
            
        } else if textField == mobileno && textFieldText.count < 10{
            return true
        } else {
            return false
        }
    }
}

// MARK: - AutoCompleteViewController Detegate
extension EditProfileController: GMSAutocompleteViewControllerDelegate {
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        userlong = place.coordinate.longitude
        if let address = place.formattedAddress {
            userlocation.text = address
        }
        userlat = place.coordinate.latitude
    }
}

// MARK: - ImagePickerController Delegate and NavigationController Delegate
extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            self.profilepic.contentMode = .scaleToFill
            self.profilepic.image = pickedImage
            isImageAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
}
