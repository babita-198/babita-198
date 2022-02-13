//
//  User.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/3/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

//protocol UserApi {
//  static func list(callback: @escaping (_ respons: Any?, _ error: Error?) -> Void)
//  func friendList(callback: @escaping (_ respons: Any?, _ error: Error?) -> Void)
//  func friendRequest()
//  func unfriend()
//  func acceptFriendRequest()
//  func howOldAreYou() -> String
//}

// Personal info model.
class User: NSObject, NSCoding, Personable {
    
    var id: String?
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var mobile: String?
    var diallingCode: String?
    var email: String?
    var dob: Date?
    var gender: Gender? = .male
    var role: UserRole?
    var isVerified: Bool?
    var imageUrl: String?
    var username: String?
    var name: String?
    var socialLogin = false
    var address: String?
    var walletAmount: Double = 0.0
    var referTo: Double = 0.0
    var referBy: Double = 0.0
    var loyalityPoint: Double = 0.0
    var totalPoints: Double = 0.0
    var referalCode: String = ""
    
    var fullName: String? {
        var components = PersonNameComponents()
        components.givenName = self.firstName
        components.middleName = self.middleName
        components.familyName = self.lastName
        let name = PersonNameComponentsFormatter.localizedString(from: components, style: .default, options: [])
        return name
    }
    
    // MARK: -
    override init() {
        super.init()
    }
    
    required init(with data: [String: Any]) {
        //parsing...
        var params: [String: Any]
        guard let userDetail = data["userDetails"] as? [String: Any] else {
            return
        }
        params = userDetail
        if let paramData = userDetail["CustomerData"] as? [String: Any] {
            params = paramData
        }
        print("user params\(params)")
        
      //MARK: Referral
      if let referalCode = params["invitationCode"] as? String {
        self.referalCode = referalCode
      }
      
      if let accessToken = params["walletAmount"] as? Int {
        self.walletAmount = Double(accessToken)
      }
      
      if let accessToken = params["referredByPointsValue"] as? Int {
        self.referBy = Double(accessToken)
      }
      
      if let accessToken = params["referredToPointsValue"] as? Int {
        self.referTo = Double(accessToken)
      }
      
      if let accessToken = params["walletAmount"] as? Double {
        self.walletAmount = accessToken
      }
        //Total points
        if let accessToken = params["totalCompleteBookings"] as? Double {
            self.totalPoints = accessToken
        }
        //Loyality points
        if let accessToken = params["loyalityPoint"] as? Double {
            self.loyalityPoint = accessToken
        }
        
      
      if let accessToken = params["referredByPointsValue"] as? Double {
        self.referBy = accessToken
      }
      
      if let accessToken = params["referredToPointsValue"] as? Double {
        self.referTo = accessToken
      }
      
        if let id = params["_id"] as? String {
            self.id = id
        }
        //social
        if let id = params["id"] as? String {
            self.id = id
        }
        
        if let firstName = params["firstName"] as? String {
            self.firstName = firstName
        }
        //soacil
        if let firstName = params["first_name"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = params["LastName"] as? String {
            self.lastName = lastName
        }
        //Social
        if let lastName = params["last_name"] as? String {
            self.lastName = lastName
        }
        
        if let countryCode = params["countryCode"] as? String {
            self.diallingCode = countryCode
        }
        
        if let phoneNo = params["phoneNo"] as? String {
            self.mobile = phoneNo
        }
        
        if let isVerified = params["IsVerified"] as? Bool {
            self.isVerified = isVerified
        }
        if let email = params["email"] as? String {
            self.email = email
        }
        if let address = params["address"] as? String {
            self.address = address
        }
        if let profilePicture = params["profilePicURL"] as? [String: AnyObject] {
            if let originalImageUrl = profilePicture["original"] as? String {
                imageUrl = originalImageUrl
            }
        }
        //social
        if let profilePicture = params["picture"] as? [String: AnyObject] {
            if let originalImageUrl = profilePicture["original"] as? String {
                imageUrl = originalImageUrl
            }
      }
        
    }
    
    func updateContactDetail(contact: [String: Any]) {
        //    if let _ = contact["_id"] as? String {
        //    }
        
        if let countryCode = contact["countryCode"] as? String {
            self.diallingCode = countryCode
        }
        
        if let mobile = contact["mobile"] as? String {
            self.mobile = mobile
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.middleName = aDecoder.decodeObject(forKey: "middleName") as? String
        
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        
        
        self.mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        self.diallingCode = aDecoder.decodeObject(forKey: "diallingCode") as? String
        
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        
        self.dob = aDecoder.decodeObject(forKey: "dob") as? Date
        
        if let genderString = aDecoder.decodeObject(forKey: "gender") as? String {
            if let gender = Gender(rawValue: genderString) {
                self.gender = gender
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        
        //personal identity
        aCoder.encode(id, forKey: "id")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(middleName, forKey: "middleName")
        
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(diallingCode, forKey: "diallingCode")
        aCoder.encode(email, forKey: "email")
        
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(gender?.rawValue, forKey: "gender")
        
    }
    
    // MARK: -
    func friendList(callback: @escaping (_ respons: Any?, _ error: Error?) -> Void) {
        
        var param = [String: Any]()
        
        if let id = self.id {
            param["userId"] = id
        }
        
        HTTPRequest(method: .get, path: "api/user/friends", parameters: param, files: nil).handler { (response: HTTPResponse) in
            
            if response.error != nil {
                callback(nil, response.error)
                return
            }
            
            if let listOfDict = response.value as? [[String: Any]] {
                let userList: [User] = listOfDict.toModelArray()
                callback(userList, nil)
                return
            }
            callback(response.value, nil)
            
        }
    }
    
    class func list(callback: @escaping (_ respons: Any?, _ error: Error?) -> Void) {
        
        HTTPRequest(method: .get, path: "api/users", parameters: nil, files: nil).handler { (response: HTTPResponse) in
            
            if response.error != nil {
                callback(nil, response.error)
                return
            }
            
            if let listOfDict = response.value as? [[String: Any]] {
                let userList: [User] = listOfDict.toModelArray()
                callback(userList, nil)
                return
            }
            
            callback(response.value, nil)
            
        }
        
    }
    
    /// Description
    ///
    /// - Returns: return value description
    
    /// return
    ///
    /// - Returns: return DOB in display format
    func howOldAreYou() -> String {
        return ""
    }
    
    func friendRequest() {
    }
    
    func unfriend() {
    }
    
    func acceptFriendRequest() {
    }
    
}

extension User: JSONSerializable {}

extension User: SerializableArray {}
