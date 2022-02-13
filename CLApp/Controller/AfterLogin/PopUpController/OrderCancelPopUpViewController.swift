  //
  //  OrderCancelPopUpViewController.swift
  //  FoodFox
  //
  //  Created by clicklabs on 11/12/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

  import UIKit

  class OrderCancelPopUpViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: OUTLET
    @IBOutlet weak var cancelOrderLabel: UILabel!
    @IBOutlet weak var orderMessage: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var cancelView: UIView!

    // MARK:  VARIABLES
    var orderId = ""
    var bookingId = ""
    var modeOfPayment = ""
    var totalAmount: Double = 0.0
    var yesCancelCallback: (() -> Void)?

    //MARK: view did load
    override func viewDidLoad() {
          super.viewDidLoad()
         localizedString()
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped))
      tapGesture.delegate = self
      self.view.addGestureRecognizer(tapGesture)
      }
    
    override func viewWillAppear(_ animated: Bool) {
         checkStatusForNightMode()
    }
    
    
    func checkStatusForNightMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            cancelView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cancelOrderLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            orderMessage.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            orderIdLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            
        } else {
            cancelView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cancelOrderLabel.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            orderMessage.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            orderIdLabel.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            
            
        }
        
    }
    @objc func viewTaped() {
      self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      if touch.view?.isDescendant(of: cancelView) ?? false {
        return false
      }
      return true
    }
    
    
    //MARK: Localized String
    func localizedString() {
        print(modeOfPayment)
        print(totalAmount)
      
        let orderId = "\( self.orderId)?"
        
        cancelOrderLabel.text = "Cancel Order"
        orderMessage.text = "Are you sure to cancel your order \(orderId)"
        var orderCancelMessage = "cancel your order "
        
        if modeOfPayment != "CASH" {
            orderCancelMessage = "Cancellation charges may apply to your next order."
        } else {
            orderCancelMessage = "Rs. \(totalAmount) cancellation amount will be applied to your next order."
        }
        
        let myMutableString = NSMutableAttributedString(string: orderCancelMessage, attributes: [NSAttributedString.Key.font: UIFont(name: fontNameRegular, size: 13) ?? UIFont.systemFontSize])
        let orderIdString = NSMutableAttributedString(string: orderId, attributes: [NSAttributedString.Key.font: UIFont(name: fontStyleSemiBold, size: 17) ?? UIFont.systemFontSize])
      let combination = NSMutableAttributedString()
      combination.append(myMutableString)
      //combination.append(orderIdString)
//        orderIdLabel.numberOfLines = 2
      orderIdLabel.attributedText =  combination
      yesButton.setTitle("YES".localizedString, for: .normal)
      noButton.setTitle("NO".localizedString, for: .normal)
    }
    
    // Cancel Button Action
    @IBAction func yesButtonAction(_ sender: UIButton) {
      guard let call = yesCancelCallback else {
        return
      }
      self.dismiss(animated: true, completion: nil)
      call()
    }
    
    // MARK: No Calcel Button Action
    @IBAction func noButtonAction(_ sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
    }
  }
