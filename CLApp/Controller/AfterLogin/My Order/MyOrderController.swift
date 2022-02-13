//
//  MyOrderController.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

enum BookingType {
    case past
    case upcoming
}

class MyOrderController: CLBaseViewController {

  //MARK: Outlet
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 18)
        }
    }
  @IBOutlet weak var upcomingView: UIView!
    
  @IBOutlet weak var pastView: UIView!
    @IBOutlet weak var upcomingBtn: UIButton! {
        didSet {
            upcomingBtn.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var pastBtn: UIButton! {
        didSet {
            pastBtn.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
  @IBOutlet weak var backBtn: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var upComingOrPastView: UIView!
  //MARK: Variables
  var bookingType: BookingType = .upcoming
  var isFromBooking = false
  var orderList: [OrderModel] = []
  var pastOrderList: [OrderModel] = []
  var orderType: OrderType = .upcoming
  var limit: Int = 15
  private let refreshControl = UIRefreshControl()

  //MARK: View Did Load
  override func viewDidLoad() {
        super.viewDidLoad()
    changeConstraint(controller: self, view: topView)
     tableView.registerCell(Identifier.orderListCell)
     tableView.registerCell(Identifier.pastOrderCell)
     self.navigationController?.navigationBar.isHidden = true
     tableView.delegate = self
    tableView.dataSource = self
    setUpReferece()
    localizedString()
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
  //MARK: Localized String
  func localizedString() {
    pastBtn.setTitle("Past".localizedString, for: .normal)
    upcomingBtn.setTitle("Upcoming".localizedString, for: .normal)
    navTitle.text = "My Orders".localizedString
  }
  
    //MARK: SetUpReferece TableView
    func setUpReferece() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = darkPinkColor
        refreshControl.backgroundColor = whiteColor
        let string = NSMutableAttributedString(string: "Fetching Booking Data ...".localizedString, attributes: [NSAttributedString.Key.font: UIFont(name: fontNameRegular, size: 14) ?? UIFont.systemFontSize])
        refreshControl.attributedTitle = NSAttributedString(attributedString: string)
        refreshControl.addTarget(self, action: #selector(refreshBookingData), for: .valueChanged)
    }
    
    //MARK: Refresh Booking Data
    @objc func refreshBookingData() {
       if bookingType == .past {
        self.getAllPastOrderList(isIndicator: false)
        } else {
        self.getAllOrderList(isIndicator: false)
        }
        self.refreshControl.endRefreshing()
    }
  
  //MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
         if isFromBooking {
         backBtn.changeBackBlackButton()
        }
      showEmptyMessage()
      tableView.backgroundView = LoadingTaskView.loadingTaskView(view: tableView)
      self.getAllOrderList(isIndicator: false)
        checkStatusForDarkMode()
    }
    
    //MARK:- CHECK STATUS OF DARK MODE
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            upComingOrPastView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            backBtn.setImage(UIImage(named: "menu-1"), for: .normal)
            upcomingBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            pastBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            tableView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
             topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             upComingOrPastView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             backBtn.setImage(UIImage(named: "menu"), for: .normal)
             tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             upcomingBtn.setTitleColor(#colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1), for: .normal)
             pastBtn.setTitleColor(#colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1), for: .normal)
             self.navTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            
        }
       
    }
    
    
    
  // MARK: Back Button Clicked
  @IBAction func backAction(_ sender: UIButton) {
    if isFromBooking {
    self.navigationController?.popViewController(animated: true)
    } else {
       let language = Localize.currentLang()
       if language == .arabic {
        self.revealViewController().rightRevealToggle(animated: true)
        return
        }
        self.revealViewController().revealToggle(animated: true)
    }
  }
    
  
  // MARK: Upcoming Button Clicked
  @IBAction func upcomingAction(_ sender: UIButton) {
    tableView.backgroundView = LoadingTaskView.loadingTaskView(view: tableView)
    upcomingView.backgroundColor = darkPinkColor
    pastView.backgroundColor = .white
    bookingType = .upcoming
    topConstraint.constant = 10
    limit = 15
    self.getAllOrderList(isIndicator: false)
    tableView.reloadData()
    orderType = .upcoming
  }
  
  // MARK: Past Button Clicked
  @IBAction func pastAction(_ sender: UIButton) {
    tableView.backgroundView = LoadingTaskView.loadingTaskView(view: tableView)
    upcomingView.backgroundColor = .white
    pastView.backgroundColor = darkPinkColor
    bookingType = .past
    limit = 15
    topConstraint.constant = 0
    getAllPastOrderList(isIndicator: false)
    tableView.reloadData()
    orderType = .past
  }
  
  
  //MARK: Get all Order
  func getAllOrderList(isIndicator: Bool) {
    OrderModel.getAllOrder(isIndicator: isIndicator, limit: limit, status: "2", callBack: { (order: [OrderModel]?, error: Error?) in
    self.tableView.backgroundView = nil
      if error == nil {
       if let data = order {
        self.orderList = data
        }
        if self.orderList.count == 0 {
          self.showMessage()
        } else {
          self.showEmptyMessage()
        }
        self.tableView.reloadData()
      }
      })
  }
  
  
  //MARK: Get all Order
  func getAllPastOrderList(isIndicator: Bool) {
    OrderModel.getAllPastOrder(isIndicator: isIndicator, limit: limit, status: "1", callBack: { (order: [OrderModel]?, error: Error?) in
        self.tableView.backgroundView = nil
      if error == nil {
        if let data = order {
          self.pastOrderList = data
        }
        if self.pastOrderList.count == 0 {
          self.showMessage()
        } else {
          self.showEmptyMessage()
        }
        self.tableView.reloadData()
      }
    })
  }
  
  // Show Empty Message when data found
  func showEmptyMessage() {
    TableViewHelper.emptyMessage(message: "", viewController: tableView)
  }
  
  // Show Message when not data found
  func showMessage() {
    TableViewHelper.emptyMessage(message: "No Orders Found!".localizedString, viewController: tableView)
    }
  
  
  // MARK: View Order Detial
  func viewOrderDetail(orderId: Int, bookingId: String) {
    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.orderDetailViewController) as? OrderDetailViewController else {
       return
    }
    vc.orderId = orderId
    vc.bookigId = bookingId
    vc.orderType = orderType
    vc.rateSuccessfull = {
        
      self.getAllPastOrderList(isIndicator: false)
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //MARK: Reason PopUp to Cancel Booking
  func cancelReasonPopUp(orderId: Int, bookingId: String) {
   let orderCancel = OrderCancelReasonPopUp(nibName: Identifier.orderCancelReasonPopUp, bundle: nil)
    orderCancel.orderId = orderId
    orderCancel.bookingId = bookingId
    orderCancel.orderSuccess = {
      self.getAllOrderList(isIndicator: true)
    }
    orderCancel.modalPresentationStyle = .overCurrentContext
    orderCancel.modalTransitionStyle = .crossDissolve
    self.present(orderCancel, animated: true, completion: nil)
  }
  
  
  // MARK: Cancel Order Detail
    func cancelOrder(orderId: Int, bookingId: String, modeOfPayment: String, amount: Double) {
    let orderCancel = OrderCancelPopUpViewController(nibName: Identifier.orderCancelPopUpViewController, bundle: nil)
    orderCancel.yesCancelCallback = {
      self.cancelReasonPopUp(orderId: orderId, bookingId: bookingId)
    }
    orderCancel.orderId = "#\(orderId)"
    orderCancel.bookingId = bookingId
    orderCancel.modeOfPayment = modeOfPayment
    orderCancel.totalAmount = amount
    orderCancel.modalPresentationStyle = .overCurrentContext
    orderCancel.modalTransitionStyle = .crossDissolve
    self.present(orderCancel, animated: true, completion: nil)
  }
}

// MARK: UITableView Delegate and Data Source
extension MyOrderController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if bookingType == .past {
      let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
      view.backgroundColor = headerLight
      return view
    }
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     if bookingType == .past {
      return 0
     }
    return 0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if bookingType == .past {
      return pastOrderList.count
    }
    return orderList.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if bookingType == .past {
        return 1
    }
    return 1
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if tableView.contentOffset.y >= tableView.contentSize.height {
      if bookingType == .past {
        limit += 15
        self.getAllPastOrderList(isIndicator: false)
      } else {
        limit += 15
        self.getAllOrderList(isIndicator: false)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if bookingType == .past {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.pastOrderCell) as? PastOrderCell else {
        fatalError("Could not load nib AddressListCell")
      }
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.priceLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.firstAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.secondAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
            } else {
            
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.priceLabel.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.firstAddress.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.secondAddress.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        }
       let data = pastOrderList[indexPath.section]
       cell.updateCell(data: data)
       cell.viewOrder.tag = indexPath.section
       cell.viewOrderCallBack = { tag in
        if let id = self.pastOrderList[tag].oderId, let bookingId = self.pastOrderList[tag].bookingId {
        self.viewOrderDetail(orderId: id, bookingId: bookingId)
        }
        }
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.orderListCell) as? OrderListCellTableViewCell else {
      fatalError("Could not load nib AddressListCell")
    }
    let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
    
    if isDarkMode == true {
        
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.gapCellView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.priceText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.firstAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.secondAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.orderViewDeatilsView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.viewOrder.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.cancelOrder.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        
    } else {
        
        cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.priceText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.gapCellView.backgroundColor = lightWhite
        cell.firstAddress.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.secondAddress.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.orderViewDeatilsView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.viewOrder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.cancelOrder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    }
    
    
    let data = orderList[indexPath.section]
    cell.updateCell(order: data)
    cell.cancelOrder.tag = indexPath.section
    cell.viewOrder.tag = indexPath.section
    if data.orderStatus == 5 || data.orderStatus == nil {
        cell.lblPaymentProcess.isHidden = false
        cell.heightLblPaymentProcess.constant = 30
    }else{
        cell.lblPaymentProcess.isHidden = true
         cell.heightLblPaymentProcess.constant = 0
    }
    cell.cancelOrderCallBack = { tag in
        if let id = self.orderList[tag].oderId, let bookingId = self.orderList[tag].bookingId, let paymentMode = self.orderList[tag].paymentMode, let amount = self.orderList[tag].totalAmount {
        self.cancelOrder(orderId: id, bookingId: bookingId, modeOfPayment: paymentMode, amount: amount)
      }
    }
    cell.viewOrderCallBack = { tag in
       if let id = self.orderList[tag].oderId, let bookingId = self.orderList[tag].bookingId {
      self.viewOrderDetail(orderId: id, bookingId: bookingId)
      }
    }
    return cell
  }
}
