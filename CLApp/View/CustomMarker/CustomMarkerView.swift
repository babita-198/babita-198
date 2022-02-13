//
//  CustomMarkerView.swift
//  FoodFox
//
//  Created by clicklabs on 23/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class CustomMarkerView: UIView {
  
  @IBOutlet weak var markerView: UIView!
  @IBOutlet weak var restaurantImage: UIImageView!
  @IBOutlet weak var restaurentName: UILabel!
  @IBOutlet weak var restaurentDescriptiom: UILabel!
 
  override func awakeFromNib() {
   self.clipsToBounds = true
    markerView.shadowPath(cornerRadius: 10)
  }
}
