//
//  OrderModel.swift
//  FoodFox
//
//  Created by clicklabs on 07/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation


typealias GetAllOrder = ((_ list: [OrderModel]?, _ error: Error?) -> Void)
typealias OrderCancel = ((_ data: [String: Any]?, _ error: Error?) -> Void)
typealias OrderDetail = ((_ data: OrderModel?, _ error: Error?) -> Void)

class OrderModel {
  var oderId: Int?
  var orderStatus: Int?
  var tookanStatus: Int?
  var totalAmount: Double?
  var bookingTime: String?
  var itemName: String?
  var addOnItemName: String?
  var itemQuantity: Int?
  var address: String?
  var branchAddress: String?
  var addressType: Int?
  var city: String?
  var pincode: String?
  var bookingId: String?
  var rating: Int = 0
  var ratePopup: Int = 0
  var stars: Int = 0
  var paymentMode: String?
  var restaurantName: String?
  var restaurantPhone: String?
  var restaurantImage: String?
  var totalQuanity: Int?
  var totalAmountWithVat: Double?
  var totalPaidAmount: Double?
  var vat: Double?
 
  var deliveryChange: Double?
  var discountPrice: Double?
    var tax: Double?
    var cancellationCharges: Double?
  var item = [ItemData]()
  
    
  var bookingType: String?
  var cancellation: String?
  var reasonId: String?
  var bookingStatusType: Int?
  var driverName: String?
  var deliveryTime: String?
  var branchName: String?
  var jobDeliveryDateTime: String?
  var paymentStatus: Int?
  
  
    init(reason: [String: Any]) {
        if let id = reason["_id"] as? String {
            self.reasonId = id
        }
        if let reason = reason["description"] as? String {
          self.cancellation = reason
        }
    }
    
    
  init(data: [String: Any]) {
    
    if let id = data["bookingNo"] as? Int {
      self.oderId = id
    }
    if let bookingId = data["_id"] as? String {
      self.bookingId = bookingId
    }
    if let orderStatus = data["status"] as? String {
      self.orderStatus = Int(orderStatus)
    }
    if let tookanStatus = data["tookanJobStatus"] as? String {
        self.tookanStatus = Int(tookanStatus)
    }
    if let amount = data["totalPaidAmount"] as? Double {
      self.totalAmount = amount
    }
    if let time = data["bookingLocalDateTime"] as? String {
      self.bookingTime = time
    }
    
    if let rate = data["rated"] as? Int {
      self.rating = rate
    }
    
    if let mode = data["modeOfPayment"] as? String {
      self.paymentMode = mode
    }
    
    if let ratingData = data["rating"] as? [String: Any] {
      if let stars = ratingData["stars"] as? Int {
        self.stars = stars
      }
    }
    
    if let restaurant = data["restaurant"] as? [String: Any] {
        if let restaurantName = restaurant["restaurantName"] as? String {
            self.restaurantName = restaurantName
        }
        if let stringRating = restaurant["rating"] as? String {
            guard let doubleRating = Double(stringRating) else {
                return
            }
            
            self.rating = Int(doubleRating)
        }
        if let phone = restaurant["phoneNo"] as? String {
            self.restaurantPhone = phone
        }
        if let imageData = restaurant["imageURL"] as? [String: Any] {
            if let original = imageData["original"] as? String {
                self.restaurantImage = original
            }
        }
    }
    
    if let address = data["address"] as? [String: Any] {
      
      if let addressString = address["address"] as? String {
        self.address = addressString
      }
      if let addressType = address["addressType"] as? Int {
        self.addressType = addressType
      }
      if let city = address["city"] as? String {
        self.city = city
      }
      if let pin = address["pinCode"] as? String? {
        self.pincode = pin
      }
    }
    
    if let address = data["branch"] as? [String: Any] {
      if let addressString = address["address"] as? String {
        self.branchAddress = addressString
      }
      if let branchName = address["branchName"] as? String {
        self.branchName = branchName
      }
    }
  }
  
  
  init(dataValue: [String: Any]) {
    
    if let driverName = dataValue["driverName"] as? String {
        self.driverName = driverName
    }
    
    guard let bookingData = dataValue["bookingData"] as? [[String: Any]] else {
        return
    }
     guard let dataDetail = bookingData.first else {
      return
     }

    if let jobDeliveryDateTime = dataDetail["jobDeliveryDatetime"] as? String {
      self.jobDeliveryDateTime = jobDeliveryDateTime
    }
    
    if let deliveryTime = dataDetail["bookingDateTime"] as? String {
      self.deliveryTime = deliveryTime
    }
    
    if let mode = dataDetail["modeOfPayment"] as? String {
      self.paymentMode = mode
    }
    if let mode = dataDetail["modeOfPaymentStatus"] as? Int {
        self.paymentStatus = mode
    }
    
    if let bookingStatusType = dataDetail["bookingTypeStatus"] as? String {
      self.bookingStatusType = Int(bookingStatusType)
    }
    
    if let rate = dataDetail["rated"] as? Int {
        self.ratePopup = rate
    }
    
    if let ratingData = dataDetail["rating"] as? [String: Any] {
      if let stars = ratingData["stars"] as? Int {
        self.stars = stars
      }
    }
    
    if let orderStatus = dataDetail["status"] as? String {
        self.orderStatus = Int(orderStatus)
    }
    if let tookanStatus = dataDetail["tookanJobStatus"] as? String {
        self.tookanStatus = Int(tookanStatus)
    }
    if let bookingStatusType = dataDetail["bookingTypeStatus"] as? String {
      self.bookingStatusType = Int(bookingStatusType)
    }
    
    if let bookingStatusType = dataDetail["bookingTypeStatus"] as? Int {
      self.bookingStatusType = bookingStatusType
    }
    if let totalPrice = dataDetail["totalAmountWithVat"] as? Double {
      self.totalAmountWithVat = totalPrice
    }
//    if let quanity = dataDetail["quantity"] as? Double {
//        self.totalQuanity = quanity
//    }
    if let totalPrice = dataDetail["totalPaidAmount"] as? Double {
      self.totalPaidAmount = totalPrice
    }
    if let totalPrice = dataDetail["vat"] as? Double {
      self.vat = totalPrice
    }
    if let tax = dataDetail["tax"] as? Double {
        self.tax = tax
    }
    if let cancellationCharges = dataDetail["cancellationCharges"] as? Double {
        self.cancellationCharges = cancellationCharges
    }
    if let totalPrice = dataDetail["deliveryCharges"] as? Double {
      self.deliveryChange = totalPrice
    }
    if let totalPrice = dataDetail["discountedPrice"] as? Double {
      self.discountPrice = totalPrice
    }
    if let address = dataDetail["address"] as? [String: Any] {
      
      if let addressString = address["address"] as? String {
        self.address = addressString
      }
      if let addressType = address["addressType"] as? Int {
        self.addressType = addressType
      }
      if let city = address["city"] as? String {
        self.city = city
      }
      if let pin = address["pinCode"] as? String? {
        self.pincode = pin
      }
    }
  
    if let address = dataDetail["branch"] as? [String: Any] {
      if let addressString = address["address"] as? String {
        self.branchAddress = addressString
      }
      if let branchName = address["branchName"] as? String {
        self.branchName = branchName
      }
    }
    
    if let restaurant = dataDetail["restaurant"] as? [String: Any] {
      if let restaurantName = restaurant["restaurantName"] as? String {
        self.restaurantName = restaurantName
      }
        if let stringRating = restaurant["rating"] as? Double {
            
            self.rating = Int(stringRating)
        }

      if let phone = restaurant["phoneNo"] as? String {
        self.restaurantPhone = phone
      }
      if let imageData = restaurant["imageURL"] as? [String: Any] {
        if let original = imageData["original"] as? String {
          self.restaurantImage = original
        }
      }
    }
    
    if let itemsData = dataDetail["menus"] as? [[String: Any]] {
        
      for item in itemsData {
        
        self.item.append(ItemData(item: item))
        
      }
   }
    
    
    
    
    
}
  
    
    
    
  init() {
    
  }
  
  // MARK: Get all UPComing Order
  static func getAllOrder(isIndicator: Bool, limit: Int, status: String, callBack: @escaping GetAllOrder) {
    var param: [String: Any] = [:]
    param["status"] = status
    param["limit"] = limit
    HTTPRequest(method: .get,
                path: API.getAllOrder,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: isIndicator, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        if response.error != nil {
            callBack(nil, response.error)
            return
        }
        guard let responseData = response.value as? [String: Any], let data = responseData["data"] as? [String: Any] else {
         callBack(nil, response.error)
          return
        }
        
        print(responseData)
        print(data)
        
        var orderList: [OrderModel] = []
        
        if let listArrya = data["bookingData"] as? [[String: Any]] {
          
          for list in listArrya {
            let object = OrderModel(data: list)
            orderList.append(object)
          }
        }
        callBack(orderList, nil)
    }
  }
  
  
  // MARK: Get All Past Order List
  static func getAllPastOrder(isIndicator: Bool, limit: Int, status: String, callBack: @escaping GetAllOrder) {
    var param: [String: Any] = [:]
    param["status"] = status
    param["limit"] = limit
    HTTPRequest(method: .get,
                path: API.getAllOrder,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: isIndicator, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        guard let responseData = response.value as? [String: Any], let data = responseData["data"] as? [String: Any] else {
          callBack(nil, response.error)
          return
        }
        
        print(responseData)
        print(data)
        if response.error != nil {
          callBack(nil, response.error)
          return
        }
        var orderList: [OrderModel] = []
        
        if let listArrya = data["bookingData"] as? [[String: Any]] {
          
          for list in listArrya {
            let object = OrderModel(data: list)
            orderList.append(object)
          }
        }
        callBack(orderList, nil)
    }
  }
  
    
    
    // MARK: Get All Past Order List
    static func getCancellationReason(callBack: @escaping GetAllOrder) {
        HTTPRequest(method: .get,
                    path: API.getReason,
                    parameters: nil,
                    encoding: .url,
                    files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                
                guard let responseData = response.value as? [String: Any], let data = responseData["data"] as? [String: Any] else {
                    return
                }
                
                print(responseData)
                print(data)
                if response.error != nil {
                    callBack(nil, response.error)
                    return
                }
                var orderList: [OrderModel] = []
                
                if let listArrya = data["CancellationReasonData"] as? [[String: Any]] {
                    
                    for list in listArrya {
                        let object = OrderModel(reason: list)
                        orderList.append(object)
                    }
                }
                callBack(orderList, nil)
        }
    }
    
    
  
  
  // MARK: Cancel Order API
  static func rateOrder(param: [String: Any], callBack: @escaping OrderCancel) {
    HTTPRequest(method: .put,
                path: API.giveRating,
                parameters: param,
                encoding: .json,
                files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any] {
            callBack(responseValue, nil)
            return
          }
        }
        callBack(nil, response.error)
        return
    }
  }
  
  // MARK: Cancel Order API
    static func orderCancel(bookingId: String, reason: String, callBack: @escaping OrderCancel) {
    var param: [String: Any] = [:]
    param["bookingId"] = bookingId
    param["cancellationReason"] = reason
    HTTPRequest(method: .put,
                path: API.orderCancel,
                parameters: param,
                encoding: .json,
                files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any] {
          callBack(responseValue, nil)
         return
          }
        }
        callBack(nil, response.error)
        return
    }
  }
  
  // MARK: Get Order Detail
  static func getOrderDetail(orderId: String, callBack: @escaping OrderDetail) {
    var param: [String: Any] = [:]
    param["bookingId"] = orderId
    HTTPRequest(method: .get,
                path: API.getOrderDetail,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error != nil {
            callBack(nil, response.error)
            return
        }
        guard let responseData = response.value as? [String: Any], let data = responseData["data"] as? [String: Any] else {
          return
        }
        print(responseData)
        print(data)
        var orderDetail: OrderModel!
        let object = OrderModel(dataValue: data)
        orderDetail = object
        callBack(orderDetail, nil)
       return
    }
  }
}


class ItemData {
  var itemName: String?
  var priceWithAdon: Double = 0.0
  var price: Double?
  
    
  var quantity: Int?
  var totalPrice: Double = 0.0
  var totalQuantity = 0
  var addOnItem = [AddOnItemData]()
  init(item: [String: Any]) {
    
      if let price = item["price"] as? Double {
        self.price = price
      }
    if let itemsData = item["addOns"] as? [[String: Any]] {
        
        for item in itemsData {
            
            self.addOnItem.append(AddOnItemData(addItem: item))
            
        }
    }
    
      if let priceWithAddon = item["priceWithAddOns"] as? Double {
        self.priceWithAdon = priceWithAddon
        totalPrice += priceWithAdon + self.price!
      }
    if let name = item["itemName"] as? String {
      self.itemName = name
    }
      if let quantity = item["quantity"] as? Int {
        self.quantity = quantity
        self.totalQuantity += quantity
      }
  }
}

class AddOnItemData {
    var id: String?
    var addOnItemName: String?
    var price: Double?
    
    init(addItem: [String: Any]) {
        // _id
        if let itemId = addItem["addOnId"] as? String {
            self.id = itemId
        }
        if let item = addItem["addOnName"] as? String {
            self.addOnItemName = item
        }
        if let itemPrice = addItem["price"] as? Double {
            self.price = itemPrice
        }
    }
}
