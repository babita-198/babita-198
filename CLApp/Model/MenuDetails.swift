//
//  MenuDetails.swift
//  FoodFox
//
//  Created by socomo on 28/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit

class MenuDetails {
//    static var shared : MenuDetail 
    var restaurantId: String?
    var restaurantName: String?
    var phoneNo: String?
    var rating: Double?
    var deliveryCharge: Double?
    var minimumOrderValue: Int?
    var estimatedPreparationTime: Double?
    var calculatedDistance: Double?
    var lat: Double?
    var long: Double?
    var type: String?
    var address: String?
    var logoImageUrl: String?
    var imageUrl: String?
    var reviews: Int?
    var description: String?
    var estimateDeliveryTime: Double?
    var startDay: String?
    var endDay: String?
    var startTime: String?
    var endTime: String?
    var openStatus: Int?
    
    
    var paymentMethods: [String] = []
  
    static var availabilityArray = [Availability]()
    var restaurantBranches = [BranchesDetails]()
    
    init(data: [String: Any]) {
        guard let restaurantData = data["restaurantData"] as? [String: Any] else {
            return
        }
    
      if let openStatus = restaurantData["openingStatus"] as? String {
        self.openStatus = Int(openStatus)
      }
      
      if let openStatus = restaurantData["openingStatus"] as? Int {
        self.openStatus = openStatus
      }
      
        
        if let list = restaurantData["paymentMethods"] as? [String] {
            self.paymentMethods = list
        }
        
      
        if let id = restaurantData["restaurantId"] as? String {
            self.restaurantId = id
        }
        if let name = restaurantData["restaurantName"] as? String {
            self.restaurantName = name
        }
        if let contact = restaurantData["phoneNo"] as? String {
            self.phoneNo = contact
        }
        if let rating = restaurantData["rating"] as? Double {
            self.rating = rating
        }
        if let restaurantDeliveryCharges = restaurantData["deliveryCharge"] as? Double {
            self.deliveryCharge = restaurantDeliveryCharges
        }
        if let minimumOrder = restaurantData["minimumOrderValue"] as? Int {
            self.minimumOrderValue = minimumOrder
        }
        
        if let distanceCalculated = restaurantData["distanceCalculated"] as? Double {
            self.calculatedDistance = distanceCalculated
        }
        
        if let minimumOrder = restaurantData["estimatePreparationTime"] as? Double {
            self.estimatedPreparationTime = minimumOrder
        }
        
        if let location = restaurantData["locationLongLat"] as? [String: Any], let coordinate = location["coordinates"] as? [Double], let type = location["type"] as? String {
            self.long = coordinate[0]
            self.lat = coordinate[1]
            self.type = type
        }
        
        if let restaurantAddress = restaurantData["address"] as? String {
            self.address = restaurantAddress
        }
        self.restaurantData(restaurantData: restaurantData)
    }
    
    func restaurantData(restaurantData: [String: Any]) {
        if let imageLogo = restaurantData["logoURL"] as? [String: Any], let originalImage = imageLogo["thumbnail"] as? String {
            self.logoImageUrl = originalImage
        }
        if let image = restaurantData["imageURL"] as? [String: Any], let orignalUrl = image["original"] as? String {
            self.imageUrl = orignalUrl
        }
        if let review = restaurantData["reviews"] as? Int {
            self.reviews = review
        }
        if let restaurantDescription = restaurantData["description"] as? String {
            self.description = restaurantDescription
        }
        if let estimatedTime = restaurantData["estimateDeliveryTime"] as? Double {
            self.estimateDeliveryTime = estimatedTime
        }
        if let startDay = restaurantData["startDay"] as? String {
            self.startDay = startDay
        }
        if let endDay = restaurantData["endDay"] as? String {
            self.endDay = endDay
        }
        if let startTime = restaurantData["startTime"] as? String {
            self.startTime = startTime
        }
        if let endTime = restaurantData["endTime"] as? String {
            self.endTime = endTime
        }
        
        
        //Parse branch Array Data
        if let branches = restaurantData["restaurantBranches"] as? [[String: Any]] {
            self.restaurantBranches = branches.map({ BranchesDetails(param: $0)})
        }
        
        //Set Availability data in array
        if let availableRestaurant = restaurantData["Availability"] as? [[String: Any]] {
            MenuDetails.availabilityArray = availableRestaurant.map({ Availability(param: $0)})
        }
    }
}



struct BranchesDetails {
    var restaurantBranchesId: String?
    var restaurantBranchName: String?
    var restaurantBranchAddress: String?
    var openingStatus: String?
    var pickupservice: String?
    var calculatedDistance: Double = 0.0
    var lat: Double = 0.0
    var long: Double = 0.0
    var phoneNumber: String?
    var addNotMessage: String?
    var addNotes: Int?
    var minimumOrderValue: Int?
    init(param: [String: Any]) {
      
        if let phone = param["phoneNo"] as? String {
            self.phoneNumber = phone
        }
        
        if let id = param["_id"] as? String {
            self.restaurantBranchesId = id
        }
        if let name = param["branchName"] as? String {
            self.restaurantBranchName = name
        }
        if let distance = param["distanceCalculated"] as? Double {
            self.calculatedDistance = distance
        }
        if let address = param["address"] as? String {
            self.restaurantBranchAddress = address
        }
        if let location = param["locationLongLat"] as? [String: Any] {
            if let arrayLatLong = location["coordinates"] as? [Double] {
                self.long = arrayLatLong.first ?? 0.0
                self.lat = arrayLatLong.last ?? 0.0
            }
        }
        if let openingStatus = param["openingStatus"] as? String {
            self.openingStatus = openingStatus
        }
        if let pickupservice = param["pickupservice"] as? String {
            self.pickupservice = pickupservice
        }
        if let addNotMessage = param["addNotMessage"] as? String {
            self.addNotMessage = addNotMessage
        }
        if let addNotes = param["addNotes"] as? Int {
            self.addNotes = addNotes
        }
        if let minimumOrder = param["minimumOrderValue"] as? Int {
            self.minimumOrderValue = minimumOrder
        }

    }
}




typealias AvailabilityData = ((_ data: BranchAvailabilityData?, _ error: Error?) -> Void)
class BranchAvailabilityData {
  var availabilityArray = [BranchAvailability]()
  var id: String?
  var status: Int?
  
  init(param: [String: Any]) {
  
    guard let dataAvailable = param["data"] as? [String: Any] else {
      return
    }
    
    guard let data = dataAvailable["branchData"] as? [String: Any] else {
      return
    }
    
    if let id = data["openingStatus"] as? String {
      self.status = Int(id)
    }
    
    //Set Availability data in array
    if let branchAvailability = data["Availability"] as? [[String: Any]] {
      self.availabilityArray = branchAvailability.map({ BranchAvailability(param: $0)})
    }
  }
  // MARK: Track Order API
  static func getTime(bookingId: String, callBack: @escaping AvailabilityData) {
    var param: [String: Any] = [:]
    param["branchId"] = bookingId
    param["date"] = convertInUTC()
    HTTPRequest(method: .get,
                path: API.availability,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any] {
            print(responseValue)
            let data = BranchAvailabilityData(param: responseValue)
            callBack(data, nil)
            return
          }
        }
        callBack(nil, response.error)
        return
    }
  }
  
}


struct BranchAvailability {
  var day: String?
  var endTime: String?
  var startTime: String?
  
  //Initialize Availability Data
  init(param: [String: Any]) {
    if let availableDay = param["day"] as? String {
      self.day = availableDay
    }
    if let availableEndTime = param["endtime"] as? String {
      self.endTime = UTCToLocal(date: availableEndTime)
    }
    if let availableStartTime = param["starttime"] as? String {
      self.startTime = UTCToLocal(date: availableStartTime)
    }
  }
  
  //Convert UTC date to Local
  func UTCToLocal(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    if let dt = dateFormatter.date(from: date) {
      dateFormatter.timeZone = TimeZone.current
      dateFormatter.dateFormat = "h:mm a"
      print(dateFormatter.string(from: dt))
      return dateFormatter.string(from: dt)
    }
    return ""
  }
}


struct Availability {
    var day: String?
    var endTime: String?
    var startTime: String?
    
    //Initialize Availability Data
    init(param: [String: Any]) {
        if let availableDay = param["day"] as? String {
            self.day = availableDay
        }
        if let availableEndTime = param["endtime"] as? String {
            self.endTime = UTCToLocal(date: availableEndTime)
        }
                if let availableStartTime = param["starttime"] as? String {
            self.startTime = UTCToLocal(date: availableStartTime)
        }
    }
    
    //Convert UTC date to Local
    func UTCToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
            print(dateFormatter.string(from: dt))
            return dateFormatter.string(from: dt)
        }
        return ""
    }
}
