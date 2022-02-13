//
//  RestaurantBranchesViewCellTableViewCell.swift
//  FoodFox
//
//  Created by socomo on 08/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
protocol SelectButton: class {
    func selectedButton(_ tag: Int)
    func getDirection(_ tag: Int)
    func call(_ tag: Int)
}
class RestaurantBranchesViewCellTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
   
    @IBOutlet weak var lblMinimumOrder: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblBranchName: UILabel! {
        didSet {
            lblBranchName.font = AppFont.bold(size: 20)
        }
    }
    @IBOutlet weak var phoneNumner: UILabel! {
        didSet {
            phoneNumner.font = AppFont.light(size: 15)
        }
    }
    @IBOutlet weak var lblBranchAddress: UILabel! {
        didSet {
            lblBranchAddress.font = AppFont.light(size: 15)
        }
    }
    @IBOutlet weak var selectButton: UIButton! {
        didSet {
            selectButton.titleLabel?.font = AppFont.semiBold(size: 13)
        }
    }
    @IBOutlet weak var distance: UILabel! {
        didSet {
           distance.font = AppFont.light(size: 15)
        }
    }
    @IBOutlet weak var getDirection: UIButton! {
        didSet {
            getDirection.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var lblStatus: UILabel! {
        didSet {
            lblStatus.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var cabImageView: UIImageView!
    
    // MARK: - Constants
    weak var delegate: SelectButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
     // selectButton.setTitle("SELECT".localizedString + " >", for: .normal)
        selectButton.setTitle("Select this Branch".localizedString, for: .normal)
         getDirection.setTitle("GET THE DIRECTIONS".localizedString, for: .normal)
      //getDirection.setTitle("GET DIRECTIONS".localizedString + " >", for: .normal)
        self.viewBackground.shadowPathCustom(cornerRadius: 5)
    }

    // MARK: - UIActions
    @IBAction func actionSelect(_ sender: UIButton) {
        delegate?.selectedButton(sender.tag)
    }
  
  //MARK: Get Direction
    @IBAction func getDirection(_ sender: UIButton) {
       delegate?.getDirection(sender.tag)
    }
    
    //MARK: call to Branch
    @IBAction func callButtonAction(_ sender: UIButton) {
        delegate?.call(sender.tag)
    }
    
    
  
}
