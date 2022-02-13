//
//  OrderAddressCell.swift
//  FoodFox
//
//  Created by clicklabs on 13/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class OrderAddressCell: UITableViewCell {

    @IBOutlet weak var firstAddress: UILabel! {
        didSet {
            firstAddress.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var secondAddress: UILabel! {
        didSet {
            secondAddress.font = AppFont.regular(size: 14)
        }
    }

  override func awakeFromNib() {
        super.awakeFromNib()
    }
  
  //MARK: Update Cell
  func updateCell(address: OrderModel) {
    
    let value = address.addressType ?? 1
    guard let type = AddressStatus(rawValue: value) else {
      fatalError()
    }
    if let address = address.address, address != "" {
      secondAddress.text = address
      firstAddress.text = type.statusType
      firstAddress.isHidden = false
    } else {
      secondAddress.text = address.branchAddress ?? ""
      firstAddress.text = address.branchName
    }
  }
}
