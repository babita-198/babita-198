//
//  MapCollectionViewCell.swift
//  FoodFox
//
//  Created by socomo on 24/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var restaurantLogoImage: UIImageView!
    @IBOutlet weak var ratinglabel: UILabel! {
        didSet {
            ratinglabel.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var restaurantNameLabel: UILabel! {
        didSet {
            restaurantNameLabel.font = AppFont.bold(size: 14)
        }
    }
    @IBOutlet weak var descriptionlabel: UILabel! {
        didSet {
            descriptionlabel.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var estimatedTimeLabel: UILabel! {
        didSet {
            estimatedTimeLabel.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var deliveryCost: UILabel! {
        didSet {
            deliveryCost.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var dotViews: UIView!
    override func awakeFromNib() {
        backView.shadowPath(cornerRadius: 15)
    }
    
    // MARK: - Variable
    var restaurantData: RestaurantNear? {
        didSet {
            if let data = restaurantData {
                self.setData(restaurantData: data)
            }
            
        }
    }
    
    func setData(restaurantData: RestaurantNear) {
        print(restaurantData)
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.backView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
           self.restaurantNameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.descriptionlabel.textColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.estimatedTimeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.deliveryCost.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.priceLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            self.backView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.restaurantNameLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.descriptionlabel.textColor =  #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.estimatedTimeLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.deliveryCost.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.priceLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        }
        
        self.restaurantNameLabel.text = restaurantData.restaurantName
        if let rating = restaurantData.rating {
            self.ratinglabel.text = "\(rating.roundTo1Decimal())"
          self.ratinglabel.backgroundColor = UIColor.ratingColor(rating: rating)
        }
        self.descriptionlabel.text = restaurantData.restaurantDescription
        
        if let imageUrl = restaurantData.restaurantImageURL {
            self.restaurantLogoImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        }
        
        if bookingFlow == .pickup {
         if let estimatedTime = restaurantData.distanceCalculated {
                let min = "Km".localizedString
                self.estimatedTimeLabel.text = "\(estimatedTime.roundTo1Decimal()) \(min)"
            }
            dotViews.isHidden = true
            self.deliveryCost.text = ""
            self.priceLabel.text = ""
            return
        }
        dotViews.isHidden = true
        if let estimatedTime = restaurantData.estimateDeliveryTime {
           let min = "Mins".localizedString
            self.estimatedTimeLabel.text = "\(estimatedTime) \(min)"
        }
        if let deliveryCharges = restaurantData.deliveryCharge {
           let delivery = "Delivery Cost".localizedString
            let sar = "Rs.".localizedString
            self.deliveryCost.text = "\(sar) \(deliveryCharges.roundTo2Decimal()) \(delivery)"
        }
        if let price = restaurantData.minimumOrderValue {
            let min = "Min order".localizedString
            let sar = "Rs.".localizedString
            self.priceLabel.text = "\(sar) \(price) \(min) "
        }
       
    }
}
