//
//  PromotionsController.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class PromotionsController: CLBaseViewController {
  
    //MARK: Outlet
    @IBOutlet weak var promoField: UITextField! {
        didSet {
            promoField.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyPromo: UIButton! {
        didSet {
            applyPromo.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var promoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var offerLabel: UILabel! {
        didSet {
            offerLabel.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var offerTextBackgroundView: UIView!
    @IBOutlet weak var offerBackView: UIView!
    @IBOutlet weak var viewTC: UIView! {
        didSet {
            viewTC.layer.borderColor = UIColor.lightGray.cgColor
            viewTC.layer.borderWidth = 2.0
            viewTC.layer.cornerRadius = 3.0
        }
    }
    @IBOutlet weak var txtViewTC: UITextView!
    //MARK: Variables
   var isFromSide = true
   var promoData: [PromoModel] = []
   var totalAmount: Double = 0.0
    var restaurantId: String = ""
   var successApply: (() -> Void)?
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationController?.navigationBar.isHidden = true
      self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      changeConstraint(controller: self, view: topView)
      promoField.changeAlignment()
      setUpCell()
      localizedString()
    }
  
    //MARK: Localized String
    func localizedString() {
        applyPromo.setTitle("APPLY".localizedString, for: .normal)
        navTitle.text = "Promotions".localizedString
        offerLabel.text = "Offers".localizedString
        promoField.placeholder = "Enter Promocode".localizedString
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    getPromoList()
    checkStatusForDarkMode()
    setUp()
  }
    
    //MARK:- CHECK STATUS OF DARK MODE
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            
            backButton.setImage(UIImage(named: "menu-1"), for: .normal)
            offerBackView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            offerTextBackgroundView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.offerLabel.textColor = lightWhite
            promoField.textColor = lightWhite
            tableView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            offerBackView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            offerTextBackgroundView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            backButton.setImage(UIImage(named: "menu"), for: .normal)
            tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.offerLabel.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            promoField.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            
        }
        
    }
    
    
    
  
  //MARK: SetUp Cell
  func setUpCell() {
    tableView.registerCell(Identifier.promoCodeCell)
//    tableView.estimatedRowHeight = 150
//    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  //MARK: Apply Promo Code
  func applyPromoCodes() {
    var parameter: [String: Any] = [:]
    parameter["amount"] = totalAmount
    parameter["promoCode"] = promoField.text ?? ""
    parameter["restaurantId"] = restaurantId
    PromoModel.applyPromoCode(params: parameter, callBack: { (amount: Double?, error: Error?) in
      if error != nil {
        return
      }
       LoginManagerApi.share.promoAmount = amount ?? 0.0
       LoginManagerApi.share.promoName = self.promoField.text ?? ""
       self.navigationController?.popViewController(animated: true)
    })
  }
  
  //MARK: Get Promo List Data
  func getPromoList() {
    var param: [String: Any] = [:]
    if !isFromSide {
    param["restaurantId"] = restaurantId
    }
    PromoModel.getPromo(param: param, callBack: { (list: [PromoModel]?, error: Error?) in
      if error != nil {
        return
      }
      if let list = list {
        self.promoData = list
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
      }
      if self.promoData.count == 0 {
        TableViewHelper.emptyMessage(message: "No offers available".localizedString, viewController: self.tableView)
      } else {
       TableViewHelper.emptyMessage(message: "".localizedString, viewController: self.tableView)
      }
      
    })
  }
  
  //MARK: SetUp Function
  func setUp() {
    if !isFromSide {
        backButton.changeBackBlackButton()
        promoViewHeight.constant = 60
    } else {
        promoViewHeight.constant = 0
        backButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
    }
  }
    
    //MARK: Show Terms & Conditions
    func showTermsAndCondition(sender: Int) {
        print(self.promoData[sender].promoName ?? "")
        
//        UIView.transition(with: button, duration: 0.4,
//            options: .transitionCrossDissolve,
//            animations: {
           viewTC.isHidden = false
//        })
        txtViewTC.text = self.promoData[sender].description ?? ""
    }
  
  //MARK: Back Button Action
  @IBAction func backButtonAction(_ sender: UIButton) {
    if isFromSide {
      let language = Localize.currentLang()
      if language == .arabic {
        self.revealViewController().rightRevealToggle(animated: true)
        return
      }
     self.revealViewController().revealToggle(animated: true)
    } else {
      self.navigationController?.popViewController(animated: true)
    }
  }

  //MARK: Apply Promo Action
    @IBAction func applyPromoAction(_ sender: UIButton) {
      if promoField.text?.trimmedString() != "" {
       self.applyPromoCodes()
      } else {
         customAlert(controller: self, message: "Please enter Promo code".localizedString)
      }
    }
    
    //MARK: Close T&C popup
    @IBAction func closeTCButtonAction(_ sender: UIButton){
        UIView.transition(with: sender, duration: 0.4,
            options: .transitionCrossDissolve,
            animations: {
                self.viewTC.isHidden = true
        })
    }
    
}


//MARK: UITableView Delegate and Data Source
extension PromotionsController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return promoData.count
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard  let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.promoCodeCell) as? PromoCodeCell else {
      fatalError("Could Not load PromoCode Cell")
    }
    
    
    
    let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
    
    if isDarkMode == true {
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
       
    } else {
        cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    if let imageUrl = promoData[indexPath.row].promoImage {
    cell.promoImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder2_2"))
        cell.promoImage.layer.cornerRadius = 3.0
        cell.promoImage.layer.borderWidth = 1.0
        cell.promoImage.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.btnTC.tag = indexPath.row
        cell.viewTermsAndCondtionCallBack = { sender in
            self.showTermsAndCondition(sender: sender)
        }
        
        cell.btnTC.layer.cornerRadius = 10.0
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let promoName = promoData[indexPath.row].promoName {
     promoField.text = promoName
    }
  }
}
