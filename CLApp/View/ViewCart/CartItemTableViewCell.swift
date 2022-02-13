//
//  CartItemTableViewCell.swift
//  FoodFox
//
//  Created by socomo on 16/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import Kingfisher
class CartItemTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var deliveryTime: UILabel! {
        didSet {
            deliveryTime.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var restaurantDiscription: UILabel! {
        didSet {
            restaurantDiscription.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var restuarantName: UILabel! {
        didSet {
           restuarantName.font = AppFont.semiBold(size: 22)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    func setupCell(kitchenDetails: RestaurantNear) {
//        restuarantName.text = kitchenDetails.restaurantName
//        if let deliverytime = kitchenDetails.estimatedPreparationTime {
//
//           let deliver = "prepares in".localizedString
//           let min = "Mins".localizedString
//            deliveryTime.text = "\(deliver) \(String(describing: Int(deliverytime))) \(min)"
//        }
        
//        restaurantDiscription.text = kitchenDetails.restaurantDescription
//        guard let image = kitchenDetails.logoImageUrl else {
//            fatalError("Image Not Found")
//        }
//        let imageUrl = URL(string: image)
//        itemImage.kf.setImage(with: imageUrl)
    }
}
