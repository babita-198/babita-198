//
//  AllowLocationController.swift
//  FoodFox
//
//  Created by clicklabs on 10/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class AllowLocationController: UIViewController {
  
  //MARK: Outlets
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var appDescription: UILabel!
  @IBOutlet weak var instructionFirst: UILabel!
  @IBOutlet weak var instructionSecond: UILabel!
  @IBOutlet weak var instructionThird: UILabel!
  @IBOutlet weak var allowBtn: UIButton!

  override func viewDidLoad() {
        super.viewDidLoad()
        localizedString()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  //MARK: Localized Func
  /// - Localized String
  func localizedString() {
    titleLbl.text = "Allow GPS \nLocation Services".localizedString
    appDescription.text = "Allow FoodFox to access \nthis device’s location?".localizedString
    instructionFirst.text = "Change permissions by going to:".localizedString
    instructionThird.text = "and choose “While Using the App”.".localizedString
    instructionSecond.text = "Settings > FoodFox > Location".localizedString
    allowBtn.setTitle("ALLOW".localizedString, for: .normal)
  }
  
  //MARK: Cross Button Action
  @IBAction func crossButton(_ sender: UIButton) {
    if let viewController  = R.storyboard.main.chooseDeliveryController() {
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  //MARK: Allow Button Action
  @IBAction func allowAction(_ sender: UIButton) {
    
  }
  
}
