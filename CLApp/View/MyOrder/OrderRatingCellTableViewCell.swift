//
//  OrderRatingCellTableViewCell.swift
//  FoodFox
//
//  Created by Nishant Raj on 06/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class OrderRatingCellTableViewCell: UITableViewCell {

  //MARK: Outlet
  @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel! {
        didSet {
            itemName.font = AppFont.semiBold(size: 15)
        }
    }
  @IBOutlet weak var firstRate: UIImageView!
  @IBOutlet weak var secondRate: UIImageView!
  @IBOutlet weak var thirdRate: UIImageView!
  @IBOutlet weak var fourthRate: UIImageView!
  @IBOutlet weak var fifthRate: UIImageView!
  
  var phoneNumber = ""
  var phoneCallBack: ((_ phoneNumber: String) -> Void)?

  override func awakeFromNib() {
        super.awakeFromNib()
    }
  
  //MARK: Update Cell
  func updateCell(data: OrderModel) {
    if let name = data.restaurantName {
      itemName.text = name
    }
    if let phone = data.restaurantPhone {
      self.phoneNumber = phone
    }
    if let image = data.restaurantImage {
      itemImage.imageUrl(imageUrl: image, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
    }
    for iVar in 0...data.rating {
      switch iVar {
      case 1:
        firstRate.image = #imageLiteral(resourceName: "selectedRate")
      case 2:
        secondRate.image = #imageLiteral(resourceName: "selectedRate")
      case 3:
        thirdRate.image = #imageLiteral(resourceName: "selectedRate")
      case 4:
        fourthRate.image = #imageLiteral(resourceName: "selectedRate")
      case 5:
        fifthRate.image = #imageLiteral(resourceName: "selectedRate")
      default:
        break
      }
    }
  }
  
  //MARK: Call button Tabbed
  @IBAction func callAction(_ sender: UIButton) {
    guard let call = phoneCallBack else {
      return
    }
    call(phoneNumber)
  }
  
}
