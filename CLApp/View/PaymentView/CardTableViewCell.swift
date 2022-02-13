//
//  CardTableViewCell.swift
//  FoodFox
//
//  Created by clicklabs on 04/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

 // MARK: Outlet
    
  @IBOutlet weak var checkBoxBtn: UIButton!
  @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardTypeName: UILabel! {
        didSet {
            cardTypeName.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var walletPrice: UILabel! {
        didSet {
            walletPrice.font = AppFont.semiBold(size: 18)
        }
    }
  @IBOutlet weak var bottomView: UIView!
  
  // MARK: Variables
  var checkBoxCallback: ((_ cell: CardTableViewCell) -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
    
      checkBoxBtn.setImage(UIImage(named: "radioRedOn"), for: .selected)
      checkBoxBtn.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
    }
  
  // MARK: Check button action
  @IBAction func checkBoxButtonClicked(_ sender: UIButton) {
    
//    guard let call = checkBoxCallback else {
//      return
//    }
//    call(self)
  }
  
}

// MARK: Enum for Payment Opetion Handing
enum PaymentType: String, CaseCountable {
  case cashOnDelivery = "1"
  case creditCard = "2"
  case sadad = "3"
  case wallet = "4"
    case noselect = "12345"
  
  var paymentName: String {
    switch self {
    case .wallet:
      return "App Wallet"
    case .creditCard:
      return "Card/Netbanking/upi"
    case .cashOnDelivery:
      return "Cash on Delivery"
    case .sadad:
      return "Mada"
    case .noselect:
        return "12345"
    }
  }
  
  var payemtKey: String {
    switch self {
    case .wallet:
      return "4"
    case .creditCard:
      return "2"
    case .cashOnDelivery:
      return "1"
    case .sadad:
      return "3"
    case .noselect:
        return "12345"
    }
  }
  
  var paymentImage: UIImage {
    switch self {
    case .wallet:
      return #imageLiteral(resourceName: "walletImage")
    case .creditCard:
      return #imageLiteral(resourceName: "paymentImage")
    case .cashOnDelivery:
      return  #imageLiteral(resourceName: "codImage")
    case .sadad:
      return #imageLiteral(resourceName: "mada")
    case .noselect:
        return #imageLiteral(resourceName: "mada")
    }
  }
  
  var checkEnum: Bool {
    switch self {
    case .wallet:
      return true
    case .creditCard:
      return true
    case .cashOnDelivery:
      return true
    case .sadad:
      return true
    case .noselect:
        return true
    }
  }
}

// MARK: Enum for Section Handing
enum PaymentSection: Int, CaseCountable {
  case payment
  case amount
  var headerString: String {
    switch self {
    case .payment:
      return "payment options"
    case .amount:
      return "Price Details"
    }
  }
}
