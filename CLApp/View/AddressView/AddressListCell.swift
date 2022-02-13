//
//  AddressListCell.swift
//  FoodFox
//
//  Created by Nishant Raj on 28/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {
  
    @IBOutlet weak var streetAddress: UILabel! {
        didSet {
            streetAddress.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var landMark: UILabel! {
        didSet {
            landMark.font = AppFont.light(size: 15)
        }
    }
    @IBOutlet weak var cityWithCode: UILabel! {
        didSet {
            cityWithCode.font = AppFont.light(size: 15)
        }
    }
    @IBOutlet weak var pinCode: UILabel! {
        didSet {
            pinCode.font = AppFont.light(size: 15)
        }
    }
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var topAddressTitleView: UIView!
    
    @IBOutlet weak var homeName: UILabel! {
        didSet {
            homeName.font = AppFont.semiBold(size: 13)
        }
    }
  @IBOutlet weak var homeImage: UIImageView!
  @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedAddress: ((Int) -> Void)?
    var deleteAddress: ((Int) -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }
  
  //MARK: Edit Button Clicked
  @IBAction func editButtonAction(_ sender: UIButton) {
    if let call = selectedAddress {
      call(sender.tag)
    }
  }
    
    //MARK: Delete Button Clicked
    @IBAction func deleteButtonAction(_ sender: UIButton){
        if let call = deleteAddress {
            call(sender.tag)
        }
    }
  
  //MARK: Update Cell
  func updateCell(address: AddressModel) {

    if let address = address.addresType, let type = ButtonSelected(rawValue: address) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            
            self.streetAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.landMark.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.cityWithCode.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
          
            
        } else {
            self.streetAddress.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.landMark.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            self.cityWithCode.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
         
        }
        
      self.homeName.text = type.statusString.localizedString
      self.homeImage.image = type.statusImage
    }
    
    if let street = address.address {
      self.streetAddress.text = street
    }
    if let landMark = address.landMark {
      self.landMark.text = landMark
    }
    if let city = address.city {
      self.cityWithCode.text = city
    }
    self.pinCode.text = ""
  }
  
}
