//
//  ReviewModel.swift
//  FoodFox
//
//  Created by clicklabs on 08/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import Foundation

typealias Review = ((_ data: [ReviewModel]?, _ error: Error?) -> Void)

class ReviewModel {
  var reviewId: String?
  var reviewText: String?
  var userImage: String?
  var ratingCount: Float?
  var userFullName: String?
  var lastName: String = ""
  var firstName: String = ""
  
  
  init(reviewData: [String: Any]) {
    
    if  let data = reviewData["customer"] as? [String: Any] {
      if let detail = data["profilePicURL"] as? [String: Any] {
        if let userImage = detail["original"] as? String {
          self.userImage = userImage
        }
      }
      if let firstName = data["firstName"] as? String {
        self.firstName = firstName
      }
      if let lastName = data["LastName"] as? String {
        self.lastName = lastName
      }
    }
    
    if let id = reviewData[""] as? String {
      self.reviewId = id
    }
    if let detail = reviewData["rating"] as? [String: Any] {
      if let reviewText = detail["comment"] as? String {
        self.reviewText = reviewText
      }
      if let ratingCount = detail["stars"] as? Int {
        self.ratingCount = Float(ratingCount)
      }
    }
    self.userFullName = self.firstName + self.lastName
  }
  
  //MARK: Get PromoCodes
  static func getReviewData(restaurantId: String, skip: Int, limit: Int, callBack: @escaping Review) {
    
    var param: [String: Any] = [:]
    param["restaurantId"] = restaurantId
    param["skip"] = skip
    param["limit"] = limit
    
    HTTPRequest(method: .get,
                path: API.getAllReview,
                parameters: param,
                encoding: .url,
                files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
            if let list = data["reviewsData"] as? [[String: Any]] {
              var reviewList: [ReviewModel] = []
              for reviewData in list {
                if let id = reviewData["_id"] as? String {
                  print(id)
                  reviewList.append(ReviewModel(reviewData: reviewData))
                }
              }
              callBack(reviewList, nil)
              return
            }
          }
        }
        callBack(nil, response.error)
        return
    }
  }
 
}
