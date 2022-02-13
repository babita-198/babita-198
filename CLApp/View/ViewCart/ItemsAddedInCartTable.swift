  //
  //  ItemsAddedInCartTable.swift
  //  FoodFox
  //
  //  Created by socomo on 16/11/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

  import UIKit

  class ItemsAddedInCartTable: UITableViewCell {
    
      // MARK: -  Variables
      var itemQuantityView: AddMoreItemView!
      var price: Double = 0.0
      var addCallBack: ((_ index: Int) -> Void)?
      var substractCallBack: ((_ index: Int) -> Void)?
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblItemName: UILabel! {
        didSet {
            lblItemName.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var lblPriceOfItems: UILabel! {
        didSet {
             lblPriceOfItems.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var lblAddOnItems: UILabel! {
        didSet {
            lblAddOnItems.font = AppFont.light(size: 17)
        }
    }
    @IBOutlet weak var substractBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel! {
        didSet {
            quantityLbl.font = AppFont.regular(size: 17)
        }
    }
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    
      override func awakeFromNib() {
          super.awakeFromNib()
//        quantityView.layer.borderWidth = 1
//        quantityView.layer.borderColor = UIColor.gray.cgColor
      }
    
    // MARK: SetUp Cell
    func setupCell(itemDetails: CartItem) {
          quantityLbl.text = "\(itemDetails.itemQuantity)"
          lblItemName.text = itemDetails.itemName
          if let addons = itemDetails.cartItemAddOns?.allObjects as? [CartItemAddOn] {
            let quantity = itemDetails.itemQuantity
            var addonPrice =  addons.reduce(0, {$0 + ($1.adonsPrice )})
            addonPrice /= Double(quantity)
          let addOnsName = addons.reduce("", {$0 +  ($1.adonName ?? "") + "," })
          price = addonPrice + itemDetails.itemPrice
            let sar = "Rs.".localizedString
         lblPriceOfItems.text = "\(sar) \(String(describing: price.roundTo2Decimal()))"
          if addOnsName == "" {
           lblAddOnItems.text = "No customization added.".localizedString
          } else {
         lblAddOnItems.text = addOnsName
          }
        }
    }
   
    
    @IBAction func substractAction(_ sender: UIButton) {
      guard let call = substractCallBack else {
        return
      }
      call(sender.tag)
    }
    
    
    @IBAction func addAction(_ sender: UIButton) {
      guard let call = addCallBack else {
        return
      }
      call(sender.tag)
    }
    
    
  }
