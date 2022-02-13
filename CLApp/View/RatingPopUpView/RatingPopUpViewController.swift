//
//  RatingPopUpViewController.swift
//  FoodFox
//
//  Created by clicklabs on 15/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class RatingPopUpViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var feedback: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rateView: UIView!
    
    //MARK: Variable
    var bookingId = ""
    var name: String = ""
    var deliveryTime = ""
    var ratingSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedString()
        detailSetUp()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localizedString()
        checkStatusForDarkMode()
    }
    
    //MARK:- DARK MODE STATUS CHECK
    func checkStatusForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            self.rateView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.time.textColor = lightGreen
            self.driverName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.feedback.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            
        } else {
              self.rateView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.titleLabel.textColor = UIColor.black
            self.time.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.driverName.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.feedback.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        }
    }
    
    
    
    
    
    
    
    //MARK: Setup driver Details
    func detailSetUp() {
        let deliveredOn = "Delivered on".localizedString
        time.text = "\(deliveredOn) "+dateDeliveryFormate(date: deliveryTime)
        time.isHidden = true
        if name == "" {
            driverName.text = ""
        } else {
            //let by = "By".localizedString
            driverName.text = name
        }
        driverName.isHidden = true
        submitButton.setTitle("SUBMIT".localizedString, for: .normal)
    }
    
    
    @objc func viewTaped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: rateView) ?? false {
            return false
        }
        return true
    }
    
    //MARK: Localized String
    func localizedString() {
        titleLabel.text = "Order Delivered".localizedString
        feedback.text = "Write Feedback…".localizedString
        feedback.textColor = .lightGray
        feedback.borderWidth = 1
        feedback.borderColor = .lightGray
        feedback.delegate = self
        ratingView.emptyImage = #imageLiteral(resourceName: "unSelectedRate")
        ratingView.fullImage = #imageLiteral(resourceName: "selectedRate")
        ratingView.halfRatings = false
        ratingView.maxRating = 5
        ratingView.minRating = 0
        localizedTextFieldAlignment()
    }
    
    /// function to localize textfield placeholder and text alignment
    func localizedTextFieldAlignment() {
        let language = Localize.currentLang()
        if language == .arabic {
            self.feedback.textAlignment = .right
        } else {
            self.feedback.textAlignment = .left
        }
    }
    
    //MARK: Rate your booking service
    func rateBooking() {
        if feedback.text == "Write Feedback…".localizedString || feedback.text == "" {
            customAlert(controller: self, message: "Please write feedback".localizedString)
            return
        }
        var param: [String: Any] = [:]
        param["bookingId"] = bookingId
        param["rating"] = ratingView.rating
        if feedback.text != "Write Feedback…".localizedString {
            param["comment"] = feedback.text
        } else {
            param["comment"] = ""
        }
        OrderModel.rateOrder(param: param, callBack: {(response: [String: Any]?, error: Error?) in
            if error == nil {
                if let callback = self.ratingSuccess {
                    callback()
                }
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    //MARK: Submit Button Action
    @IBAction func submitAction(_ sender: UIButton) {
        if ratingView.rating < 1.0 {
            customAlert(controller: self, message: "Please rate for booking service".localizedString)
            //    let alert = UIAlertController(title: "", message: "Please rate for booking service".localizedString, preferredStyle: UIAlertControllerStyle.alert)
            //    alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .cancel, handler: nil))
            //    self.present(alert, animated: true, completion: nil)
        } else {
            rateBooking()
        }
    }
}

//MARK: TextView Delegates
extension RatingPopUpViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if feedback.text == "Write Feedback…".localizedString {
            feedback.text = ""
            feedback.textColor = headerColor
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            feedback.text = "Write Feedback…".localizedString
            feedback.textColor = .lightGray
        } else {
            feedback.textColor = headerColor
        }
    }
}
