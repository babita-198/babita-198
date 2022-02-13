//
//  PriceDetailsTableView.swift
//  FoodFox
//
//  Created by socomo on 16/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class PriceDetailsTableView: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblNumberOfItems: UILabel! {
        didSet {
            lblNumberOfItems.font = AppFont.light(size: 20)
        }
    }
    @IBOutlet weak var lblVatPrice: UILabel! {
        didSet {
            lblVatPrice.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var lblItemsPrice: UILabel! {
        didSet {
            lblItemsPrice.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var lblTotalAmount: UILabel! {
        didSet {
            lblTotalAmount.font = AppFont.semiBold(size: 21)
        }
    }
    @IBOutlet weak var extraInfoTextField: UITextField! {
        didSet {
            extraInfoTextField.font = AppFont.light(size: 19)
        }
    }
    @IBOutlet weak var totalAmountTitle: UILabel! {
        didSet {
            totalAmountTitle.font = AppFont.light(size: 19)
        }
    }
    @IBOutlet weak var vatTitle: UILabel! {
        didSet {
            vatTitle.font = AppFont.light(size: 19)
        }
    }
    @IBOutlet weak var applyCoupon: UILabel! {
        didSet {
            applyCoupon.font = AppFont.light(size: 20)
        }
    }
    @IBOutlet weak var statusModeTitle: UILabel! {
        didSet {
            statusModeTitle.font = AppFont.light(size: 20)
        }
    }
    @IBOutlet weak var statusMode: UILabel! {
        didSet {
            statusMode.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var deliveryChargePrice: UILabel! {
        didSet {
            deliveryChargePrice.font = AppFont.semiBold(size: 21)
        }
    }
    @IBOutlet weak var deliveryChargeTitle: UILabel! {
        didSet {
            deliveryChargeTitle.font = AppFont.light(size: 20)
        }
    }
    @IBOutlet weak var applyPromo: UIButton! {
        didSet {
            applyPromo.titleLabel?.font = AppFont.semiBold(size: 21)
        }
    }
    @IBOutlet weak var cancleTitle: UILabel! {
        didSet {
            cancleTitle.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var lblCanclePrice: UILabel! {
        didSet {
            lblCanclePrice.font = AppFont.semiBold(size: 19)
        }
    }
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var priceDetailsView: UIView!
    @IBOutlet weak var allergiticView: UIView!
    @IBOutlet weak var promoDiscountLbl: UILabel! {
        didSet {
            promoDiscountLbl.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var promoDiscount: UILabel! {
        didSet {
            promoDiscount.font = AppFont.semiBold(size: 22)
        }
    }
  
  //MARK: Variables
  var applyPromoCallBack: (() -> Void)?
    var extraTextField: ((_ text: String) -> Void)?
  
  override func awakeFromNib() {
        super.awakeFromNib()
       localizedString()
    
    extraInfoTextField.delegate = self
    }
  
  //MARK: Apply PromoCode
    @IBAction func applyPromoCode(_ sender: UIButton) {
      if let call = applyPromoCallBack {
        call()
      }
    }
  
  //MARK: Localized Strings
  func localizedString() {
    extraInfoTextField.changeAlignment()
    //vatTitle.text = "VAT".localizedString
    totalAmountTitle.text = "Total Amount".localizedString
    promoDiscountLbl.text = "Discount".localizedString
    applyCoupon.text = "Coupon Discount".localizedString
    statusModeTitle.text = "Delivery Mode".localizedString
    applyPromo.setTitle("APPLY".localizedString, for: .normal)
   // extraInfoTextField.placeholder = restrantFetchData[ind].addNotMessage
    deliveryChargeTitle.text = "Delivery Charges".localizedString
  }
    
//  func setupAmmountCell(amountDetails: MenuDetails) {
//    extraInfoTextField.placeholder = amountDetails.addNotMessage
//  }
  
  
  //MARK: Update cell for Order Detail Controller
  func updateCell(data: OrderModel) {
    let sar = "Rs.".localizedString

    
    deliveryChargePrice.isHidden  = true
    //deliveryChargeTitle.text = "VAT".localizedString
   // deliveryChargePrice.text = "\(data.vat?.roundTo2Decimal() ?? "0.0") \(sar)"
    deliveryChargeTitle.isHidden = true
    deliveryChargePrice.isHidden = true
    var totalQuanity = 0
    for each in data.item {
        totalQuanity += each.totalQuantity
    }
    let items = "items".localizedString
    self.lblNumberOfItems.text = "\(totalQuanity) \(items)"
    if let totalPrice = data.totalPaidAmount {
      self.lblTotalAmount.text = "\(sar) \(totalPrice.roundTo2Decimal())"
      self.totalAmountTitle.text = "Total Amount".localizedString
        
    }
    var totalAmount = 0.0
    for each in data.item {
        totalAmount += each.totalPrice
    }
    self.lblItemsPrice.text = "\(sar) \(totalAmount.roundTo2Decimal())"
    self.statusModeTitle.text = "Delivery Mode".localizedString
    if let type = data.bookingStatusType, type == 2 {
    self.statusMode.text = "Home Delivery".localizedString
    self.applyCoupon.text = "Delivery Charges".localizedString
    let deliveryPrice = data.deliveryChange ?? 0.0
    self.applyPromo.setTitle("\(sar) \(deliveryPrice.roundTo2Decimal())", for: .normal)
    self.applyPromo.setTitleColor(headerColor, for: .normal)
    self.applyPromo.borderColor = .clear
    self.applyCoupon.isHidden = false
    self.applyPromo.isHidden = false
    } else {
    self.applyCoupon.isHidden = true
    self.applyPromo.isHidden = true
    self.statusMode.text = "Take Away".localizedString
    }
    if let discount = data.discountPrice, discount != 0.0 {
      self.promoDiscountLbl.isHidden = false
      self.promoDiscount.isHidden = false
      self.promoDiscountLbl.text = "Discount".localizedString
      self.promoDiscount.text = "- \(sar) \(discount.roundTo2Decimal())"
    } else {
     self.promoDiscountLbl.isHidden = true
     self.promoDiscount.isHidden = true
    }
   // self.vatTitle.text = "Payment Mode".localizedString
    //let type = paymentType(status: data.paymentStatus ?? 0)
    self.lblVatPrice.text = "\(sar) \(data.tax ?? 0.0)"
    self.extraInfoTextField.isHidden = true
  }
    
}

extension PriceDetailsTableView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let call = extraTextField {
            call(textField.text ?? "")
        }
    }
}
