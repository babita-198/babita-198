//
//  AddMoreItemView.swift
//  FoodFox
//
//  Created by socomo on 04/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit



protocol ViewAdd: class {
    func viewAddPopUp(_ tag: Int?)
}
protocol AddItemViewDelete: class {
    func viewDelete(_ tag: Int?)
    
}


class AddMoreItemView: UIView {
    
    
    // MARK: - Constants
    var index: Int?
    var quantity: String = ""
    var isFirstTime = false
    
    weak var delegate: ViewAdd?
    weak var quantityDelegate: AddMenuItemDelegate?
    weak var delegateView: AddItemViewDelete?
    
    // MARK: - UIActions
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addItemView: UIStackView!
    
    @IBAction func actionSubtract(_ sender: UIButton) {
        if self.quantityLabel.text == "1" {
            delegateView?.viewDelete(self.index)
            
        }
        if self.quantityLabel.text != "0" {
            if isFirstTime {
                quantity = "1"
                isFirstTime = false
            }
            if var value = NumberFormatter().number(from: quantity) as? Int {
                print(value - 1)
                value -= 1
                quantity = "\(value)"
                self.quantityLabel.text = "\(value)"
            }
        }
        quantityDelegate?.updateQuantity(quantity: quantity)
        if let index = self.index {
            quantityDelegate?.deleteMenuItem(cellIndex: index)
        }
    }
    
    @IBAction func actionAdd(_ sender: UIButton) {
        
        
        delegate?.viewAddPopUp(index)
        if isFirstTime {
            quantity =  "1"
            isFirstTime = false
        }
        if var value = NumberFormatter().number(from: quantity) as? Int {
            print(value + 1)
            value += 1
            quantity = "\(value)"
            self.quantityLabel.text = "\(value)"
        }
        quantityDelegate?.updateQuantity(quantity: quantity)
        if let index = self.index {
            quantityDelegate?.addMenuItem(cellIndex: index)
        }
    }
    
}
