  //
  //  ViewCartController.swift
  //  FoodFox
  //
  //  Created by socomo on 15/11/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

  import Foundation
  import UIKit
  import CoreData
  enum CartItems: Int, CaseCountable {
      case kitchenDetails
      case itemDetails
      case amountDetails
  }
  
  class ViewCartController: UIViewController {
    var totalAmountGet = String()
      // MARK:- Variable
      var quantity: String?
      var price: Double = 0.0
      var restaurantDetails: RestaurantNear?
      var cartItem: [CartItem] = []
    var restrantFetchData : MenuDetails?
      var resturentId = ""
      var branchId = ""
      var vat = "0"
      var vatPercentage = 0.0
      var totalQuantity = 0
//      var miniCost = 0.0
      var extraInfo = ""
      var branchName: String?
    var addnoteMessage = String()
    var minimumOrderValueGet: Double = 0.0
    var addNoteTypeMessage = String()
      // MARK: - IBOutlets
    @IBOutlet weak var viewCartTable: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var proceedBtn: UIButton! {
        didSet {
            proceedBtn.titleLabel?.font = AppFont.semiBold(size: 20)
        }
    }
    
    @IBOutlet weak var myCartNav: UILabel! {
        didSet {
            myCartNav.font = AppFont.semiBold(size: 20)
        }
    }
    
      @IBOutlet weak var backBtn: UIButton!
  
    // MARK: - Life Cycle
      override func viewDidLoad() {
        
          super.viewDidLoad()
        
        print(self.addnoteMessage)
       
          viewCartTable.registerCell(Identifier.cartItemTableViewCell)
          viewCartTable.registerCell(Identifier.itemsAddedInCartTable)
          viewCartTable.registerCell(Identifier.priceDetailsTableView)
          viewCartTable.estimatedRowHeight = 50
          viewCartTable.delegate = self
          viewCartTable.dataSource = self
          proceedBtn.setTitle("PROCEED".localizedString, for: .normal)
          myCartNav.text = "My Cart".localizedString
          backBtn.changeBackBlackButton()
      }
    
    //MARK: view Will Appear
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
        minimumOrderValueGet =  Double(UserDefaults.standard.value(forKey: "minimumOrderValue") as? Int ?? 0)
        setUpbuttonText()
        getCart()
        let language = Localize.currentLang()
        if language == .english {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        checkStatusForDarkMode()
       
        
      }
   

    
    func checkStatusForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            self.topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.myCartNav.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
           self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
        } else {
            self.topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.myCartNav.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        }
        
        
    }
    
    //MARK: SetUp Text Button
    //set button text for User according to Login, Verify Otp and valid user accordingly
    func setUpbuttonText() {
      if !LoginManagerApi.share.isAccessTokenValid {
       proceedBtn.setTitle("LOGIN/SIGNUP".localizedString, for: .normal)
       return
      }
      if LoginManagerApi.share.me?.isVerified == false {
       proceedBtn.setTitle("VERIFY OTP".localizedString, for: .normal)
       return
      }
       proceedBtn.setTitle("PROCEED".localizedString, for: .normal)
    }
    
      // MARK: - UIActions
      @IBAction func actionBack(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
      }
    
    //MAKR: Apply PromoCode
    /// apply promo code button clicked to apply promo
    func applyPromo() {
      if LoginManagerApi.share.isAccessTokenValid {
         if let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "PromotionsController") as? PromotionsController {
          viewcontroller.isFromSide = false
          viewcontroller.totalAmount = self.price
          viewcontroller.restaurantId = self.resturentId
          self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
      } else {
      customAlert(controller: self, message: "Please login to continue".localizedString)
      }
  }
    
    //MARK:- private
    func profileVerify() -> Bool {
      if LoginManagerApi.share.me?.isVerified == false {
        if let viewController = R.storyboard.main.oTPViewController() {
          self.navigationController?.pushViewController(viewController, animated: true)
        }
        return false
      }
      return true
    }
    
    // MARK: Action for Next ViewController
    @IBAction func nextViewControllerAction(_ sender: Any) {
      //Check Access tookan Login
      if !LoginManagerApi.share.isAccessTokenValid {
        navigationController?.navigationBar.isHidden = false
        if let vc = R.storyboard.main.signInController() {
          self.navigationController?.pushViewController(vc, animated: true)
        }
        return
      }
      //Check Phone Verified
      let isProfileVerified = profileVerify()
      if !isProfileVerified {
        return
      }
       
      //check cart count should be more than 0
      if cartItem.count > 0 {
        if addNoteTypeMessage == "" && addnoteMessage == "Put your Room no. or Bed no." {
                   customAlert(controller: self, message: "Please fill your room number and bed number".localizedString)
                }else{
                     if  price >= minimumOrderValueGet {
                     self.saveCartAtServer()
                     }else{
                        customAlert(controller: self, message: "Your minimum order less. please add more item to cart".localizedString)
                        
            }
              }
//        if  String(minimumOrderValueGet) >= String(totalAmountGet) {
//            self.saveCartAtServer()
//        }else{
//          customAlert(controller: self, message: "Your minimum order less. please add more item to cart".localizedString)
//        }
      } else {
      customAlert(controller: self, message: "Please add item to cart".localizedString)
      }
    }
    
    //MARK: Server Call to save Cart at server
    /// - Server Call to Story local Cart Data to Server
    /// after procceeding booking
    func saveCartAtServer() {
        
      var param: [String: Any] = [:]
        
      var itemArray: [[String: Any]] = []
        param["restaurantId"] = cartItem.first?.resturentId
        param["branchId"] = cartItem.first?.branchId
        
      for item in cartItem {
        let itemId = item.cartItemId
        let quantity = item.itemQuantity
        var addonsArray: [String: Any] = [:]
        if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn] {
          var addonDic: [[String: Any]] = []
          for addon in addons {
            var addonItem: [String: Any] = [:]
            addonItem["addOnId"] = addon.adonId
            addonItem["itemQuantity"] = 1
            addonDic.append(addonItem)
          }
          addonsArray["addOns"] = addonDic
        }
        addonsArray["itemId"] = itemId
        addonsArray["quantity"] = quantity
        itemArray.append(addonsArray)
      }
      param["items"] = itemArray
      if bookingFlow == .home {
      param["bookingType"] = Booking.home.rawValue
      } else {
        param["bookingType"] = Booking.pickUp.rawValue
      }
      print(param)
      AddressModel.saveCart(parameters: param, callBack: {(response: Any?, error: Error?) in
        if error == nil {
          if bookingFlow == .pickup {
            guard let controllers = self.navigationController?.viewControllers else {
                return
            }
            
            print(controllers.description)
            let storyBoard = UIStoryboard(name: Identifier.paymentStoryBoard, bundle: nil)
          guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.paymentOptionViewController) as? PaymentOptionViewController else {
              fatalError("Could not load Controller")
            }
            vc.branchId = self.branchId
            vc.extraInfo = self.extraInfo
            vc.restaurantId = self.resturentId
            self.navigationController?.pushViewController(vc, animated: true)
            
          } else {
            
            guard let controllers = self.navigationController?.viewControllers else {
                return
            }
            print(controllers.description)

            let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
          guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.addressListViewController) as? AddressListViewController else {
            fatalError("Could not load Controller")
          }
            vc.extraInfo = self.extraInfo
            vc.branchId = self.branchId
            vc.restaurantId = self.resturentId
            self.navigationController?.pushViewController(vc, animated: true)
          }
          }
        })
    }
  }
  // MARK: - TableViewDelegate and DataSource
  extension ViewCartController: UITableViewDelegate, UITableViewDataSource {
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
      }
      func numberOfSections(in tableView: UITableView) -> Int {
          return CartItems.count
      }
    
    // numer of rows
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          guard let sectionType = CartItems(rawValue: section) else {
              fatalError()
          }
          switch sectionType {
          case .kitchenDetails:
              return 1
          case .itemDetails:
              return cartItem.count
          case .amountDetails:
              return 1
          }
      }
    //cell for row
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let sectionType = CartItems(rawValue: indexPath.section) else {
              fatalError()
          }
          switch sectionType {
          case .kitchenDetails:
              guard let cell: CartItemTableViewCell = self.viewCartTable.dequeueReusableCell(withIdentifier: Identifier.cartItemTableViewCell) as? CartItemTableViewCell else {
                  fatalError("Couldn't load CartItemTableViewCell")
              }
              if let details = restaurantDetails {
                  cell.setupCell(kitchenDetails: details)
              }
              let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
              
              if isDarkMode == true {
               cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
               cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
               cell.restuarantName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
               cell.restaurantDiscription.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
               cell.deliveryTime.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
              } else {
                cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.restuarantName.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.restaurantDiscription.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.deliveryTime.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
              }
              cell.restuarantName.text = cartItem.first?.branchName
              
              if let deliverytime = cartItem.first?.estimateTime {
                 let deliver = "prepares in".localizedString
                 let min = "Mins".localizedString
                cell.deliveryTime.text = "\(deliver) \(String(describing: Int(deliverytime))) \(min)"
              }
              cell.restaurantDiscription.text = cartItem.first?.resturentDesc
              guard let image = cartItem.first?.image else {
                  fatalError("Image Not Found")
              }
              let imageUrl = URL(string: image)
              cell.itemImage.kf.setImage(with: imageUrl)
              return cell

          case .itemDetails:
              guard let cell: ItemsAddedInCartTable = self.viewCartTable.dequeueReusableCell(withIdentifier: Identifier.itemsAddedInCartTable) as? ItemsAddedInCartTable else {
                  fatalError("Couldn't load ItemsAddedInCartTable")
              }
              let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
              
              if isDarkMode == true {
                cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.quantityView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblItemName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblPriceOfItems.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.quantityLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblAddOnItems.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.addButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                cell.addButton.setImage(UIImage(named: "subW"), for: .normal)
                cell.substractBtn.setImage(UIImage(named: "addW"), for: .normal)
              } else {
                cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.quantityView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.addButton.setImage(UIImage(named: "sub"), for: .normal)
                cell.substractBtn.setImage(UIImage(named: "add"), for: .normal)
                cell.lblItemName.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblPriceOfItems.textColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
                cell.quantityLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblAddOnItems.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.addButton.setTitleColor(#colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1), for: .normal)
              }
              
              cell.addButton.tag = indexPath.row
              cell.substractBtn.tag = indexPath.row
              cell.setupCell(itemDetails: cartItem[indexPath.row])
              
              cell.substractCallBack = {(_ index: Int) in
                self.deleteItem(index: index)
              }
              cell.addCallBack = {(_ index: Int) in
               self.addItem(index: index)
              }
              return cell
            
          case .amountDetails:
            
              guard let cell: PriceDetailsTableView = self.viewCartTable.dequeueReusableCell(withIdentifier: Identifier.priceDetailsTableView) as? PriceDetailsTableView else {
                  fatalError("Couldn't load PriceDetailsTableView")
              }
              let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
              if isDarkMode == true {
                cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.allergiticView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.extraInfoTextField.placeHolderColor = lightWhite
                
                cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.priceDetailsView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.promoDiscountLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.promoDiscount.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblItemsPrice.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblTotalAmount.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.totalAmountTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblNumberOfItems.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.statusMode.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblNumberOfItems.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblNumberOfItems.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.applyPromo.setTitleColor(#colorLiteral(red: 0.9913015962, green: 0.6188052893, blue: 0, alpha: 1), for: .normal)
              } else {
                cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.allergiticView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.extraInfoTextField.textColor = lightGrayColor
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.priceDetailsView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.promoDiscountLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.promoDiscount.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblItemsPrice.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblTotalAmount.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.totalAmountTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblNumberOfItems.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.statusMode.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblNumberOfItems.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.lblNumberOfItems.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
              }
              if UserDefaults.standard.value(forKey: "noteMessage") as? String != "" {
              cell.extraInfoTextField.placeholder = UserDefaults.standard.value(forKey: "noteMessage") as? String
                addnoteMessage = UserDefaults.standard.value(forKey: "noteMessage") as? String ?? ""
                
                }else{
                  cell.extraInfoTextField.placeholder = "Allergic to something? Mention it here…"
                  
                
              }
              cell.extraInfoTextField.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
              
              let sar = "Rs.".localizedString
              if LoginManagerApi.share.promoAmount == 0.0 {
               cell.promoDiscountLbl.isHidden = true
               cell.promoDiscount.isHidden = true
               cell.applyPromo.setTitle("APPLY".localizedString, for: .normal)
               cell.applyPromo.layer.borderColor = UIColor.clear.cgColor
              } else {
                let promo =  "  \(LoginManagerApi.share.promoName) ☓ "
                cell.applyPromo.setTitle(promo, for: .normal)
                cell.applyPromo.layer.borderColor = darkPinkColor.cgColor
                cell.promoDiscountLbl.isHidden = false
                cell.promoDiscount.isHidden = false
                cell.promoDiscount.text = "- \(sar) \(LoginManagerApi.share.promoAmount.roundTo2Decimal())"
              }
              cell.lblItemsPrice.text = "\(sar) \(String(describing: price.roundTo2Decimal()))"
              totalAmountGet = "\(sar) \(String(describing: price.roundTo2Decimal()))"
              cell.lblTotalAmount.isHidden = true
              cell.totalAmountTitle.isHidden = true
              cell.lblNumberOfItems.text = "\(totalQuantity) " + quantityText.localizedString
              //MARK: Rami hide vat
              cell.lblVatPrice.text = "\(sar) \(vatPercentage.roundTo2Decimal())"
              
              cell.lblVatPrice.isHidden = true
              cell.vatTitle.isHidden = true
              cell.lblCanclePrice.isHidden = true
              cell.cancleTitle.isHidden = true
              
               if bookingFlow == .pickup {
               cell.statusMode.text = "Take Away".localizedString
               cell.deliveryChargePrice.isHidden = true
               cell.deliveryChargeTitle.isHidden = true
               } else {
                cell.statusMode.text = "Home Delivery".localizedString
                cell.deliveryChargePrice.isHidden = true
                cell.deliveryChargeTitle.isHidden = true
              }
              cell.applyPromoCallBack = {
               if LoginManagerApi.share.promoAmount == 0.0 {
                self.applyPromo()
               } else {
               LoginManagerApi.share.promoAmount = 0.0
               LoginManagerApi.share.promoName = ""
               self.getCart()
              }
             }
             cell.extraTextField = { (info) in
                self.extraInfo = info
                self.addNoteTypeMessage = info
              }
              return cell
              }
          }
    
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          guard let sectionType = CartItems(rawValue: section) else {
              fatalError()
          }
          if sectionType == .amountDetails {
              return 41
          } else if sectionType == .kitchenDetails {
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                return 0
            } else {
                return 15
            }
          }
          return 0
      }
    
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          guard let sectionType = CartItems(rawValue: section) else {
              fatalError()
          }
          if sectionType == .amountDetails {
              let view = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 41))
              view.backgroundColor = #colorLiteral(red: 0.9913015962, green: 0.6188052893, blue: 0, alpha: 1)
              let label: UILabel = UILabel()
              label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width - 35, height: 41)
              label.text = tableHeaderText.localizedString
              label.font = AppFont.semiBold(size: 16)
            
              view.addSubview(label)
              view.shadowPathCustom(cornerRadius: 0)
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                view.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
                label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
               
            } else {
                view.backgroundColor = #colorLiteral(red: 0.9913015962, green: 0.6188052893, blue: 0, alpha: 1)
                
                label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
           
              return view
          }
          let view = UIView(frame: CGRect.zero)
          view.backgroundColor = lightGrayColor
          view.shadowPathCustom(cornerRadius: 0)
          return view
      }
    
      func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          guard let sectionType = CartItems(rawValue: section) else {
              fatalError()
          }
          if sectionType == .itemDetails {
              let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
              let button: UIButton = UIButton()
              button.frame = view.frame
              button.titleLabel?.font = UIFont(name: fontStyleSemiBold, size: 15.0)
              button.setTitle("+ " + "ADD MORE ITEMS".localizedString, for: .normal)
              button.addTarget(self, action: #selector(selectedMoreItems), for: .touchUpInside)
            
              view.addSubview(button)
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                view.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            } else {
                 view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitleColor(#colorLiteral(red: 0.9913015962, green: 0.6188052893, blue: 0, alpha: 1), for: .normal)
            }
              return view
          }
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = lightGrayColor
        view.shadowPathCustom(cornerRadius: 0)
        return view
      }
      func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionType = CartItems(rawValue: section) else {
          fatalError()
        }
        if sectionType == .amountDetails {
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                 return 0
            } else {
                 return 15
            }
        
        } else if sectionType == .itemDetails {
         return 50
        }
          return 0
      }
      @objc func selectedMoreItems() {
          _  = self.navigationController?.popViewController(animated: true)
      }
  }




  // MARK: For get Cart From Core Data
  extension ViewCartController {
    
    func addItem(index: Int) {
      let item = cartItem[index]
      LoginManagerApi.share.promoAmount = 0.0
      if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn], addons.count > 0 {
        saveItemAndAddons(itemIndex: index, menuDetails: addons)
      } else {
        saveItemAndAddons(itemIndex: index, menuDetails: nil)
      }
   }
    
    func deleteItem(index: Int) {
      LoginManagerApi.share.promoAmount = 0.0
      self.deleteCart(index: index)
    }
    
    
    
      // MARK: Save Cart to Core Data
      /// - add Item to cart
     /// - Check item already added or not
     /// -check item has addons or not'
      func saveItemAndAddons(itemIndex: Int, menuDetails: [CartItemAddOn]? ) {
          if #available(iOS 10.0, *) {
              if let items = fetchSpecificCartArray(index: itemIndex), items.count > 0 {
                  var isMatched: Bool = false
                  for item in items {
                      if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn], addons.count > 0 {
                          if let itemMenu = menuDetails, addons.count == itemMenu.count {
                              let addonArray = addons.filter { addonItem in
                                  return itemMenu.contains { item in
                                      item.adonId == addonItem.adonId
                                  }
                              }
                              if addonArray.count == itemMenu.count {
                                  isMatched = true
                                  let quantity = item.itemQuantity + 1
                                  for addon in addonArray {
                                      let priceCal = (addon.adonsPrice) / Double(item.itemQuantity)
                                      let price = priceCal * Double(quantity)
                                      addon.setValue(price, forKey: "adonsPrice")
                                  }
                                  item.setValue(quantity, forKey: "itemQuantity")
                                  do {
                                      try item.managedObjectContext?.save()
                                  } catch {
                                    
                                  }
                                  break
                              }
                          }
                      }
                  }
                ///if added item not matched local database stored item then add new item
                  if !isMatched {
                      for item in items {
                          if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn], addons.count == 0 {
                              let quantity = item.itemQuantity
                              item.setValue(quantity + 1, forKey: "itemQuantity")
                              do {
                                  try item.managedObjectContext?.save()
                              } catch {
                                
                              }
                              break
                          }
                      }
                  }
                
              }
              getCart()
          }
      }
    
      // MARK: Fetch Cart with Specific id for Core Data
     ///- fetch the cart item from local database to modify accordingly
      func fetchSpecificCartArray(index: Int) -> [CartItem]? {
          let menuId = cartItem[index].cartItemId ?? ""
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return nil
          }
          if #available(iOS 10.0, *) {
              let managedContext = appDelegate.persistentContainer.viewContext
              let formatRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
              formatRequest.predicate = NSPredicate(format: "cartItemId == %@", menuId)
              let fetchedResults = try? managedContext.fetch(formatRequest)
              if let cartItem = fetchedResults {
                  return cartItem
              }
          }
          return nil
      }
    
    // MARK: delete Cart From Core Data
    /// delete the item from local database
    /// if data quantity has 1
    func deleteCart(index: Int) {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      if #available(iOS 10.0, *) {
        let managedContext = appDelegate.persistentContainer.viewContext
          let cart = cartItem[index]
        
           if cart.itemQuantity == 1 {
            managedContext.delete(cart)
           } else {
              let quantity = cart.itemQuantity
              let priceQuantity = Double(quantity)
             if let addons = cart.cartItemAddOns?.allObjects as? [CartItemAddOn], addons.count > 0 {
              for addon in addons {
                  let price = (addon.adonsPrice/priceQuantity)
                  let priceValue = (addon.adonsPrice - price)
                  addon.setValue(priceValue, forKey: "adonsPrice")
              }
              }
              cart.setValue(quantity - 1, forKey: "itemQuantity")
           }
          do {
              try managedContext.save()
          } catch {
            
          }
      }
      getCart()
    }
    
    // MARK: get all cart from Core Data
    ///- get all cart details from stored locally
    func getCart() {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      if #available(iOS 10.0, *) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
        let result = try? managedContext.fetch(fetchRequest)
        guard let resultdata = result as? [CartItem] else {
          return
        }
        calculatePrice(itemList: resultdata)
      }
    }
    
    
    //MARK: Calculate Price
    /// -Get All Item From Cart and Calculate Price
    func calculatePrice(itemList: [CartItem]) {
      cartItem.removeAll()
      cartItem = itemList
        
        if itemList.count > 0 {
            self.branchId = cartItem.first!.branchId!
            self.resturentId = cartItem.first!.resturentId!
        }
      self.price = 0.0
      totalQuantity = 0
      for item in itemList {
        if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn] {
          let addonPrice = addons.reduce(0, {$0 + ($1.adonsPrice )})
          self.price += (Double(addonPrice))
        }
        totalQuantity += Int(item.itemQuantity)
        self.price += (item.itemPrice * Double(item.itemQuantity))
      }

    if cartItem.count == 0 {
    self.navigationController?.popViewController(animated: true)
    }
    var tempPrice = price
    tempPrice  -= LoginManagerApi.share.promoAmount
    if tempPrice < 0 {
    LoginManagerApi.share.promoAmount = price
    tempPrice = 0.0
    }
    if let vat = Double(vat) {
      vatPercentage = (vat/100)*price
    }
        
        if cartItem.count != 0 {
    viewCartTable.reloadData()
        }
  }
}
