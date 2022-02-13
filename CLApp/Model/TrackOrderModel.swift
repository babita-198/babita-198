//
//  TrackOrderModel.swift
//  FoodFox
//
//  Created by clicklabs on 13/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

typealias TrackData = ((_ data: TrackOrderModel?, _ error: Error?) -> Void)
typealias ReferralCode = ((_ data: String?, _ amount: Double?, _ error: Error?) -> Void)

class TrackOrderModel {
  var status: Int?
  var time: Int?
  var orderId: Int?
  var bookingId: String?
  var statusType: String?
  var tokanStatusJob: Int?
  var driverId: Int?
  var driverName: String?
  var driverImage: String?
  var fleetLat: String?
  var fleetLong: String?
  var jobLat: String?
  var jobLong: String?
  var pickUpLat: String?
  var pickUpLong: String?
  var driverNumber: String?
  var bookingType: Int?
  //var bookingTime: String?
  var bookingDateTime: String?
  var acceptDateTime: String?
  var readyForPickUpDateTime: String?
  var jobDeliveryDatetime: String?
  var completedDatetimeUtc: String?
  
  init() {
    
  }
  
  init(data: [String: Any]) {
    guard let track = data["data"] as? [String: Any] else {
      return
    }
  
    guard let trackOrderData = track["trackOrderData"] as? [String: Any] else {
      return
    }
     print(trackOrderData["status"] ?? 0)
    if let orderId = trackOrderData["bookingNo"] as? Int {
      self.orderId = orderId
    }
    if let booking = trackOrderData["bookingDateTime"] as? String {
      self.bookingDateTime = booking
    }
    if let acceptDateTime = trackOrderData["acceptDateTime"] as? String {
      self.acceptDateTime = acceptDateTime
    }
    if let readyForPickUpDateTime = trackOrderData["readyForPickUpDateTime"] as? String {
      self.readyForPickUpDateTime = readyForPickUpDateTime
    }
    if let jobDeliveryDatetime = trackOrderData["jobDeliveryDatetime"] as? String {
      self.jobDeliveryDatetime = jobDeliveryDatetime
    }
    if let completedDatetimeUtc = trackOrderData["completedDatetimeUtc"] as? String {
      self.completedDatetimeUtc = completedDatetimeUtc
    }
    
    if let bookingId = trackOrderData["_id"] as? String {
      self.bookingId = bookingId
    }

    if let statusType = trackOrderData["statusType"] as? String {
      self.statusType = statusType
    }
    
    if let status = trackOrderData["status"] as? String {
      self.status = Int(status)
    }
    
    if let bookingType = trackOrderData["bookingTypeStatus"] as? Int {
      self.bookingType = bookingType
    }
    
    if let bookingType = trackOrderData["bookingTypeStatus"] as? String {
      self.bookingType = Int(bookingType)
    }
    
    if let status = trackOrderData["tookanJobStatus"] as? Int {
      self.tokanStatusJob = status
    }
    
    if let status = trackOrderData["tookanJobStatus"] as? String {
      self.tokanStatusJob = Int(status)
    }
    
    if let restaurent = trackOrderData["restaurant"] as? [String: Any] {
      if let time = restaurent["estimateDeliveryTime"] as? Int {
        self.time = time
      }
    }
    
  }
  
  init(trackOrder: [String: Any]) {
    if let driverId = trackOrder["driverId"] as? Int {
      self.driverId = driverId
    }
    if let driverName = trackOrder["driverName"] as? String {
      self.driverName = driverName
    }
    if let image = trackOrder["driverProfilePicURL"] as? [String: Any] {
      if let originalImage = image["original"] as? String {
        self.driverImage = originalImage
      }
    }
    if let fleetLatitude = trackOrder["fleetLatitude"] as? String {
      self.fleetLat = fleetLatitude
    }
    if let fleetLongitude = trackOrder["fleetLongitude"] as? String {
      self.fleetLong = fleetLongitude
    }
    if let jobLatitude = trackOrder["jobPickupLatitude"] as? String {
      self.pickUpLat = jobLatitude
    }
    if let jobLongitude = trackOrder["jobPickupLongitude"] as? String {
      self.pickUpLong = jobLongitude
    }
    if let pickUpLat = trackOrder["jobLatitude"] as? String {
      self.jobLat = pickUpLat
    }
    if let pickUpLong = trackOrder["jobLongitude"] as? String {
      self.jobLong = pickUpLong
    }
    
    if let fleetLatitude = trackOrder["fleetLatitude"] as? Double {
      self.fleetLat = "\(fleetLatitude)"
    }
    if let fleetLongitude = trackOrder["fleetLongitude"] as? Double {
      self.fleetLong = "\(fleetLongitude)"
    }
    if let jobLatitude = trackOrder["jobPickupLatitude"] as? Double {
      self.pickUpLat = "\(jobLatitude)"
    }
    if let jobLongitude = trackOrder["jobPickupLongitude"] as? Double {
      self.pickUpLong = "\(jobLongitude)"
    }
    if let pickUpLat = trackOrder["jobLatitude"] as? Double {
      self.jobLat = "\(pickUpLat)"
    }
    if let pickUpLong = trackOrder["jobLongitude"] as? Double {
      self.jobLong = "\(pickUpLong)"
    }
    
    if let phone = trackOrder["phone"] as? String {
      self.driverNumber = phone
    }
    if let orderId = trackOrder["bookingNo"] as? Int {
      self.orderId = orderId
    }
  }
  
// MARK: Track Order API
static func orderTrack(bookingId: String, callBack: @escaping TrackData) {
    var param: [String: Any] = [:]
    param["bookingId"] = bookingId
    HTTPRequest(method: .get,
                path: API.trackOrder,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any] {
            print(responseValue)
            let data = TrackOrderModel(data: responseValue)
            callBack(data, nil)
            return
          }
        }
        callBack(nil, response.error)
        return
    }
  }
  
  
  // MARK: Get Referral Code API
  static func getReferralCode(callBack: @escaping ReferralCode) {
    HTTPRequest(method: .get,
                path: API.getReferralCode,
                parameters: nil,
                encoding: .json,
                files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        print(response)
        if response.error == nil {
          if let responseValue = response.value as? [String: Any] {
           if let data = responseValue["data"] as? [String: Any], let promocode = data["invitationCode"] as? String, let amount = data["availableCredits"] as? Double {
            callBack(promocode, amount, nil)
            return
            }
          }
        }
        callBack(nil, 0.0, response.error)
        return
    }
  }
  
  
 // MARK: Track Order API
  static func orderOrderMap(bookingId: String, callBack: @escaping TrackData) {
    var param: [String: Any] = [:]
    param["bookingId"] = bookingId
    HTTPRequest(method: .get,
                path: API.trackOrderMap,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any] {
            print(responseValue)
            if let data = responseValue["data"] as? [String: Any] {
              print(data)
            let data = TrackOrderModel(trackOrder: data)
            callBack(data, nil)
            return
            }
          }
        }
        callBack(nil, response.error)
        return
    }
  }
  
  
    
    
    
  // MARK: Google API Calls for Destination lat long
  static func sendRequestToServer(baseUrl: String, _ url: String, httpMethod: String, isZipped: Bool, receivedResponse:@escaping (_ succeeded: Bool, _ response: [String: Any]) -> Void ) {
    
    let newParam: [String: Any] = [:]
    let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    guard let urlStr = urlString else {
      return
    }
    guard let url = URL(string: (baseUrl) + urlStr) else {
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod as String
    request.timeoutInterval = 20
    print(request)
    if httpMethod == "POST" {
       do {
         request.httpBody = try JSONSerialization.data(withJSONObject: newParam, options: [])
       } catch {
       print("Error")
      }
      if isZipped == false {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      } else {
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Encoding: gzip")
      }
      request.addValue("application/json", forHTTPHeaderField: "Accept")
    }

    let task = URLSession.shared.dataTask(with: request) {data, response, error in
      if response != nil && data != nil {
        do {
          guard let data = data else {
          return
          }
          if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
            receivedResponse(true, json)
          } else {
            receivedResponse(false, [:])
          }
        } catch {
          receivedResponse(false, [:])
        }
      } else {
        receivedResponse(false, [:])
      }
    }
    task.resume()
  }  
}
