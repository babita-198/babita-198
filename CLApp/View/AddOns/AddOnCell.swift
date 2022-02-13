//
//  AddOnCell.swift
//  FoodFox
//
//  Created by socomo on 13/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class AddOnCell: UITableViewCell {
  
    //MARK:- IBOutlets
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = AppFont.regular(size: 19)
        }
    }
    @IBOutlet weak var lblitem: UILabel! {
        didSet {
            lblitem.font = AppFont.semiBold(size: 18)
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBoxButton.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
        checkBoxButton.setImage(#imageLiteral(resourceName: "radioOn"), for: .selected)
    }
  
    // MARK: - UIAction
    @IBAction func actionSelected(_ sender: UIButton) {
      
    }

}
