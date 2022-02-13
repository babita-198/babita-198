//
//  DiscountCell.swift
//  FoodFox
//
//  Created by clicklabs on 04/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class DiscountCell: UITableViewCell {

  @IBOutlet weak var discountImage: UIImageView!
    @IBOutlet weak var discountText: UILabel! {
        didSet {
            discountText.font = AppFont.semiBold(size: 14)
        }
    }
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }
}
