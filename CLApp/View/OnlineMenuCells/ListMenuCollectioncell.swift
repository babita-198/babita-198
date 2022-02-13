//
//  ListMenuCollectioncell.swift
//  FoodFox
//
//  Created by Jainish Patel on 21/07/20.
//  Copyright © 2020 OyeLabs. All rights reserved.
//

import UIKit

class ListMenuCollectioncell: UICollectionViewCell {
    
    // MARK: Variables
    weak var delegate: AddMenuItemDelegate?
    weak var delegatePass: ViewAdd?
    
    // MARK: - IBOutlets
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var customizationHeight: NSLayoutConstraint!
    @IBOutlet weak var priseTopConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var restaurantItemLabel: UILabel! {
        didSet {
            restaurantItemLabel.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.titleLabel?.font = AppFont.bold(size: 20)
           // addButton.titleLabel?.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = AppFont.light(size: 15)
        }
    }
    @IBOutlet weak var customizationLabel: UILabel! {
        didSet {
            customizationLabel.font = AppFont.light(size: 18)
        }
    }
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var lblItemPrice: UILabel! {
        didSet {
            lblItemPrice.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var quantityLabel: UILabel! {
        didSet {
            quantityLabel.font = AppFont.regular(size: 15)
        }
    }
    
    @IBOutlet weak var substratBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    // MARK: - UIActions
    
    var addBAction : ((Bool) -> Void)?
    var substractCartQuantityAction : ((Bool) -> Void)?
    var addCartQuantityAction : ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       

    }
    
    
    @IBAction func actionAdd(_ sender: UIButton) {
        quantityLabel.text = "1"
        addButton.isHidden = true
        addItemView.isHidden = false
        if let callBack = addBAction {
            callBack(true)
        }
        //self.delegate?.addMenuItem(cellIndex: sender.tag)
        //delegatePass?.viewAddPopUp(sender.tag)
    }
    
    @IBAction func substractCartQuantity(_ sender: UIButton) {
        if let callBack = substractCartQuantityAction {
            callBack(true)
        }
        //self.delegate?.deleteMenuItem(cellIndex: sender.tag)
    }
    
    @IBAction func addCartQuantity(_ sender: UIButton) {
        if let callBack = addCartQuantityAction {
            callBack(true)
        }
        //self.delegate?.addMenuItem(cellIndex: sender.tag)
        //delegatePass?.viewAddPopUp(sender.tag)
    }
    
    
}

extension ListMenuCollectioncell: AddItemViewDelete {
    
    func viewDelete(_ tag: Int?) {
        addItemView.isHidden = true
        addButton.isHidden = false
    }
}
