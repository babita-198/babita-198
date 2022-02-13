//
//  AddressModel.swift
//  FoodFox
//
//  Created by Nishant Raj on 30/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
 
typealias SaveAddress = ((_ response: String?, _ error: Error?) -> Void)
typealias EditAddress = ((_ response: Any?, _ error: Error?) -> Void)
typealias DeleteAddress = ((_ response: Any?, _ error: Error?) -> Void)
typealias SaveCart = ((_ response: Any?, _ error: Error?) -> Void)
typealias GetAllAddress = ((_ list: [AddressModel]?, _ error: Error?) -> Void)

class AddressModel {
    var latitute: Double?
    var longitute: Double?
    var address: String?
    var city: String?
    var pincode: String?
    var landMark: String?
    var addressId: String?
    var addresType: Int?
    var streetName: String?
    var houseNo: String?
  
  init(list: [String: Any]) {
    
    if let id = list ["_id"] as? String {
      self.addressId = id
    }
    if let address = list["address"] as? String {
     self.address = address
    }
    
    if let addressType = list["addressType"] as? String {
      self.addresType = Int(addressType)
    }
    
    if let landMark = list["landMark"] as? String {
      self.landMark = landMark
    }
    
    if let city = list["city"] as? String {
      self.city = city
    }
    
    if let street = list["streetName"] as? String {
      self.streetName = street
    }
    
    if let houseNo = list["houseNumber"] as? String {
      self.houseNo = houseNo
    }
    if let pincode = list["pinCode"] as? String {
      self.pincode = pincode
    }
    
    if let locationLatLong = list["locationLongLat"] as? [String: Any] {
      if let lat = locationLatLong["coordinates"] as? [Double] {
       self.latitute = lat.last
       self.longitute = lat.first
      }
      
    }
    
  }
  
  
  static func updateAddress(parameters: [String: Any], callBack: @escaping EditAddress) {
    HTTPRequest(method: .put,
                path: API.updateAddress,
                parameters: parameters,
                encoding: .json,
                files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error != nil {
          callBack(nil, response.error)
          return
        }
        callBack(nil, response.error)
    }
  }
    
    static func deleteAddress(parameters: [String: Any], callBack: @escaping DeleteAddress) {
      HTTPRequest(method: .delete,
                  path: API.deleteAddress,
                  parameters: parameters,
                  files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
        .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
          
          if response.error != nil {
            callBack(nil, response.error)
            return
          }
          callBack(nil, response.error)
      }
    }
  
    
    static func saveAddress(parameters: [String: Any], callBack: @escaping SaveAddress) {
          HTTPRequest(method: .post,
                        path: API.addNewAddress,
                        parameters: parameters,
                        encoding: .json,
                        files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
                .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                    
                    if response.error != nil {
                        callBack(nil, response.error)
                        return
                    }
                  guard let value = response.value as? [String: Any] else {
                    return
                  }
                  guard let data = value["data"] as? [String: Any] else {
                    return
                  }
                  guard let addressId = data["addressID"] as? String else {
                    return
                  }
                 callBack(addressId, nil)
            }
        }
  
  
  static func saveCart(parameters: [String: Any], callBack: @escaping SaveCart) {
    HTTPRequest(method: .post,
                path: API.addToCart,
                parameters: parameters,
                encoding: .json,
                files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        print(response)
        if response.error != nil {
          callBack(nil, response.error)
          return
        }
        callBack(nil, response.error)
    }
  }
  

  static func getAllAddress(callBack: @escaping GetAllAddress) {
    HTTPRequest(method: .get,
                path: API.getAllAddress,
                parameters: nil,
                encoding: .json,
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
       
        var addressList: [AddressModel] = []
        
        if let listArrya = data["customerAddress"] as? [[String: Any]] {
          
          for list in listArrya {
            let object = AddressModel(list: list)
              addressList.append(object)
          }
        }
        callBack(addressList, nil)
    }
  }
  
}
