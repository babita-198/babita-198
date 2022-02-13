//
//  CLCountryCell.swift
//  CountryCodeInSwift3
//
//  Created by cl-macmini-68 on 09/02/17.
//  Copyright © 2017 Suryakant. All rights reserved.
//

import UIKit

class CLCountryCell: UITableViewCell {
  
  @IBOutlet weak var checkmarkImageView: UIImageView!
  @IBOutlet weak var labelStackView: UIStackView!
  @IBOutlet weak var flagImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var diallingCodeLabel: UILabel!
  @IBOutlet weak var separatorLine: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
