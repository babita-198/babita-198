      //
      //  PaymentOptionViewController.swift
      //  FoodFox
      //
      //  Created by clicklabs on 04/12/17.
      //  Copyright © 2017 Click-Labs. All rights reserved.
      //
      
      import UIKit
      import CoreData
      import Razorpay
      import SwiftyJSON
      
      class PaymentOptionViewController: UIViewController, RazorpayResultProtocol,RazorpayPaymentCompletionProtocol, UITableViewDataSource, UITableViewDelegate {
        func onComplete(response: [AnyHashable : Any]) {
            signatureRazorPayment = response["razorpay_signature"] as? String ?? ""
            paymentRazorPayId   =  response["razorpay_payment_id"] as? String ?? ""
           
            
        }
        
        func onPaymentError(_ code: Int32, description str: String) {
//            let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            //self.slidingPayButton.reset()
            self.createFailureTaskAction(transactionId: trsansationID)
            //customAlert(controller: self, message: "\(str)")
        }
        
        func onPaymentSuccess(_ paymentid: String) {
            
//             let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(paymentid)", preferredStyle: .alert)
//               let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//               alertController.addAction(cancelAction)
//               self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            trsansationID = "\(paymentid)"
            self.createTaskAction(transactionId: trsansationID)
//            customAlert(controller: self, message: "Payment Id \(paymentid)")
        }
        
        
        var razorpay: RazorpayCheckout!
        var idRazorPayment:String = ""
         var paymentRazorPayId = ""
        //MARK: Outlet
        @IBOutlet weak var slideView: UIView!
         @IBOutlet weak var topView: UIView!
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var navTitle: UILabel! {
            didSet {
                navTitle.font = AppFont.semiBold(size: 15)
            }
        }
        @IBOutlet weak var slidingPayButton: MMSlidingButton! {
            didSet {
                slidingPayButton.buttonFont = AppFont.semiBold(size: 13)
            }
        }
        @IBOutlet weak var swipeToOrderLabel: UILabel! {
            didSet {
                swipeToOrderLabel.font = AppFont.semiBold(size: 13)
            }
        }
        @IBOutlet weak var backBtn: UIButton!
        
        //MARK: Variables
        fileprivate var transactionObject: TransactionModel!
         var firstTap = ""
        var comeFrom = "fail"
        var restaurantId = ""
        var branchId = ""
        var addressId = ""
        var extraInfo = ""
        var totalPrice = Double()
        var orderId = ""
        var isFromMap = false
        var checkSelected: PaymentType = .noselect
        var deliveryPrice = 0.0
        var minOrder = 0.0
        var tax = 0.0
        var price = 0.0
        var quantity = 0
        var cancleCharge = 0.0
        var bookingId = ""
        var list: [String] = []
        let priceString = "Price".localizedString
        let qty = "Qty".localizedString
        var object1 = ""
        
        var rozarpayGetID = ""
        var rozarpayGetAmmount = ""
        var defaultType = ""
        //MARK: View did load
        override func viewDidLoad() {
            super.viewDidLoad()
            self.transactionObject = TransactionModel()
            slidingPayButton.delegate = self
            slideView.isHidden = true
            tableViewSetUp()
            getPaymentMethod()
            backBtn.changeBackBlackButton()
            // Adding observer to dismiss the hyperpay view
            NotificationCenter.default.addObserver(self, selector: #selector(self.dismissCheckOut), name: NSNotification.Name(rawValue: "dismissCheckOut"), object: nil)
            
            //razorpay config //rzp_test_07GTeXqFkUKVBP //rzp_test_ytnpai8ASZVxgP
            razorpay = RazorpayCheckout.initWithKey("rzp_live_hKwqSc1khRqWTi", andDelegate: self)

        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            checkStatusForDarkMode()
        }
        
        //MARK:- CHECK STATUS OF DARK MODE
        func checkStatusForDarkMode( ) {
        
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
                 backBtn.setImage(UIImage(named: "newBack"), for: .normal)
                tableView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            } else {
                topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                 backBtn.setImage(UIImage(named: "ic_back"), for: .normal)
                tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.navTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                
            }
            
        }
        // MARK: Steup Cell and TableView
        func tableViewSetUp() {
            tableView.estimatedRowHeight = 100
            tableView.registerCell(Identifier.priceDetailsTableView)
            tableView.registerCell(Identifier.cardTableViewCell)
            tableView.registerCell(Identifier.discountCell)
            tableView.reloadData()
        }
        
        // MARK: Localized String PaymentOptionViewController
        func localizedString() {
            swipeToOrderLabel.text = "SWIPE TO CONFIRM >>".localizedString
            slidingPayButton.buttonUnlockedText = "Order Placed".localizedString
            navTitle.text = "Complete Payment".localizedString
            let pay = "PAY".localizedString
            let sar = "Rs.".localizedString
            slidingPayButton.buttonText = "\(pay) \(sar) \(totalPrice.roundTo2Decimal())"
            swipeToOrderLabel.textAlignment = .right
        }
        
        //MARK: Get Payment Method List
        func getPaymentMethod() {
            var param: [String: Any] = [:]
            param["restaurantId"] = restaurantId
            param["branchId"] = branchId
            if bookingFlow == .home {
                param["bookingType"] = Booking.home.rawValue
                param["addressId"] = addressId
            } else {
                param["bookingType"] = Booking.pickUp.rawValue
            }
            print(param)
            PaymentModel.getList(param: param, callBack: { (payment: PaymentModel?, error: Error?) in
                if error != nil {
                    self.showMessage()
                }
                if let list = payment {
                    self.slideView.isHidden = false
                    //MARK:- Rami Code Here
                    print("payment model", list.paymentList)
                    //self.list=list.paymentList.filter{$0 != "1"}
                    self.list = list.paymentList
                    print("payment model list", self.list)

                    LoginManagerApi.share.me?.walletAmount = list.walletAmount ?? 0.0
                    self.deliveryPrice = list.deliveryPrice ?? 0.0
                    self.tax = list.tax ?? 0.0
                    self.minOrder = list.minOrder ?? 0.0
                    self.cancleCharge = list.cancellationCharges ?? 0.0
                    self.list.sort()
                   // self.list.append(PaymentType.wallet.rawValue)
                       print("after adding wallet raw value payment model list", self.list)
                    self.getCart()
                }
            })
        }
        
        // Show Message when not data found
        func showMessage() {
            slideView.isHidden = true
            TableViewHelper.emptyMessage(message: "notFoundAddress".localizedString, viewController: tableView)
        }
        
        //MARK: Pop ViewController
        @IBAction func backButtonAction(_ sender: Any) {
            if bookingFlow == .pickup {
                self.navigationController?.popViewController(animated: true)
                return
            }
            if isFromMap {
                if let viewControllers = self.navigationController?.viewControllers {
                    if viewControllers.count > 3 {
                        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        // MARK: Push to next Controller
        func nextController() {
            LoginManagerApi.share.promoAmount = 0.0
            LoginManagerApi.share.promoName = ""
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.orderDoneViewController) as? OrderDoneViewController else {
                return
            }
            vc.orderId = self.orderId
            vc.bookingId = self.bookingId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        @objc func dismissCheckOut() {
            DispatchQueue.main.async {
                providerCheckOut?.dismissCheckout(animated: true) {
                    trsansationID = self.transactionObject.transactionId
                    self.createTaskAction(transactionId: self.transactionObject.transactionId)
                }
            }
        }
        func createFailureTaskAction(transactionId: String? = nil) {
                   
                   var param: [String: Any] = [:]
                   if bookingFlow == .home {
                       param["addressId"] = addressId
                   }
//                   if  checkSelected.payemtKey == "2"
//
//                   {
//                   param["transactionId"] = ""
//                   param["paymentId"] =  ""
//                   param["signature"] = ""
//                   print(param["transactionId"])
//                   }
             if  checkSelected.payemtKey == "2"
{
    param["razorpayOrderId"] = rozarpayGetID
    
            }
                   
                   param["restaurantId"] = restaurantId
                   param["branchId"] = branchId
                   param["amount"] = totalPrice
                   
                   param["bookingDateTime"] = convertInUTC()
                   
                   
                   param["modeOfPayment"] = checkSelected.payemtKey
                   
                    param["deviceType"] = deviceType
                   if extraInfo != "" {
                       param["description"] = extraInfo
                   }
                   
                   param["bookingType"] = Booking.pickUp.rawValue
                   param["creditsUsed"] = 0
                   if LoginManagerApi.share.promoName != "" {
                       param["promoCode"] = LoginManagerApi.share.promoName
                       print(param["promoCode"])
                   }
                   param["timezone"] = "\(TimeZone.current.secondsFromGMT()/60)"
                   
                   print(param)
                   CartModel.createTaskAction(parameters: param, callBack: { (value: [String: Any]?, error: Error?) in
                       if error == nil {
                           print(value)
                           guard let data = value else {
                               return
                           }
                           guard let orderId = data["bookingNo"] as? Int else {
                               return
                           }
                           guard let id = data["bookingId"] as? String else {
                               return
                           }
                           self.orderId = "\(orderId)"
                           self.bookingId = id
                           self.nextController()
                       } else {
                           DispatchQueue.main.async {
                            
                               self.slidingPayButton.reset()
                            
                           }
                       }
                   })
               }
        
        // MARK: Create Task
        func createTaskAction(transactionId: String? = nil) {
            
            var param: [String: Any] = [:]
            if bookingFlow == .home {
                param["addressId"] = addressId
            }
            if  checkSelected.payemtKey == "2"

            {
            param["transactionId"] = rozarpayGetID
            param["paymentId"] =  paymentRazorPayId
            param["signature"] = signatureRazorPayment
            param["razorpayOrderId"] = rozarpayGetID
                
            print(param["transactionId"])
            }
            
            
            param["restaurantId"] = restaurantId
            param["branchId"] = branchId
            param["amount"] = totalPrice
            
            param["bookingDateTime"] = convertInUTC()
            
            if  defaultType ==  "1"{
                param["modeOfPayment"] = "1"
            }else{
                 param["modeOfPayment"] = checkSelected.payemtKey
            }
           
        if extraInfo != "" {
                param["description"] = extraInfo
            }
             param["deviceType"] = deviceType
            param["bookingType"] = Booking.pickUp.rawValue
            param["creditsUsed"] = 0
            if LoginManagerApi.share.promoName != "" {
                param["promoCode"] = LoginManagerApi.share.promoName
                print(param["promoCode"])
            }
            param["timezone"] = "\(TimeZone.current.secondsFromGMT()/60)"
            
            print(param)
            CartModel.createTaskAction(parameters: param, callBack: { (value: [String: Any]?, error: Error?) in
                if error == nil {
                    print(value)
                    guard let data = value else {
                        return
                    }
                    guard let orderId = data["bookingNo"] as? Int else {
                        return
                    }
                    guard let id = data["bookingId"] as? String else {
                        return
                    }
                    self.orderId = "\(orderId)"
                    self.bookingId = id
                    self.nextController()
                } else {
                    DispatchQueue.main.async {
                        
//                        let alertController = UIAlertController(title: "", message: , preferredStyle: .alert)
//                        let cancelAction = UIAlertAction(title: "Thank you for choosing FoodFox. We are processing your payment & update you once payment received", style: .cancel, handler: nil)
//                        alertController.addAction(cancelAction)
//                        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)

                        self.slidingPayButton.reset()
                    }
                }
            })
        }
        
        // MARK: get all cart from Core Data
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
                self.calculatePrice(cartList: resultdata)
            }
        }
        
        //MARK: Calculate Price
        /// - Get Item From Local Storage and Calculate Price
        func calculatePrice(cartList: [CartItem]) {
            self.price = 0.0
            for item in cartList {
                if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn] {
                    let addonPrice = addons.reduce(0, {$0 + ($1.adonsPrice )})
                    self.price += addonPrice
                }
                quantity += Int(item.itemQuantity)
                self.price += (item.itemPrice * Double(item.itemQuantity))
            }
            
            totalPrice = 0.0
            var tempPrice = price
            if bookingFlow == .home {
                totalPrice += deliveryPrice
            }
            tempPrice  -= LoginManagerApi.share.promoAmount
            if tempPrice <= 0 {
                LoginManagerApi.share.promoAmount = price
                tempPrice = 0.0
            }
            let vatPer = (tax/100)*price
            totalPrice += (tempPrice + vatPer + cancleCharge)
            
            tableView.delegate = self
            tableView.dataSource = self
            self.tableView.reloadData()
            self.localizedString()
            slidingPayButton.setStyle()
            slidingPayButton.setUpButton()
        }
        
        //MARK: CheckBox clicked
//        func editButtonClicked(cell: CardTableViewCell) {
//            cell.checkBoxBtn.isSelected = true
//
//            tableView.reloadData()
//        }
      }
      
      //MARK: Slide Button Delegate
      extension PaymentOptionViewController: SlideButtonDelegate {
        func buttonStatus(status: String, sender: MMSlidingButton) {
            
            //check mini delivery cost with added item cost
            if minOrder > self.price {
                let msg = "Minimum order amount must be".localizedString
                let sar = "Rs.".localizedString
                customAlert(controller: self, message: "\(msg) \(sar) \(minOrder)")
                slidingPayButton.reset()
                return
            }
            if checkSelected == .noselect {
                createTaskAction()
                //customAlert(controller: self, message: "Select Payment mode to create an order.")
                //slidingPayButton.reset()
            } else  {
                if checkSelected == .cashOnDelivery || checkSelected == .wallet {
                    createTaskAction()
            
                } else {
                    // Credit Card Selected
                    self.buttonClicked()
                    //            customAlert(controller: self, message: "Only Cash On Delivery and App Wallet are allowed".localizedString)
                    //            slidingPayButton.reset()
                }
            }
            
        }
      }
      
      // Payment Option View Controller
      extension PaymentOptionViewController {
        
        func serverCallForPostPayment() {
            
            var parameter = ["": ""]
            
            if checkSelected == .cashOnDelivery {
                parameter = ["payment_type": "cash_on_delivery"]
            } else if checkSelected == .wallet {
                parameter = ["payment_type": "use_my_credit"]
            } else {
                
                  //parameter = ["payment_type": "mada", "transaction_id": trsansationID, "addressId": self.addressId]
                parameter = ["payment_type": "VISA", "transaction_id": trsansationID, "addressId": self.addressId]
            }
             print("post transation parameters", parameter)
            PaymentManager.postTransaction(paramerer: parameter, callBack: {[weak self](response: OrderModel?, error: Error?) in
                print("post transation repsonse", response ?? "null")
                if error == nil {
                    // paymentTypeToSend = ""
                    trsansationID = ""
                    print("success")
                } else {
                    self?.slidingPayButton.reset()
                }
            })
        }
        
        //
        func buttonClicked() {
            
            //        if self.selectedPaymentOption.id < 0 {
            //            showAlert(message: "Please select payment method".localized)
            //            return
            //        }
            
            
//            PaymentManager.getTransactionCheckOut(amount: totalPrice.roundTo2Decimal(), callBack: {[weak self] (response: TransactionModel?, error: Error?) in
                
                
//                print("payment card response", response ?? "null")
//                if let response = response {
//                    self?.transactionObject = response
//                }
                if self.checkSelected == .cashOnDelivery || self.checkSelected == .wallet {
                    self.serverCallForPostPayment()
                } else {
//                       print("payment card option chose" , response?.sourceType, response?.txnType, response?.transactionId)
                    /*if error == nil, let data = response {
                        HyperPaymentManager.startPayement(currentTransactionModel: data, callBack: {[weak self](response: OPPTransaction?, error: Error?) in
                            print("payment card option chose", response ?? "null")
                            if error != nil {
                                 print("payment card error nil")
                                self?.serverCallForPostPayment()
                            } else {
                                self?.slidingPayButton.reset()
                            }
                        })
                    }*/
                    self.callRozarPayApi()
                }
//            })
        }
        //,"restaurantId": restaurantId,"branchId":branchId
            func callRozarPayApi()
            {
                let amount = totalPrice
                let queryString = "com.qawafeltech.FoodStar.payments://test"
                let parameters: [String: Any] = ["amount": amount ,"shopperResultUrl": queryString,"deviceType": deviceType,"date": convertInUTC(),"modeOfPayment": checkSelected.payemtKey,"restaurantId": restaurantId,"branchId":branchId]
                                     HTTPRequest(method: .post, path: "api/customer/paymentCheckout",
                                                 parameters: parameters,
                                                 encoding: .url,
                                                 files: nil)
                          .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                            
                          if response.error != nil {
                              return
                          }
                            print(parameters)
                              let orderID = response
                              print("--------------------------")
                              print(response)
                             
                              if let jsonData = response.value as? [String: Any] {
                                  let object = TransactionModel(jsonData: jsonData)
                                  self.object1 = object.id
                                
                                  print(object.id)
                                  self.rozarpayGetID = self.object1
                                print(object.amount)
                                  self.rozarpayGetAmmount = object.amount
                                
                                
                              }
                            if self.checkSelected == .cashOnDelivery || self.checkSelected == .wallet {
                                self.createTaskAction(transactionId: self.object1)
                                       
                                           } else {
                                               // Credit Card Selected
                                               self.showPaymentForm()
                                           }
                              print("--------------------------")
                          }
                
        }
        
        
        internal func showPaymentForm() {
//            let options: [String: Any] = [
//                        "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
//                        "currency": "INR",//We support more that 92 international currencies.
//                        "description": "purchase description",
//                        "order_id": "order_4xbQrmEoA5WJ0G",
//                        "image": "https://url-to-image.png",
//                        "name": "business or product name",
//                        "prefill": [
//                            "contact": "9797979797",
//                            "email": "foo@bar.com"
//                        ],
//                        "theme": [
//                            "color": "#F37254"
//                        ]
//                    ]
          
            
            guard let me = LoginManagerApi.share.me else {
                return
            }
            
        
         let contact = (me.firstName ?? "") + " " + (me.lastName ?? "")
            let options:[String: Any] = [
                            "amount": rozarpayGetAmmount ,
                //mandatory in paise like:- 1000 paise ==  10 rs
                            "currency": "INR",
                            "description": "purchase description",
                            "image": "https://d1wer31vzotqp8.cloudfront.net/documents/documents/Document_18LMJtEjQawkMZtPCcbO_medium.png.png",
                            "name": "\(contact)",
                         "order_id": rozarpayGetID,
                            "prefill": [
                            "contact": me.mobile!,
                            "email": me.email!,
                                
                            ],
                            "theme": [
                                "color": "#FF9300"
                            ]
                        ]
            print("-----------")
            print(options)
            print("-----------")
            self.razorpay.open(options)
//             createTaskAction()
            
                         
        }
        
       
      }
      
      
      // MARK: TableView DataSource and Delegate
      extension PaymentOptionViewController {
        
      
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let sectionType = PaymentSection(rawValue: section) else {
                fatalError()
            }
            if sectionType == .payment {
                return list.count
            }
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            guard let sectionType = PaymentSection(rawValue: indexPath.section) else {
                fatalError()
            }
            if sectionType == .payment {
                return 70
            }
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let sectionType = PaymentSection(rawValue: section) else {
                fatalError()
            }
            let view = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 40))
            view.backgroundColor = UIColor(red: 240/255, green: 115/255, blue: 73/255, alpha: 1.0)
            let label: UILabel = UILabel()
            label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width - 35, height: 40)
            label.text = sectionType.headerString.uppercased().localizedString
            label.font = AppFont.bold(size: 18)
            label.textColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            view.addSubview(label)
            view.shadowPathCustom(cornerRadius: 0)
            
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            if isDarkMode == true {
                
                view.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            } else {
                view.backgroundColor = UIColor(red: 250/255, green: 140/255, blue: 05/255, alpha: 1.0)
                label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                
            }
            
            
            return view
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            print("payment section count", PaymentSection.count)
            return PaymentSection.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let sectionType = PaymentSection(rawValue: indexPath.section) else {
                fatalError()
            }
            switch sectionType {
            case .payment:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.cardTableViewCell) as? CardTableViewCell else {
                    fatalError("Couldn't load CartItemTableViewCell")
                }
                
                let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
                if isDarkMode == true {
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                    cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                    cell.cardTypeName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                  

                
                } else {
                   
                    cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.cardTypeName.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                    
                   
                    if indexPath.row ==  0{
                        cell.checkBoxBtn.setImage(UIImage(named: "radioRedOn"), for: .normal)
                        cell.checkBoxBtn.isSelected = true
                      defaultType = "1"
                     }
                    if firstTap == "red"{
                        if  indexPath.row ==  0 {
                       cell.checkBoxBtn.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
                        cell.checkBoxBtn.isSelected = false
                            defaultType = "0"
                        }
                    }
                }
                let indexType = list[indexPath.row]
                guard let paymentType = PaymentType(rawValue: indexType) else {
                    fatalError()
                }
               
                
                
                if paymentType == .wallet {
                    cell.bottomView.isHidden = true
                    let amount = LoginManagerApi.share.me?.walletAmount ?? 0.0
                    cell.walletPrice.text = "\(amount.roundTo1Decimal())"
                }
                
                cell.cardImage.image = paymentType.paymentImage
                
                cell.cardTypeName.text = paymentType.paymentName.localizedString
                cell.walletPrice.isHidden = true
                if paymentType == .wallet {
                    cell.walletPrice.isHidden = false
                }
//                cell.checkBoxCallback = {(_ cell: CardTableViewCell) in
//                    
//                    self.editButtonClicked(cell: cell)
//                }
               
                
                    
                if checkSelected == paymentType {
                   
                cell.checkBoxBtn.isSelected = checkSelected.checkEnum
                } else {

                cell.checkBoxBtn.isSelected = !checkSelected.checkEnum
                    
            }
                
                return cell
            case .amount:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.priceDetailsTableView) as? PriceDetailsTableView else {
                    fatalError("Couldn't load CartItemTableViewCell")
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
                let sar = "Rs.".localizedString
                cell.promoDiscount.isHidden = true
                cell.promoDiscountLbl.isHidden = true
                cell.selectionStyle = .none
                cell.lblItemsPrice.text = "\(sar) \(price.roundTo2Decimal())"
                cell.lblTotalAmount.text = "\(sar) \(totalPrice.roundTo2Decimal())"
                cell.lblNumberOfItems.text = " \(priceString) (\(qty): \(quantity))"
                let vatPer = (tax/100)*price
                cell.lblVatPrice.text = "\(sar) \(vatPer.roundTo2Decimal())"
                cell.lblVatPrice.isHidden  = false
                
                cell.lblCanclePrice.text = "\(sar) \(cancleCharge.roundTo2Decimal())"
                if bookingFlow == .pickup {
                    cell.deliveryChargePrice.isHidden = true
                    cell.deliveryChargeTitle.isHidden = true
                } else {
                    cell.deliveryChargePrice.text = "\(sar) \(deliveryPrice.roundTo2Decimal())"
                }
                if LoginManagerApi.share.promoAmount == 0.0 {
                    cell.statusMode.text = " "
                    cell.statusModeTitle.text = "No Discount Applied".localizedString
                } else {
                    cell.statusMode.text = "- \(sar) \(LoginManagerApi.share.promoAmount.roundTo2Decimal())"
                    cell.statusModeTitle.text = "Discount".localizedString
                    cell.statusMode.textColor = darkPinkColor
                }
                cell.applyPromo.isHidden = true
                cell.applyCoupon.isHidden = true
                cell.bottomView.isHidden = true
                cell.extraInfoTextField.isHidden = true
                return cell
            }
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                   let indexType = list[indexPath.row]
                   guard let sectionType = PaymentType(rawValue: indexType) else {
                       fatalError()
                   }
                   if sectionType == .wallet {
                       if price > LoginManagerApi.share.me?.walletAmount ?? 0.0 {
                           customAlert(controller: self, message: "You don't have sufficient funds in your wallet.".localizedString)
                           return
                       }
                   }
                  defaultType = "0"
                  firstTap = "red"
                   checkSelected = sectionType
                   tableView.reloadData()
                   //            DispatchQueue.main.async {
                   //             tableView.delegate = self
                   //             tableView.dataSource = self
                   //             tableView.reloadData()
                   //            }
               }
      }

