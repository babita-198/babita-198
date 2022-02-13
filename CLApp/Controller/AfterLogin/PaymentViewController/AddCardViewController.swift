//
//  AddCardViewController.swift
//  FoodFox
//
//  Created by Nishant Raj on 03/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      cardView.dropShadow(color: headerColor, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 1, scale: true)
      }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
