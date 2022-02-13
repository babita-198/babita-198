//
//  OrderDetailViewController.swift
//  FoodFox
//
//  Created by Anand Verma on 06/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

//MARK: Order Section Enum
enum OrderSection: Int, CaseCountable {
    case rate
    case item
    case address
    case amount
  var name: String {
    switch self {
    case .rate:
      return "Rate"
    case .item:
      return "Item"
    case .address:
      return "ADDRESS DETAILS"
    case .amount:
      return "PRICE DETAILS"
    }
  }
}

//MARK: Address Status Enum
enum AddressStatus: Int, CaseCountable {
  case home = 1
  case work
  case other

  var statusType: String {
    switch self {
    case .home:
         return "Home"
    case .work:
        return "Work"
    case .other:
      return "Other"
    }
  }
}

class OrderDetailViewController: UIViewController {
    //MARK: Outlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var topNavView: UIView!
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var trackButton: UIButton! {
        didSet {
            trackButton.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var cancelOrder: UIButton! {
        didSet {
            cancelOrder.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
  @IBOutlet weak var bottomStackView: UIStackView!
  @IBOutlet weak var backBtn: UIButton!
  
  //MARK: Variables
  var orderId = 0
  var bookigId = ""
  var orderDetial: OrderModel = OrderModel()
  var orderType: OrderType = .past
  var rateSuccessfull: (() -> Void)?
  
  override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.changeBackBlackButton()
        setupTableView()
        setData()
        tableView.backgroundView = LoadingTaskView.loadingTaskView(view: tableView)
    }

  override func viewWillAppear(_ animated: Bool) {
    trackButton.isHidden = true
    cancelOrder.isHidden = true
    self.setButtonStatus()
    self.getOrderDetail()
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    localizedString()
    checkStatusForDarkMode()
    
  }
  
  func localizedString() {
    trackButton.setTitle("TRACK ORDER".localizedString, for: .normal)
    cancelOrder.setTitle("CANCEL ORDER".localizedString, for: .normal)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    print("--------------\(tableView.bounds.height)")
  }
  //MARK: Setup Cell
  func setupTableView() {
    tableView.registerCell(Identifier.orderRatingCellTableViewCell)
    tableView.registerCell(Identifier.itemTableViewCell)
    tableView.registerCell(Identifier.orderAddressCell)
    tableView.registerCell(Identifier.priceDetailsTableView)
   
  }
  
  
    
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.topNavView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.tableView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
           
            self.cancelOrder.backgroundColor = lightBlackColor
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            self.topNavView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.cancelOrder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.navTitle.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        }
    }
  // MARK: Set Order Track and Order Cancel Visibility
  func setStatus() {
    if orderType == .past {
      trackButton.isHidden = true
      cancelOrder.isHidden = true
      //bottomStackView.removeFromSuperview()
    } else {
        trackButton.isHidden = false
        cancelOrder.isHidden = false
    }
  }
  
  //MARK: Set Data
  func setData() {
    navTitle.text = "#\(orderId)"
  }
  
  // MARK: Get Order Detail
  func getOrderDetail() {
    let id = bookigId
   // rating()
    OrderModel.getOrderDetail(orderId: id, callBack: { (order: OrderModel?, error: Error?) in
        self.tableView.backgroundView = nil
      if error == nil {
        self.setStatus()
        if let data = order {
            
         self.orderDetial = data
            
            if self.orderDetial.orderStatus == 5 || self.orderDetial.orderStatus == 12 || self.orderDetial.orderStatus == 9 || self.orderDetial.orderStatus == nil {
                self.trackButton.isHidden = true
            }else{
                self.trackButton.isHidden = false
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.rating()
        self.tableView.reloadData()
      }
    })
  }
  
  
  //MARK: Show Rating Popup
  func rating() {
    if let status = self.orderDetial.orderStatus, let tookanStatus = self.orderDetial.tookanStatus {
      if status == 2 && tookanStatus == 2 && self.orderDetial.ratePopup == 0 {
        trackButton.isHidden = true
        cancelOrder.isHidden = true
        rateView()
      }
        
    }
  }
  
  //MARK: Set Cancel Button Status
  func setButtonStatus() {
    if let status = self.orderDetial.orderStatus, let tookanStatus = self.orderDetial.tookanStatus {
      if status == 4 && tookanStatus == 4 {
        self.cancelOrder.isHidden = true
      } else if status == 1 && tookanStatus == 7 {
        cancelOrder.isHidden = true
      } else if status == Driver.driverFailed.rawValue  && tookanStatus == 6 {
        cancelOrder.isHidden = true
      } else {
        cancelOrder.isHidden = false
      }
    }
    
  }
  
  // MARK: BackButton
  @IBAction func backButtonAction(_ sender: UIButton) {
    
    if orderType == .past {
      if let call = rateSuccessfull {
        call()
       self.navigationController?.popViewController(animated: true)
        return
      }
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: Track Order
  @IBAction func trackOrderButton(_ sender: UIButton) {
    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.trackOrderViewController) as? TrackOrderViewController else {
      return
    }
    vc.bookingId = self.bookigId
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: Cancel Order
  @IBAction func cancelOrder(_ sender: UIButton) {
    self.cancelOrder(orderId: orderId, bookingId: bookigId)
  }
  
  
  // MARK: Cancel Order Detail
  func cancelOrder(orderId: Int, bookingId: String) {
    let orderCancel = OrderCancelPopUpViewController(nibName: Identifier.orderCancelPopUpViewController, bundle: nil)
    orderCancel.yesCancelCallback = {
      self.cancelReasonPopUp(orderId: orderId, bookingId: bookingId)
    }
    orderCancel.orderId = "#\(orderId)"
    orderCancel.bookingId = bookingId
    orderCancel.modeOfPayment = orderDetial.paymentMode ?? ""
    orderCancel.totalAmount = orderDetial.totalPaidAmount ?? 0.0
    orderCancel.modalPresentationStyle = .overCurrentContext
    orderCancel.modalTransitionStyle = .crossDissolve
    self.present(orderCancel, animated: true, completion: nil)
  }
  
  //MARK: Rate
  func rateView() {
    self.trackButton.isHidden = true
    self.cancelOrder.isHidden = true
      let rate = RatingPopUpViewController(nibName: "RatingPopUpViewController", bundle: nil)
         rate.modalPresentationStyle = .overCurrentContext
         rate.modalTransitionStyle = .crossDissolve
         rate.bookingId = self.bookigId
         rate.name = orderDetial.restaurantName ?? ""
         print("*********\(orderDetial.restaurantName ?? "")")
         rate.deliveryTime = orderDetial.jobDeliveryDateTime ?? ""
         rate.ratingSuccess = {
           self.getOrderDetail()
         }
    self.orderType = .past
        self.trackButton.isHidden = true
        self.cancelOrder.isHidden = true
        self.present(rate, animated: true, completion: nil)
    }
    
//MARK: Reason PopUp to Cancel Booking
  func cancelReasonPopUp(orderId: Int, bookingId: String) {
    let orderCancel = OrderCancelReasonPopUp(nibName: Identifier.orderCancelReasonPopUp, bundle: nil)
    orderCancel.orderId = orderId
    orderCancel.bookingId = bookingId
    orderCancel.orderSuccess = {
      self.trackButton.isHidden = true
      self.cancelOrder.isHidden = true
    }
    orderCancel.modalPresentationStyle = .overCurrentContext
    orderCancel.modalTransitionStyle = .crossDissolve
    self.present(orderCancel, animated: true, completion: nil)
  }
  
  // MARK: Call Function
  func calltoRestaurant(phoneNumber: String) {
    let contactSupport = phoneNumber.trimmed()
    guard appDelegate.makePhoneCall(phoneNumber: contactSupport) else {
       customAlert(controller: self, message: "Not able to make phone call ".localizedString)
      return
    }
  }
}

//MARK: TableView Delegate and DataSource
extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let sectionType = OrderSection(rawValue: section) else {
      fatalError()
    }
    if sectionType == .amount || sectionType == .address {
      let view = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 35))
      //view.backgroundColor = lightGrayColor
      let label: UILabel = UILabel()
      label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width - 30, height: 35)
      label.text = sectionType.name.localizedString
      label.font = UIFont(name: fontStyleSemiBold, size: 14.0)
      //label.textColor = lightBlackColor
      view.addSubview(label)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            view.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            label.textColor = lightBlackColor
            
        }
      return view
    }
    let view = UIView(frame: CGRect.zero)
    view.backgroundColor = lightGrayColor
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let sectionType = OrderSection(rawValue: section) else {
      fatalError()
    }
     if sectionType == .amount || sectionType == .address {
     return 35
     } else {
      return 0
    }
  }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let sectionType = OrderSection(rawValue: section) else {
        fatalError()
      }
       if sectionType == .item {
         return orderDetial.item.count
       }
       return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return OrderSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = OrderSection(rawValue: indexPath.section) else {
            fatalError()
        }
        switch sectionType {
        case .rate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.orderRatingCellTableViewCell) as? OrderRatingCellTableViewCell else {
                fatalError("Couldn't load OrderRatingCellTableViewCell")
            }
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.itemName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.itemName.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
               
            }
           
            cell.updateCell(data: orderDetial)
            cell.phoneCallBack = {(phoneNumber) in
              self.calltoRestaurant(phoneNumber: phoneNumber)
            }
            return cell
        case .item:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.itemTableViewCell) as? ItemTableViewCell else {
            fatalError("Couldn't load ItemTableViewCell")
          }
          
          let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
          
          if isDarkMode == true {
            cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.itemName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.addOnItemName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.itemQuantity.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
          } else {
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.itemName.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.addOnItemName.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
             cell.itemQuantity.textColor = #colorLiteral(red: 0.4308055639, green: 0.4194943905, blue: 0.4278305769, alpha: 1)
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
          }
          let data = orderDetial.item[indexPath.row]
         
          
          cell.updateCellData(data: data)
          cell.bottomView.isHidden = false
          if indexPath.row == (orderDetial.item.count - 1) {
           cell.bottomView.isHidden = true
          }
          return cell
          
        case .address:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.orderAddressCell) as? OrderAddressCell else {
            fatalError("Couldn't load AddressListCell")
          }
          let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
          
          if isDarkMode == true {
            cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.firstAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.secondAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
          } else {
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.firstAddress.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.secondAddress.textColor = #colorLiteral(red: 0.4308055639, green: 0.4194943905, blue: 0.4278305769, alpha: 1)
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
          }
          cell.selectionStyle = .none
          cell.updateCell(address: orderDetial)
          return cell
        case .amount:
          guard let cell: PriceDetailsTableView = tableView.dequeueReusableCell(withIdentifier: Identifier.priceDetailsTableView) as? PriceDetailsTableView else {
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
            cell.applyPromo.setTitleColor(#colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1), for: .normal)
            
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
          cell.selectionStyle = .none
          cell.bottomView.isHidden = true
          cell.updateCell(data: orderDetial)
//          cell.lblVatPrice.isHidden = true
//          cell.vatTitle.isHidden = true
          cell.cancleTitle.isHidden = true
          cell.lblCanclePrice.isHidden = true
          return cell
        }
    }
}
