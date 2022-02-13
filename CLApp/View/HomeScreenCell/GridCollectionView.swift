//
//  GridCollectionView.swift
//  FoodFox
//
//  Created by socomo on 23/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GridCollectionView: UICollectionViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var restaurantName: UILabel! {
        didSet {
            restaurantName.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var blurViewTemper: UIView!
    @IBOutlet weak var ratinglabel: UILabel! {
        didSet {
            ratinglabel.font = AppFont.regular(size: 15)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = AppFont.regular(size: 16)
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = AppFont.regular(size: 14)
        }
    }
    @IBOutlet weak var estimatedtime: UILabel! {
        didSet {
            estimatedtime.font = AppFont.regular(size: 14)
        }
    }
    @IBOutlet weak var deliveryChargesLabel: UILabel! {
        didSet {
            deliveryChargesLabel.font = AppFont.regular(size: 14)
        }
    }
    @IBOutlet weak var statusOpening: UILabel! {
        didSet {
            statusOpening.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var minImage: UIImageView!
    @IBOutlet weak var priceImage: UIImageView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var restaurantNameView: UIView!
    @IBOutlet weak var restaurantDescView: UIView!
    
    @IBOutlet var icCardImageView: UIImageView!
    @IBOutlet var icCarImage2View: UIImageView!
    @IBOutlet var icWalletImageView: UIImageView!
    
    var paymentTypes: [String] = []
    
    override func awakeFromNib() {
        gridView.shadowPathCustom(cornerRadius: 5)
    }
    
    // MARK: - Variables
    var restaurantData: RestaurantNear? {
        didSet {
            if let data = restaurantData {
                self.setData(restaurantData: data)
            }
        }
    }
    
    func setData(restaurantData: RestaurantNear) {
        self.restaurantName.text = restaurantData.restaurantName
        if let rating = restaurantData.rating {
            self.ratinglabel.text = "\(rating.roundTo1Decimal())"
        }
        if let rate  = restaurantData.rating {
          self.ratinglabel.backgroundColor = UIColor.ratingColor(rating: rate)
         }
        self.descriptionLabel.text = restaurantData.restaurantDescription
        if let estimatedTime = restaurantData.estimateDeliveryTime {
            let min = "Mins".localizedString
            self.estimatedtime.text = "\(estimatedTime) \(min)"
        }
        if let deliveryCharges = restaurantData.deliveryCharge {
            let sar = "Rs.".localizedString
            self.deliveryChargesLabel.text = "\(sar) \(deliveryCharges)"
        }
//        if let price = restaurantData.minimumOrderValue {
//            let sar = "Rs.".localizedString
//            self.priceLabel.text = "\(sar) \(price)"
//        }
        
        if let imageUrl = restaurantData.logoImageUrl {
            self.backImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        }
         self.paymentTypes = restaurantData.paymentMethods
        
        paymentTypesCheck()
        
      let isOpen = getStatusType(status: restaurantData.isOpenRestaurent ?? -1)
      let statusString = getStatusName(status: restaurantData.isOpenRestaurent ?? -1)
      self.statusOpening.text = statusString.localizedString
      if isOpen {
       blurViewTemper.isHidden = false
        self.statusOpening.bringSubviewToFront(blurViewTemper)
        self.ratinglabel.bringSubviewToFront(blurViewTemper)
      } else {
        blurViewTemper.isHidden = true
      }
      
      if bookingFlow == .pickup {
        self.minImage.isHidden = false
        //self.priceImage.isHidden = false
        self.priceView.isHidden = false
        self.estimatedtime.isHidden = false
        if let estimatedTime = restaurantData.estimatedPreparationTime {
            let min = "Mins".localizedString
            self.estimatedtime.text = "\(estimatedTime) \(min)"
        }
        if let deliveryCharges = restaurantData.distanceCalculated {
            let km = "Km".localizedString
            self.deliveryChargesLabel.text = "\(deliveryCharges.roundTo1Decimal()) \(km)"
        }
      }

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
                print("okay payment 1,3")
                
            } else if paymentTypes.contains("1") && paymentTypes.contains("4") {
                
                print("okay payment 1,4")
                
                self.icCardImageView.isHidden = true
                self.icCarImage2View.isHidden = false
                self.icWalletImageView.isHidden = false
                
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
                
                print("okay payment 3")
                
            }
            
            //        else if paymentTypes.contains("4"){
            //
            //            self.icCardImageView.isHidden = true
            //            self.icCarImage2View.isHidden = true
            //            self.icWalletImageView.isHidden = true
            //            print("okay payment 4")
            //
            //        }
            
        }
}
