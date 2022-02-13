//
//  HyperPaymentManager.swift
//  al-manarah
//
//  Created by clicklabs on 25/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
var providerCheckOut: OPPCheckoutProvider?

class HyperPaymentManager: NSObject {
    fileprivate var selectedPayment = PaymentPayModel()
    fileprivate var currentTransactionModel = TransactionModel()
    fileprivate var selectedCard = ""
    override init() {
        super.init()
    }
    
 static func startPayement(currentTransactionModel: TransactionModel, callBack: @escaping ( _ response: OPPTransaction?, _ error: Error?) -> Void) {
    
        HyperPaymentManager().setParam(currentTransactionModel: currentTransactionModel, callback: callBack)
    
     }
    
    private func setParam(currentTransactionModel: TransactionModel, callback: @escaping(OPPTransaction?, Error?) -> Void) {
        
        
        //let provider = OPPPaymentProvider(mode: OPPProviderMode.test)
         let provider = OPPPaymentProvider(mode: OPPProviderMode.live)
       // self.selectedPayment = selectedPayment
        self.currentTransactionModel = currentTransactionModel
        let checkoutSettings = OPPCheckoutSettings()
        checkoutSettings.schemeURL = "com.qawafeltech.FoodStar.payments"
        checkoutSettings.theme.navigationBarBackgroundColor = #colorLiteral(red: 0.7764705882, green: 0, blue: 0.2352941176, alpha: 1)
        checkoutSettings.theme.cellHighlightedBackgroundColor = #colorLiteral(red: 0.7764705882, green: 0, blue: 0.2352941176, alpha: 1)
        checkoutSettings.theme.cellHighlightedTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        checkoutSettings.theme.confirmationButtonColor = #colorLiteral(red: 0.7764705882, green: 0, blue: 0.2352941176, alpha: 1)
        checkoutSettings.theme.confirmationButtonTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        checkoutSettings.theme.cancelBarButtonImage = #imageLiteral(resourceName: "cancel")
        
        print("card trypes", selectedPayment.code, checkoutSettings.paymentBrands)
        if selectedPayment.code == "visa" {
            selectedCard = "VISA"
        } else if selectedPayment.code == "master" {
            selectedCard = "MASTER"
        }
        
//        else if selectedPayment.code == "Mada"{
//            selectedCard = "mada"
//        }
        checkoutSettings.paymentBrands = ["MASTER", "VISA"]
        let checkoutID = self.currentTransactionModel.transactionId
        if let checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings) {
            providerCheckOut = checkoutProvider
            checkoutProvider.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
            if error != nil {
                callback(transaction, error)
                // Executed in case of failure of the transaction for any reason.
            } else {
                
                // Send request to your server to obtain the status of the synchronous transaction.
                // You can use transaction.resourcePath or just checkout id to do it.
            }
        }, paymentBrandSelectedHandler: { (paymentBrand, completion) in
            // Executed if the shopper selected payment brand.
            // Send request to your server for obtaining a new checkout id if it is required for selected payment brand.
            
            print("payment brand select", checkoutID)
            completion(checkoutID)
        }, cancelHandler: {
            let errorString: String = "User Cancelled the action"
            let error: Error = NSError(domain: "callback", code: 0, userInfo: [NSLocalizedDescriptionKey: errorString]) as Error
            callback(nil, error)
            //customAlert(message: "User cancelled the checkout".localized)
            // Executed if the shopper closes the payment page prematurely.
        })
    }
}
    
}
