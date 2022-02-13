//
//  CuisineCollectionCell.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class CuisineCollectionCell: UICollectionViewCell {
  // MARK: - IBOutlet
  @IBOutlet weak var discoverImage: UIImageView!
  @IBOutlet weak var discoverLabel: UILabel! {
    didSet {
      discoverLabel.font = AppFont.regular(size: 18)
    }
  }
  
  // MARK: - Variables
  var discoverData: DiscoverData? {
    didSet {
      if let data = discoverData {
        self.setData(discoverData: data)
      }
      
    }
  }
  
  func setData(discoverData: DiscoverData) {
    if let name = discoverData.categoryname {
      self.discoverLabel.text = "\(name)"
    }
    
    if let imageUrl = discoverData.categoryIdImageUrl {
      self.discoverImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
    }
  }
  
  func setupCell(selectedIndex: Int, indexPath: IndexPath) {
    if indexPath.row == selectedIndex {
      discoverImage.dropShadow(color: darkPinkColor, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 1, scale: true)
      discoverImage.border(width: 2.0, color: darkPinkColor, radius: discoverImage.frame.size.height / 2)
    } else {
      discoverImage.dropShadow(color: headerColor, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 1, scale: true)
      discoverImage.border(width: 2.0, color: headerLight, radius: discoverImage.frame.size.height / 2)
    }
  }
}
