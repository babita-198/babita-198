//
//  RestaurantItemCollectionViewCell.swift
//  FoodFox
//
//  Created by socomo on 07/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class RestaurantItemCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var nameOfItem: UILabel! {
        didSet {
         nameOfItem.font = AppFont.regular(size: 16)
        }
    }
    @IBOutlet weak var scrollView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
