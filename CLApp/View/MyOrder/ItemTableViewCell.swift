//
//  ItemTableViewCell.swift
//  FoodFox
//
//  Created by clicklabs on 11/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

  //MARK: OUTLET
    @IBOutlet weak var itemName: UILabel! {
        didSet {
            itemName.font = AppFont.semiBold(size: 15)
        }
    }
    
    @IBOutlet weak var addOnItemName: UILabel! {
        didSet {
            addOnItemName.font = AppFont.semiBold(size: 13)
            addOnItemName.isHidden = true
        }
    }
    @IBOutlet weak var itemQuantity: UILabel! {
        didSet {
            itemQuantity.font = AppFont.regular(size: 14)
        }
    }
    @IBOutlet weak var itemPrice: UILabel! {
        didSet {
            itemPrice.font = AppFont.semiBold(size: 15)
        }
    }
  @IBOutlet weak var bottomView: UIView!
    var addOnNamesArray = [String]()
  override func awakeFromNib() {
        super.awakeFromNib()
    }

  //MARK: Update the Cell
  func updateCell(data: OrderModel) {
    if let name = data.itemName, let quantity = data.itemQuantity {
     itemName.text = name
     itemQuantity.text = "\(quantity)" + " Qty"
    }
    
    if let price  = data.totalAmount {
        let sar = "Rs.".localizedString
      itemPrice.text = "\(sar) \(price)"
    }
  }
  
  // MARK: Update Cell for Booking Detail
  func updateCellData(data: ItemData) {
    if let name = data.itemName, let quantity = data.quantity {
      itemName.text = name
        print("item  names", name)
      itemQuantity.text = "\(quantity)" + " Qty"
    }
    
    if let itemsData = data.addOnItem as? [AddOnItemData] {
        
        for item in itemsData {
            print("add one names", item.addOnItemName!)
            
            addOnNamesArray.append(item.addOnItemName!)
             print("add one names array", addOnNamesArray)
            addOnItemName.text = addOnNamesArray.joined(separator: ",")
            
        }
    }
 
    let sar = "Rs.".localizedString
    itemPrice.text = "\(sar) \(data.priceWithAdon + data.price!)"
  }
    
    
    
}
