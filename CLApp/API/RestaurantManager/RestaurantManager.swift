//
//  RestaurantManager.swift
//  FoodFox
//
//  Created by socomo on 28/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation

class RestaurantManager {
    
    static let share = RestaurantManager()
    typealias RestaurantManagerCallBack = ((_ response: Any?, _ error: Error?) -> Void)
  
  //MARK: Get All Home Screen Data
    func homeScreen( parameter: [String: Any], callBack: @escaping RestaurantManagerCallBack) {
      var parameters = parameter
      let language = Localize.currentLang()
      if language == .english {
          parameters["language"] = "en"
      } else {
        parameters["language"] = "en"
      }
        
     parameters["timezone"] = "\(TimeZone.current.secondsFromGMT()/60)"
      parameters["date"] = convertInUTC()
        print("******\(parameters)")
      HTTPRequest(method: .get,
                        path: "api/customer/getHomeDetails",
                        parameters: parameters,
                        encoding: .url,
                        files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
                .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                    
                    if response.error != nil {
                        callBack(nil, response.error)
                        return
                    }
                    print("response ",response)
                    if let dict = response.value as? [String: Any] {
                        print("data", dict)
                        if let data = dict["data"] as? [String: Any] {
                            let home = Home(data: data)
                            callBack(home, nil)
                            return
                        }
                    }
                    callBack(nil, response.error)
            }
    }
  
    
     
    // MARK: CUSTOMER LOCATION UPDATE
    typealias LocationCallBack = ((_ response: Any?, _ error: Error?) -> Void)
    func customerLocationUpdate(parameters: [String: Any], callBack: @escaping LocationCallBack) {
        HTTPRequest(method: .put,
                    path: "api/customer/UpdateCustomerLocation",
                    parameters: parameters,
                    encoding: .json,
                    files: nil).config(isIndicatorEnable: false, isAlertEnable: false)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                callBack(response.value as? [String: Any], nil)
                
        }
        
    }
    
    
  //MARK: Get All Restaurant Menu Data
    func restaurantMenu(parameters: [String: Any], callBack: @escaping RestaurantManagerCallBack) {
      var parameters = parameters
      let language = Localize.currentLang()
      if language == .english {
        parameters["language"] = "en"
      } else {
        parameters["language"] = "en"
      }
    parameters["timezone"] = "\(TimeZone.current.secondsFromGMT()/60)"
    parameters["date"] = convertInUTC()
    if let restaurantId = parameters["restaurantId"] {
         print(restaurantId)
      let urlPath = "api/customer/getRestaurantDetails"
            //let headers = ["": ""]
            HTTPRequest(method: .get,
                        path: urlPath,
                        parameters: parameters,
                        encoding: .url,
                        files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
                .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                    
                    if response.error != nil {
                        callBack(nil, response.error)
                        return
                    }
                    //print("response ",response)
                    if let dict = response.value as? [String: Any] {
                        print("data", dict)
                        if let data = dict["data"] as? [String: Any] {
                            print(data)
                            let details = MenuDetails(data: data)
                            print(details)
                            callBack(details, nil)
                            return
                            
                        }
                    }
                    callBack(nil, response.error)
            }
        }
    }
  
  //MARK: Get All Menu related to Branch and Restaurant
    func getMenu(parameters: [String: Any], callBack: @escaping RestaurantManagerCallBack) {
       var parameters = parameters
       let language = Localize.currentLang()
       parameters["date"] = convertInUTC()
       parameters["timezone"] = "\(TimeZone.current.secondsFromGMT()/60)"
       if bookingFlow == .home {
            parameters["bookingType"] = Booking.home.rawValue
        } else {
            parameters["bookingType"] = Booking.pickUp.rawValue
        }
       if language == .english {
         parameters["language"] = "en"
       } else {
         parameters["language"] = "en"
       }
            //let headers = ["": ""]
            HTTPRequest(method: .get,
                        path: "api/customer/getMenu",
                        parameters: parameters,
                        encoding: .url,
                        files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
                .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                    
                    if response.error != nil {
                        callBack(nil, response.error)
                        return
                    }
                    if let dict = response.value as? [String: Any] {
                        print("data", dict)
                        if let data = dict["data"] as? [String: Any] {
                            print(data)
                            let details = MenuOFRestaurant(param: data)
                            print(details)
                            callBack(details, nil)
                            return
                            
                        }
                    }
                    callBack(nil, response.error)
            }
        
    }
}
