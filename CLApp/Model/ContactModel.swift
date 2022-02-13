//
//  ContactModel.swift
//  FoodFox
//
//  Created by clicklabs on 04/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import Foundation

typealias ContactUS = ((_ data: [String: Any]?, _ error: Error?) -> Void)
typealias SubjectList = ((_ data: [ContactModel]?, _ error: Error?) -> Void)


class ContactModel {
  var subjectId: String?
  var subject: String?
  
  init(data: [String: Any]) {
    if let subject = data["subject"] as? String {
      self.subject = subject
    }
    if let subjectId = data["_id"] as? String {
      self.subjectId = subjectId
    }
  }
  
  //MARK: Submit Query
  static func contactUs(param: [String: Any], callBack: @escaping ContactUS) {
    HTTPRequest(method: .post,
                path: API.contact,
                parameters: param,
                encoding: .json,
                files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        
        if response.error == nil {
          if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
            callBack(data, nil)
            return
          }
        }
        callBack(nil, response.error)
        return
    }
  }
  
  //MARK: Get Subject List
  static func subjectList(callBack: @escaping SubjectList) {
    var parameters: [String: Any] = [:]
    let language = Localize.currentLang()
    if language == .english {
        parameters["language"] = "en"
    } else {
        parameters["language"] = "en"
    }
    
    HTTPRequest(method: .get,
                path: API.subjectList,
                parameters: parameters,
                encoding: .url,
                files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
      .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
        if response.error == nil {
          var list: [ContactModel] = []
           if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
            if let listData = data["subject"] as? [[String: Any]] {
              for subject in listData {
                if let id = subject["_id"] as? String {
                  print(id)
                  let obj = ContactModel(data: subject)
                  list.append(obj)
                }
              }
            }
            callBack(list, nil)
            return
          }
        }
        callBack(nil, response.error)
        return
    }
  }
  
}
