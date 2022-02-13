  //
  //  ContactSupportController.swift
  //  FoodFox
  //
  //  Created by clicklabs on 03/01/18.
  //  Copyright © 2018 Click-Labs. All rights reserved.
  //

  import UIKit

  class ContactSupportController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
         navTitle.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var nameTextField: CLTextField! {
        didSet {
            nameTextField.font = AppFont.semiBold(size: 15)
            nameTextField.changeAlignment()
        }
    }
    @IBOutlet weak var emailTextField: CLTextField! {
        didSet {
            emailTextField.font = AppFont.semiBold(size: 15)
            emailTextField.changeAlignment()
        }
    }
    @IBOutlet weak var queryTextView: UITextView! {
        didSet {
            queryTextView.font = AppFont.regular(size: 15)
             queryTextView.changeTextViewAlignment()
            
        }
    }
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var selectSubjectText: UITextField! {
        didSet {
            selectSubjectText.font = AppFont.regular(size: 15)
            selectSubjectText.changeAlignment()
        }
    }
    @IBOutlet weak var backBtn: UIButton!

    //MARK: Variables
    fileprivate var validatorManager: CLValidatorManager = CLValidatorManager()
    var subjectPicker: UIPickerView = UIPickerView()
    var subjectList: [ContactModel] = []
    var selectedIndex = -1
    
    //MARK: View Did Load
    override func viewDidLoad() {
      super.viewDidLoad()
      localizedString()
      addRules()
      getSubjectList()
      setUpPicker()
      backBtn.changeBackBlackButton()
    }
    
    //MARK: Setup Picker Delegate
    func setUpPicker() {
      queryTextView.delegate = self
      subjectPicker.delegate = self
      subjectPicker.dataSource = self
      selectSubjectText.inputView = subjectPicker
    }
    
    //MARK: Localized String File
    func localizedString() {
      navTitle.text = "Contact Us".localizedString
      nameTextField.placeholder = "Enter Name".localizedString
     emailTextField.placeholder = "Enter Email".localizedString
      selectSubjectText.placeholder = "Select Subject".localizedString
      queryTextView.text = "Write Query...".localizedString
      queryTextView.textColor = headerColor
      submitButton.setTitle("SUBMIT".localizedString, for: .normal)
    }
    
    //MARK: Submit Query
    @IBAction func submitButtonAction(_ sender: UIButton) {
      validatorManager.startValidation(success: { (param: [String: Any]) in
        self.submitQuery(param: param)
      })
    }
    
    //MARK: Validator Manager
    /// - added Validation with Name
    /// - added Validation with email
    func addRules() {
      let nameHolder = ResultHolder(idientifier: "name",
                                     behavior: .name,
                                     validationRuleSet: CLValidation.firstNameRuleSet,
                                     value: self.nameTextField.text ?? "",
                                     isOptional: false,
                                     validatorManager: self.validatorManager)
      nameTextField.set(reusltHolder: nameHolder)
      
      let password = ResultHolder(idientifier: "email",
                                  behavior: .email,
                                  validationRuleSet: CLValidation.emailRulesSet,
                                  value: self.emailTextField.text ?? "",
                                  isOptional: false,
                                  validatorManager: self.validatorManager)
      emailTextField.set(reusltHolder: password)
    }
    
    //MARK: Server Call For Subject List
    /// - Getting Subject list from server
    func getSubjectList() {
      ContactModel.subjectList(callBack: { (list: [ContactModel]?, error: Error?) in
        if error != nil {
         return
        }
        if let listData = list {
          self.subjectList = listData
        }
      })
    }
    
    //MARK: Show Alert
    func alertFunction(message: String) {
      customAlert(controller: self, message: message)
    }
    
    //MARK: Submit Query
    /// - Submit Query to the server
    func submitQuery(param: [String: Any]) {
      var parameter: [String: Any] = [:]
      parameter = param
      
      if selectSubjectText.text == "" {
        alertFunction(message: "Please Select Subject".localizedString)
        return
      }
      
      if queryTextView.text == "Write Query...".localizedString || queryTextView.text == "" {
       alertFunction(message: "Please Enter feedback".localizedString)
       return
      }
      if selectedIndex == -1 {
        return
      }
      parameter["subjectId"] = subjectList[selectedIndex].subjectId ?? ""
      parameter["subject"] = selectSubjectText.text
      parameter["message"] = queryTextView.text
      ContactModel.contactUs(param: parameter, callBack: { (response: [String: Any]?, error: Error?) in
        if error == nil {
            let alert = UIAlertController(title: "", message: "Your query successfully submitted".localizedString, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
          }))
          self.present(alert, animated: true, completion: nil)
        }
       })
    }
    
    //MARK: Back Button Action
    @IBAction func backButton(_ sender: UIButton) {
     self.navigationController?.popViewController(animated: true)
    }
  }

  //MARK: UITextView Delegate
  extension ContactSupportController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.text == "Write Query...".localizedString {
      textView.text = ""
        queryTextView.textColor = lightBlackColor
      }
    }
    //textViewDidEnd Editing
    func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text == "" {
        textView.text = "Write Query...".localizedString
        queryTextView.textColor = headerColor
      }
    }
    
  }

  //MARK: UIPIckerView Delegate and Data Source
  ///- numberOfComponents
  /// -numberOfRowsInComponent
  /// -inComponent
  extension ContactSupportController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return subjectList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return subjectList[row].subject ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      selectSubjectText.text = subjectList[row].subject ?? ""
      selectedIndex = row
    }

  }
