//
//  Me.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/3/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class Me: User, LoginProtocol {
    
    var accessToken: String?
    var isEmailVerified: Bool = false
    var isSocial: Bool = true
    var isPhoneVerified: Bool = false
    var rememberMe: Bool = false
  
  
    override init() {
        super.init()
    }
    
    required init(with param: [String: Any]) {
        super.init(with: param)
        if let accessToken = param["accessToken"] as? String {
            self.accessToken = accessToken
        }
      
        if let isEmailVerified = param["isEmailVerified"] as? Bool {
            self.isEmailVerified = isEmailVerified
        }
        
        if let isSocial = param["isSocial"] as? Bool {
            self.isSocial = isSocial
        }
        print("Social \(self.isSocial)")
        if let userDetails = param["userDetails"] as? [String: Any], let isPhoneVerified = userDetails["phoneVerified"] as? Bool {
            self.isPhoneVerified = isPhoneVerified
        }
        
        if let contacts = param["contacts"] as? [[String: Any]] {
            if let contact = contacts.first {
                self.updateContactDetail(contact: contact)
            }
        }
        
    }
    
    override func updateContactDetail(contact: [String: Any]) {
        super.updateContactDetail(contact: contact)
        
        if let isVerified = contact["isVerified"] as? Bool {
            self.isPhoneVerified = isVerified
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
    }
    
}
