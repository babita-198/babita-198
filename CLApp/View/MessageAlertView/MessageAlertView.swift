//
//  MessageAlertView.swift
//  FoodFox
//
//  Created by clicklabs on 15/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class MessageAlertView: UIViewController {
  
  //MARK: Outlet
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.font = AppFont.regular(size: 15)
        }
    }
    @IBOutlet weak var okBtn: UIButton! {
        didSet {
            okBtn.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
  @IBOutlet weak var messageView: UIView!
  //MARK: Variables
  var messageString = ""
  
  override func viewDidLoad() {
        super.viewDidLoad()
      localizedString()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         checkStatusForDarkMode()
    }
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
             messageLabel.textColor = lightWhite
            messageView.backgroundColor =  #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        } else {
            messageLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            messageView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    
    
    
  
  //MARK: Localized String
  func localizedString() {
    messageLabel.text = messageString
    okBtn.setTitle("Ok".localizedString, for: .normal)
  }
  
  //MARK: OK Action to dismiss Controller
  @IBAction func okAction(_ sender: UIButton) {
  self.dismiss(animated: true, completion: nil)
  }
}
