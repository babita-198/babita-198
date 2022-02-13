//
//  AddressTextCell.swift
//  FoodFox
//
//  Created by clicklabs on 30/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class AddressTextCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var addressTitle: UILabel! {
        didSet {
            addressTitle.font = AppFont.light(size: 14)
        }
    }
    @IBOutlet weak var addressTextField: UITextField! {
        didSet {
            addressTextField.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var landMarkTitle: UILabel! {
        didSet {
            landMarkTitle.font = AppFont.light(size: 14)
        }
    }
    @IBOutlet weak var landmarkTextField: UITextField! {
        didSet {
            landmarkTextField.font = AppFont.semiBold(size: 14)
        }
    }
  @IBOutlet weak var addressBottomView: UIView!
  @IBOutlet weak var landmarkBottomView: UIView!
  
  var textFieldCallBack: ((String) -> Void)?
   var textFieldAddressCallBack: ((String) -> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localized()
      landmarkTextField.delegate = self
      addressTextField.delegate = self
      addressTextField.changeAlignment()
      landmarkTextField.changeAlignment()
   }
  
  
  // MARK: Localized AddressTextCell String
  func localized() {
    addressTitle.text = "Address".localizedString
    landMarkTitle.text = "Landmark (Optional)".localizedString
  }
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if addressTextField == textField {
      if let callBack = textFieldAddressCallBack, let text = textField.text {
        callBack(text)
      }
    } else {
    if let callBack = textFieldCallBack, let text = textField.text {
       callBack(text)
    }
    }
  }
  
}
