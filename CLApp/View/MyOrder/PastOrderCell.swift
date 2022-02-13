//
//  PastOrderCell.swift
//  FoodFox
//
//  Created by clicklabs on 11/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class PastOrderCell: UITableViewCell {
  
  // MARK: Outlet
    @IBOutlet weak var orderId: UILabel! {
        didSet {
            orderId.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var bookingTime: UILabel! {
        didSet {
            bookingTime.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var firstAddress: UILabel! {
        didSet {
            firstAddress.font = AppFont.semiBold(size: 16)
        }
    }
    @IBOutlet weak var secondAddress: UILabel! {
        didSet {
            secondAddress.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var rateLabel: UILabel! {
        didSet {
            rateLabel.font = AppFont.semiBold(size: 16)
        }
    }
  @IBOutlet weak var rateFirst: UIImageView!
  @IBOutlet weak var rateSecond: UIImageView!
  @IBOutlet weak var rateThird: UIImageView!
  @IBOutlet weak var rateFourth: UIImageView!
  @IBOutlet weak var rateFifth: UIImageView!
    @IBOutlet weak var viewOrder: UIButton! {
        didSet {
            viewOrder.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
  
  // MARK: Variables
  var viewOrderCallBack: ((_ tag: Int) -> Void)?
  
  override func awakeFromNib() {
    viewOrder.setTitle("VIEW DETAILS".localizedString, for: .normal)
  }
  
  
  // MARK: Order Button clicked
  @IBAction func viewOrderClicked(_ sender: UIButton) {
    guard let call = viewOrderCallBack else {
      return
    }
    call(sender.tag)
  }
  
  // MAKR: Update Cell
  func updateCell(data: OrderModel) {
    if let id = data.oderId, let price = data.totalAmount {
    let sar = "Rs.".localizedString
    priceLabel.text = "\(sar) \(price.roundTo2Decimal())"
    orderId.text = "#\(id)"
    }
    if let time = data.bookingTime {
    bookingTime.text = dateFormatted1(date: time)
    }
    
//    let value = data.addressType ?? 1
//    guard let type = AddressStatus(rawValue: value) else {
//      fatalError()
//    }
    
    if let address = data.address, address != "" {
//      firstAddress.text = type.statusType.localizedString
      secondAddress.text = address
    } else {
      firstAddress.text = data.branchName ?? ""
//      secondAddress.text = data.branchAddress ?? ""
    }
    
    firstAddress.text = data.restaurantName
  
    switch data.tookanStatus ?? 0 {
    case Status.completed.rawValue:
      if data.rating == 0 {
        let deliver = "Delivered".localizedString
        rateLabel.text = "  \(deliver)  "
      } else {
        let rate = "Delivered & Rated".localizedString
        rateLabel.text = "  \(rate)  "
      }
      rateLabel.backgroundColor = lightGreen
    case Status.cancel.rawValue:
      if data.orderStatus == 15 {
      let fail = "DRIVER REJECTED".localizedString
      rateLabel.text = "  \(fail)  "
      rateLabel.backgroundColor = darkPinkColor
      } else if data.orderStatus == 12{
        let paymentFail = "PAYMENT FAILED".localizedString
        rateLabel.text = "  \(paymentFail)  "
        rateLabel.backgroundColor = darkGrayColor
      }else {
        let cancel = "CANCELLED".localizedString
        rateLabel.text = "  \(cancel)  "
        rateLabel.backgroundColor = darkPinkColor
      }
      case Status.failed.rawValue:
        if data.orderStatus == 12 {
            let paymentFail = "PAYMENT FAILED".localizedString
            rateLabel.text = "  \(paymentFail)  "
            rateLabel.backgroundColor = darkGrayColor

        }
    default:
      print("Wrong Selection")
    }
    

    for iVar in 0...data.stars {
        switch iVar {
        case 1:
          rateFirst.image = #imageLiteral(resourceName: "selectedRate")
        case 2:
          rateSecond.image = #imageLiteral(resourceName: "selectedRate")
        case 3:
          rateThird.image = #imageLiteral(resourceName: "selectedRate")
        case 4:
          rateFourth.image = #imageLiteral(resourceName: "selectedRate")
        case 5:
          rateFifth.image = #imageLiteral(resourceName: "selectedRate")
        default:
          break
        }
      }
    
  }
}
