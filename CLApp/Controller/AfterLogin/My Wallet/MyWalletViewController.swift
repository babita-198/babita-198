//
//  MyWalletViewController.swift
//  FoodFox
//
//  Created by clicklabs on 03/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {
  
  //MARK: Outlet
  @IBOutlet weak var navTitle: UILabel!
  @IBOutlet weak var walletAmount: UILabel!
  @IBOutlet weak var walletAmoutDescription: UILabel!
  @IBOutlet weak var addWalletTitle: UILabel!
  @IBOutlet weak var textTitle: UILabel!
  @IBOutlet weak var amountText: UITextField!
  @IBOutlet weak var addCreditBtn: UIButton!
  @IBOutlet weak var termBtn: UIButton!
  @IBOutlet weak var backBtn: UIButton!
    
  //MARK: View Did Load
  override func viewDidLoad() {
        super.viewDidLoad()
    backBtn.changeBackBlackButton()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    self.setWalletAmount()
    self.localizedString()
  }
  
  //MARK: Set Wallet Amount
  func setWalletAmount() {
    let amount = LoginManagerApi.share.me?.walletAmount
    let sar = "Rs.".localizedString
    walletAmount.text = "\(sar) \(amount ?? 0.0)"
  }
  
  //MARK: Localized String
  func localizedString() {
    navTitle.text = "Wallet".localizedString
    walletAmoutDescription.text = "FoodFox Cash".localizedString
    addWalletTitle.text = "Add Credits to Wallet".localizedString
    textTitle.text = "Enter amount".localizedString
    termBtn.setTitle("Terms & Conditions".localizedString, for: .normal)
    addCreditBtn.setTitle("ADD CREDIT".localizedString, for: .normal)
  }
  
  //MARK: Add Credits
  @IBAction func addCreditAction(_ sender: UIButton) {

  }

  //MARK: BackButton Pop Conroller
  @IBAction func backButton(_ sender: UIButton) {
  self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: Term and Condition
  @IBAction func termAndCondition(_ sender: UIButton) {
    openTermAndCondition(title: "Terms & Conditions".localizedString)
  }
  
  //MARK: Open Term and Condition Tutorials
  func openTermAndCondition(title: String) {
    let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
    guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.contactSupport) as? ContactSupportViewController else {
      return
    }
    vc.navString = title
    vc.urlString = Info.tc.infoUrl
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
