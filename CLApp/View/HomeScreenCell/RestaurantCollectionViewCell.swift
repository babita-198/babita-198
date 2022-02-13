//
//  RestaurentCollectionViewCell.swift
//  FoodFox
//
//  Created by socomo on 28/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RestaurentCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var restaurantNameView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var timeDurationView: UIView!
    @IBOutlet weak var stackDetails: UIStackView!
    
    
    
    
    @IBOutlet weak var restaurantName: UILabel! {
        didSet {
            restaurantName.font = AppFont.semiBold(size: 22)
        }
    }
    @IBOutlet weak var rating: UILabel! {
        didSet {
            rating.font = AppFont.regular(size: 15)
        }
    }
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = AppFont.regular(size: 16)
        }
    }
    @IBOutlet weak var estimatedTimeLabel: UILabel! {
        didSet {
            estimatedTimeLabel.font = AppFont.regular(size: 15)
        }
    }
    @IBOutlet weak var deliveryChargesLabel: UILabel! {
        didSet {
            deliveryChargesLabel.font = AppFont.regular(size: 15)
        }
    }
    @IBOutlet weak var pricelabel: UILabel! {
        didSet {
            pricelabel.font = AppFont.regular(size: 15)
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.font = AppFont.regular(size: 14)
        }
    }
    @IBOutlet weak var openingStatus: UILabel! {
        didSet {
            openingStatus.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var blurViewTemper: UIView!
    
   var paymentTypes: [String] = []
    
    @IBOutlet var icCardImageView: UIImageView!
    @IBOutlet var icCarImage2View: UIImageView!
    @IBOutlet var icWalletImageView: UIImageView!
    
    
    
    // MARK: - Variables
  var restaurantData: RestaurantNear? {
        didSet {
            if let data = restaurantData {
                self.setData(restaurantData: data)
            }
        }
    }
    
    override func awakeFromNib() {
       listView.shadowPathCustom(cornerRadius: 6)
    }
    
    func setData(restaurantData: RestaurantNear) {
        let sar = "Rs.".localizedString
        self.restaurantName.text = restaurantData.restaurantName
        if let rating = restaurantData.rating {
        self.rating.text = "\(rating.roundTo1Decimal())"
         self.rating.backgroundColor = UIColor.ratingColor(rating: rating)
      }
        if let rate  = restaurantData.rating {
         self.rating.backgroundColor = UIColor.ratingColor(rating: rate)
        }
        self.descriptionLabel.text = restaurantData.restaurantDescription
        if let estimatedTime = restaurantData.estimateDeliveryTime {
          let min = "Mins".localizedString
            
            self.pricelabel.text = "\(estimatedTime) \(min)"
        }
        if let deliveryCharges = restaurantData.deliveryCharge {
            self.deliveryChargesLabel.text = "\(sar) \(deliveryCharges)"
        }
//        if let price = restaurantData.minimumOrderValue {
//            self.pricelabel.text = "\(sar) \(price)"
//        }
        if let imageUrl = restaurantData.restaurantImageURL {
            self.backImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        }
       self.paymentTypes = restaurantData.paymentMethods
        
        print("restaurant payment types", self.paymentTypes)
        paymentTypesCheck()
        
        let isOpen = getStatusType(status: restaurantData.isOpenRestaurent ?? -1)
        
        
        print("open status of restaurant ", isOpen)
        let statusString = getStatusName(status: restaurantData.isOpenRestaurent ?? -1)
        print("status of restaurant ", statusString)
      self.openingStatus.text = statusString.localizedString
      if isOpen {
      blurViewTemper.isHidden = false
        rating.bringSubviewToFront(blurViewTemper)
       
        self.openingStatus.bringSubviewToFront(blurViewTemper)
        if statusString == "Busy Now" {
            self.openingStatus.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.openingStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else if statusString == "Closed Now" {
            self.openingStatus.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            self.openingStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
      } else {
        print("status of restaurant ", statusString)
        blurViewTemper.isHidden = true
        rating.bringSubviewToFront(blurViewTemper)
        self.openingStatus.bringSubviewToFront(blurViewTemper)
        self.openingStatus.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        self.openingStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
      }
      
      if bookingFlow == .pickup {
        self.stackDetails.isHidden = false
        distanceLabel.isHidden = true
        if let estimatedTime = restaurantData.estimatedPreparationTime {
            let min = "Mins".localizedString
            self.pricelabel.text = "\(estimatedTime) \(min)"
        }
        if let deliveryCharges = restaurantData.distanceCalculated {
             let km = "Km".localizedString
            self.deliveryChargesLabel.text = "\(deliveryCharges.roundTo1Decimal()) \(km)"
        }
//        if let distance = restaurantData.distanceCalculated {
//          let km = "Km".localizedString
//        distanceLabel.text = "\(distance.roundTo2Decimal()) \(km)"
//        }
      }
//      else {
//        self.stackDetails.isHidden = false
//        distanceLabel.isHidden = true
//      }
      
    }
    //MARK:- PAYMENT TYPE CHECK
    func paymentTypesCheck( ) {
        
        
        
        if paymentTypes.contains("1") && paymentTypes.contains("2") && paymentTypes.contains("3") {
            
            print("okay payment 1,2,4")
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = true
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("2") && paymentTypes.contains("4") {
            
            print("okay payment 1,2,3")
            self.icCardImageView.isHidden = false
            self.icWalletImageView.isHidden = false
            self.icCarImage2View.isHidden = false
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("2") {
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = true
            print("okay payment 1,2 ")
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("4") {
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = false
            print("okay payment 1,4")
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("3") {
            
            print("okay payment 1,3")
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = true
            
        } else if paymentTypes.contains("2") && paymentTypes.contains("4") {
            
            print("okay payment 2,4")
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = false
            
        } else if paymentTypes.contains("2") && paymentTypes.contains("3") {
            
            print("okay payment 2,3")
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = false
            
        } else if paymentTypes.contains("1") {
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = true
            
            print("okay payment 1")
            
        } else if paymentTypes.contains("2") {
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = true
            
            print("okay payment 2")
            
        } else if paymentTypes.contains("4") {
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = false
            
            print("okay payment 4")
            
        } else if paymentTypes.contains("3") {

            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = true
            print("okay payment 3")

        }
        
    }
}
