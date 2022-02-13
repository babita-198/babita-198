//
//  GridMenuCollectioncell.swift
//  FoodFox
//
//  Created by socomo on 07/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class GridMenuCollectioncell: UICollectionViewCell {
    
    // MARK: Variables
    weak var delegate: AddMenuItemDelegate?
    weak var delegatePass: ViewAdd?
    // MARK: - IBOutlets
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var addItemView: UIView!
     @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
      @IBOutlet weak var priseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var customizeHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = AppFont.light(size: 15)
        }
    }
    @IBOutlet weak var customizationLabel: UILabel! {
        didSet {
            customizationLabel.font = AppFont.light(size: 14)
        }
    }
    
    //
    @IBOutlet weak var restaurantItemName: UILabel! {
        didSet {
            restaurantItemName.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var lblPrice: UILabel! {
        didSet {
            lblPrice.font = AppFont.semiBold(size: 17)
        }
    }
    @IBOutlet weak var addBtn: UIButton! {
        didSet {
            addBtn.titleLabel?.font = AppFont.bold(size: 18)
           // addBtn.titleLabel?.font = AppFont.semiBold(size: 12)
            addBtn.layer.shadowColor = UIColor.gray.cgColor
            addBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
            addBtn.layer.shadowOpacity = 1.0
            addBtn.layer.shadowRadius = 10
            addBtn.layer.masksToBounds = false
            addBtn.clipsToBounds = true
            //addButton.layer.borderWidth = 1
            addBtn.layer.cornerRadius = 2
        }
    }
    @IBOutlet weak var quantityLabel: UILabel! {
        didSet {
            quantityLabel.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var substractBtn: UIButton!
    @IBOutlet weak var addButton: UIButton!
       
    
     @IBAction func addQuantity(_ sender: UIButton) {
        self.delegate?.addMenuItem(cellIndex: sender.tag)
        delegatePass?.viewAddPopUp(sender.tag)
    }
    
    @IBAction func subStractItem(_ sender: UIButton) {
     self.delegate?.deleteMenuItem(cellIndex: sender.tag)
    }
    
    // MARK: - UIActions
    @IBAction func actionAdd(_ sender: UIButton) {
        quantityLabel.text = "1"
        addBtn.isHidden = true
        addItemView.isHidden = false
       
        self.delegate?.addMenuItem(cellIndex: sender.tag)
        
    }
    
}
class CustomButton: UIButton {
     
   override init(frame: CGRect) {
       super.init(frame: frame)
       setRadiusAndShadow()
   }
     
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setRadiusAndShadow()
   }
     
   func setRadiusAndShadow() {
       layer.cornerRadius = 2
       clipsToBounds = true
       layer.shadowRadius = 10
       layer.shadowOpacity = 1.0
       layer.shadowOffset = CGSize(width: 3, height: 3)
       layer.shadowColor = UIColor.gray.cgColor
       layer.masksToBounds = false
    }
}
