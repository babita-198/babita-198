//
//  PaymentPayModel.swift
//  al-manarah
//
//  Created by clickpass on 15/9/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class PaymentPayModel: NSObject {
        var id = -1
        var name = "Cash On Delivery"
        var code = "cash-on-delivery-cod"
        var odooId = 0
        var paymentType = "cash_on_delivery"
        var hasFees = false
        var feesAmount = 0.0
        var active = false
        var isSelected = false
    
    override init() {
        
    }
    init(jsonData: [String: Any]) {
        if let id = jsonData["id"] as? Int {
            self.id = id
        }
        if let odooId = jsonData["odoo_id"] as? Int {
            self.odooId = odooId
        }
        if let feesAmount = jsonData["fees_amount"] as? Double {
            self.feesAmount = feesAmount
        }
        if let name = jsonData["name"] as? String {
            self.name = name
        }
        if let code = jsonData["code"] as? String {
            self.code = code
        }
        if let paymentType = jsonData["payment_type"] as? String {
            self.paymentType = paymentType
        }
        if let hasFees = jsonData["has_fees"] as? Bool {
            self.hasFees = hasFees
        }
        if let active = jsonData["active"] as? Bool {
            self.active = active
        }
    }
}
// Dummy data for model
//{
//    "id": 2,
//    "name": "Cash On Delivery",
//    "code": "cash-on-delivery-cod",
//    "odoo_id": 17,
//    "payment_type": "cash_on_delivery",
//    "has_fees": true,
//    "fees_amount": 15,
//    "last_modified": "2017-08-16T10:37:10.884833Z",
//    "active": true
//}
class TransactionModel: NSObject {
    var id = "0"
    var txnType = ""
    var reference = ""
    var amount = ""
    var status = ""
    var note = ""
    var transactionId = ""
    var order = ""
    var sourceType = ""
    
    override init() {
    }
    
    init(jsonData: [String: Any]) {
        guard let data = jsonData["data"] as? [String: Any] else {
            return
        }
        if let jsonData = data["paymentCheckoutData"] as? [String: Any] {
            if let id = jsonData["id"] as? String {
                self.transactionId = id
            }
        }
        if let jsonData = data["paymentCheckoutData"] as? [String: Any] {
            if let id = jsonData["id"] as? String {
                self.id = id
            }
        }
        if let jsonData = data["paymentCheckoutData"] as? [String: Any] {
                   if let amount = jsonData["amount"] as? String {
                       self.amount = amount
                   }
               }
    }
}
//{
//    "id": 38,
//    "txn_type": "Debit",
//    "reference": "",
//    "amount": "87.00",
//    "status": "pending",
//    "note": null,
//    "transaction_id": "ca17b391-de8c-4119-a1a4-a1ce49433b53",
//    "order": null,
//    "source_type": null,
//    "user": 31,
//    "basket": 901
//}

// MARK: MODEL to Save order Id after making order
class PaymentSuccessData: NSObject {
    
    
    
}
