//
//  ReviewCell.swift
//  FoodFox
//
//  Created by clicklabs on 08/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

  //MARK: Outlet 
  @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel! {
        didSet {
            restaurantName.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var reviewText: UILabel! {
        didSet {
            reviewText.font = AppFont.light(size: 14)
        }
    }

  override func awakeFromNib() {
        super.awakeFromNib()
       setUpRateView()
    }
  
  //MARK: SetUp Rate View
  func setUpRateView() {
    rateView.fullImage = #imageLiteral(resourceName: "selectedRate")
    rateView.emptyImage = #imageLiteral(resourceName: "unSelectedRate")
    rateView.halfRatings = false
    rateView.maxRating = 5
    rateView.minRating = 0
    rateView.editable = false
    rateView.rating = 3.0
  }
  
  //MARK: Update Detail in Cell
  func updateCell(reviewData: ReviewModel) {
    if let count = reviewData.ratingCount {
    self.rateView.rating = count
    }
    if let name = reviewData.userFullName {
    self.restaurantName.text = name
    }
    if let image = reviewData.userImage {
      self.restaurantImage.clipsToBounds = true
      self.restaurantImage.layer.cornerRadius = 20
      self.restaurantImage.imageUrl(imageUrl: image, placeholderImage: #imageLiteral(resourceName: "reviewPlaceholder"))
    }
    if let review = reviewData.reviewText {
      self.reviewText.text = review
    }
  }
}
