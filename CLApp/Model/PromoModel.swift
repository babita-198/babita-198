  //
  //  PromoModel.swift
  //  FoodFox
  //
  //  Created by clicklabs on 02/01/18.
  //  Copyright © 2018 Click-Labs. All rights reserved.
  //

  import Foundation

  typealias Promo = ((_ data: [PromoModel]?, _ error: Error?) -> Void)
  typealias PromoApply = ((_ data: Double?, _ error: Error?) -> Void)
  
  class PromoModel {
    var promoId: String?
    var promoName: String?
    var promoCredit: Int?
    var startDate: String?
    var endDate: String?
    var promoImage: String?
    var promoType: String?
    var description: String?
    
    init(promoData: [String: Any]) {
      if let id = promoData["_id"] as? String {
        self.promoId = id
      }
      if let promoName = promoData["code"] as? String {
        self.promoName = promoName
      }
      if let promoCredit = promoData["credits"] as? Int {
        self.promoCredit = promoCredit
      }
      if let startDate = promoData["startDate"] as? String {
        self.startDate = startDate
      }
      if let endDate = promoData["endDate"] as? String {
        self.endDate = endDate
      }
      if let image = promoData["imageURL"] as? [String: Any] {
        if let original = image["original"] as? String {
        self.promoImage = original
        }
      }
      if let promoType = promoData["promoType"] as? String {
        self.promoType = promoType
      }
        if let description = promoData["description"] as? [String: Any]{
            if let original = description["en"] as? String {
                self.description = original
            }
        }
    }
    
    //MARK: Apply PromoCode
    static func applyPromoCode(params: [String: Any], callBack: @escaping PromoApply) {
      
      HTTPRequest(method: .get,
                  path: API.applyPromo,
                  parameters: params,
                  encoding: .url,
                  files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
        .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
          
          if response.error == nil {
            if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
              let amount = data["amount"] as? Double ?? 0.0
              callBack(amount, nil)
              return
            }
          }
          callBack(nil, response.error)
          return
      }
    }
    
    
    //MARK: Get PromoCodes
    static func getPromo(param: [String: Any], callBack: @escaping Promo) {
      HTTPRequest(method: .get,
                  path: API.getPromo,
                  parameters: param,
                  encoding: .url,
                  files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
        .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
          
          if response.error == nil {
            if let responseValue = response.value as? [String: Any], let data = responseValue["data"] as? [String: Any] {
              if let list = data["activePromoCodes"] as? [[String: Any]] {
                var promoList: [PromoModel] = []
                for promoCode in list {
                  if  let id = promoCode["_id"] as? String {
                   print(id)
                  promoList.append(PromoModel(promoData: promoCode))
                  }
                }
                callBack(promoList, nil)
                return
              }
            }
          }
          callBack(nil, response.error)
          return
      }
    }
  }
