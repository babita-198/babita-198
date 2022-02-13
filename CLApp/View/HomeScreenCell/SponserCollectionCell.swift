//
//  SponserCollectionCell.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class SponserCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
  
    var sponserData: SponseredDetails? {
        didSet {
            if let data = sponserData {
                self.setData(sponserData: data)
            }
        }
    }
    
    func setData(sponserData: SponseredDetails) {
          lblRating.isHidden = true
        
     
        if let mealrating = sponserData.mealrating {
            self.lblRating.text = "\(mealrating.roundTo1Decimal())"
            self.lblRating.backgroundColor = UIColor.ratingColor(rating: mealrating)
        }
         if let imageUrl = sponserData.mealImageUrl {
          self.imgBg.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        }
    }
}
