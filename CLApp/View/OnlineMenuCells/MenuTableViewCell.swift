//
//  MenuTableViewCell.swift
//  FoodFox
//
//  Created by socomo on 03/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

protocol AddMenuItemDelegate: class {
    func addMenuItem(cellIndex: Int)
    func updateQuantity(quantity: String)
    func deleteMenuItem(cellIndex: Int)
    
}
class MenuTableViewCell: UITableViewCell {
    
    // MARK: Variables
    weak var delegate: AddMenuItemDelegate?
    weak var delegatePass: ViewAdd?
    
    // MARK: - IBOutlets
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var customizationHeight: NSLayoutConstraint!
    @IBOutlet weak var priseTopConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var restaurantItemLabel: UILabel! {
        didSet {
            restaurantItemLabel.font = AppFont.semiBold(size: 13)
        }
    }
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.titleLabel?.font = AppFont.semiBold(size: 13)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = AppFont.light(size: 13)
        }
    }
    @IBOutlet weak var customizationLabel: UILabel! {
        didSet {
            customizationLabel.font = AppFont.light(size: 11)
        }
    }
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var lblItemPrice: UILabel! {
        didSet {
            lblItemPrice.font = AppFont.semiBold(size: 13)
        }
    }
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var quantityLabel: UILabel! {
        didSet {
            quantityLabel.font = AppFont.regular(size: 12)
        }
    }
    
    @IBOutlet weak var substratBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    // MARK: - UIActions
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  
   @IBAction func actionAdd(_ sender: UIButton) {
         quantityLabel.text = "1"
         addButton.isHidden = true
         addItemView.isHidden = false
         self.delegate?.addMenuItem(cellIndex: sender.tag)
         delegatePass?.viewAddPopUp(sender.tag)
    }
    
    @IBAction func substractCartQuantity(_ sender: UIButton) {
      self.delegate?.deleteMenuItem(cellIndex: sender.tag)
    }
    
    @IBAction func addCartQuantity(_ sender: UIButton) {
       self.delegate?.addMenuItem(cellIndex: sender.tag)
        delegatePass?.viewAddPopUp(sender.tag)
    }
    
    
}

extension MenuTableViewCell: AddItemViewDelete {
    
    func viewDelete(_ tag: Int?) {
        addItemView.isHidden = true
        addButton.isHidden = false
    }
}
