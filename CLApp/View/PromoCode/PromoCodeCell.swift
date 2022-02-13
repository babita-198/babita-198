//
//  PromoCodeCell.swift
//  FoodFox
//
//  Created by clicklabs on 02/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class PromoCodeCell: UITableViewCell {

    @IBOutlet weak var promoImage: UIImageView!
    @IBOutlet weak var btnTC: UIButton!
    
    var viewTermsAndCondtionCallBack: ((_ tag: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Terms & Condtion Button Clicked
      @IBAction func viewTCClicked(_ sender: UIButton) {
        guard let call = viewTermsAndCondtionCallBack else {
          return
        }
        call(sender.tag)
    }
  
}
