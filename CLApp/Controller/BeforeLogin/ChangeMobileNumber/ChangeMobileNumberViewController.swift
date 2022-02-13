//
//  ChangeMobileNumberViewController.swift
//  CLApp
//
//  Created by click Labs on 7/24/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class ChangeMobileNumberViewController: CLBaseViewController {
    
    // MARK: - Variables
    private var country: Country?
    var changeMobileNumberCallBack: ((_ country: Country) -> Void)?
    
    // MARK: - IBOutlets
    @IBOutlet weak var diallingLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var diallingCodeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: CLTextField!
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Change Mobile Number".localizedString
        self.textField.keyboardType = .numberPad
        let diallingCode = LoginManagerApi.share.me?.diallingCode ?? ""
        if let country = CountryManager.country(withDialling: diallingCode) {
            self.country = country
            diallingLabel.text = country.dialingCode()
            flagImageView.image = country.flag
        } else {
            self.country = CountryManager.currentCountry
        }
        textField.changeAlignment()
    }
  
    // MARK: - UIActions
    @IBAction func sendButtonClicked(_ sender: Any) {
        let mobile = self.textField.text ?? ""
        let diallingCode = self.country?.dialingCode() ?? ""
        
        LoginManagerApi.share.changeMobileNumber(diallingCode: diallingCode, mobile: mobile) { (object: Any?, error: Error?) in
            if error != nil {
                return
            }
            if let country = self.country {
                self.changeMobileNumberCallBack?(country)
            }
        }
    }
  
  // MARK: Dailling Code Button Clicked
    @IBAction func diallingCodeButtonClicked(_ sender: Any) {
        
        let controller = CLCountryPickerController.presentController(on: self) { (country: Country) in
            self.country = country
            self.diallingLabel.text = country.dialingCode()
            self.flagImageView.image = country.flag
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
