//
//  OrderListCellTableViewCell.swift
//  FoodFox
//
//  Created by clicklabs on 06/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

enum OrderType {
  case upcoming
  case past
}


class OrderListCellTableViewCell: UITableViewCell {
    
  
    @IBOutlet var heightLblPaymentProcess: NSLayoutConstraint!
    @IBOutlet var lblPaymentProcess: UILabel!
    @IBOutlet weak var priceText: UILabel! {
        didSet {
            priceText.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var cancelOrder: UIButton! {
        didSet {
            cancelOrder.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var viewOrder: UIButton! {
        didSet {
            viewOrder.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var firstAddress: UILabel! {
        didSet {
            firstAddress.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var secondAddress: UILabel! {
        didSet {
            secondAddress.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var idLabel: UILabel! {
        didSet {
            idLabel.font = AppFont.regular(size: 18)
        }
    }

     @IBOutlet weak var topView: UIView!
     @IBOutlet weak var orderViewDeatilsView: UIView!
     @IBOutlet weak var gapCellView: UIView!
    
  // MARK: Variables
  var cancelOrderCallBack: ((_ tag: Int) -> Void)?
  var viewOrderCallBack: ((_ tag: Int) -> Void)?
  
  override func awakeFromNib() {
    cancelOrder.setTitle("CANCEL ORDER".localizedString, for: .normal)
    viewOrder.setTitle("VIEW DETAILS".localizedString, for: .normal)
  }
  
  // MARK: Cancel Button Clicked
  @IBAction func cancelOrderClicked(_ sender: UIButton) {
    guard let call = cancelOrderCallBack else {
      return
    }
    call(sender.tag)
  }
  
  
  // MARK: View Order Button Clicked
    @IBAction func viewOrderClicked(_ sender: UIButton) {
      guard let call = viewOrderCallBack else {
        return
      }
      call(sender.tag)
  }
  
  // MARK: Update Cell
  func updateCell(order: OrderModel) {
    
    if let status = order.orderStatus, let tookanStatus = order.tookanStatus {
        if status == 4 && tookanStatus == 4 {
        cancelOrder.isHidden = true
        } else if status == 1 && tookanStatus == 7 {
            cancelOrder.isHidden = true
        } else if status == Driver.driverFailed.rawValue && tookanStatus == 6 {
          cancelOrder.isHidden = true
        } else {
         cancelOrder.isHidden = false
       }
    }
    
    if let id = order.oderId {
      idLabel.text = "#\(id)"
    }
    timeLabel.text = dateFormatted1(date: order.bookingTime ?? "")
    
    if let price = order.totalAmount {
     let sar = "Rs.".localizedString
    priceText.text = "\(sar) \(String(describing: price.roundTo2Decimal()))"
    }
//    let value = order.addressType ?? 1
//    guard let type = AddressStatus(rawValue: value) else {
//      fatalError()
//    }
    if let address = order.address, address != "" {
        /// commented asked by client
//      firstAddress.text = type.statusType.localizedString
      secondAddress.text = address
    } else {
        /// commented asked by client
//      firstAddress.text = order.branchName ?? ""
      secondAddress.text = order.branchAddress ?? ""
    }
    firstAddress.text = order.restaurantName
  }
}
