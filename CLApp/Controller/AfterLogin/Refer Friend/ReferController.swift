//
//  ReferController.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class ReferController: CLBaseViewController {
   
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
        navTitle.font = AppFont.semiBold(size: 17)
        }
    }
    @IBOutlet weak var messageDescription: UILabel! {
        didSet {
            messageDescription.font = AppFont.regular(size: 16)
        }
    }
    @IBOutlet weak var promoValue: UILabel! {
        didSet {
            promoValue.font = AppFont.bold(size: 22)
        }
    }
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var backGroundDarkView: UIView!
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
         shareButton.titleLabel?.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var backButtonOut: UIButton!
    @IBOutlet weak var copiedView: UIView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var tapToCopy: UILabel! {
        didSet {
            tapToCopy.font = AppFont.light(size: 14)
        }
    }
    @IBOutlet weak var copied: UILabel! {
        didSet {
            copied.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var topView: UIView!

    //MARK: VARIABLE
    var isFromSide = true
    var referral: Double = 0.0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        changeConstraint(controller: self, view: topView)
        self.navigationController?.navigationBar.isHidden = true
        if isFromSide {
        backButtonOut.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        } else {
        backButtonOut.changeBackBlackButton()
        }
  }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
       setViewDot()
       setMessageFont()
      copiedView.isHidden = true
      localizedString()
        
    checkStatusForNightMode()
        
    }
  
    
    
    
    func checkStatusForNightMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            backGroundDarkView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            backButtonOut.setImage(UIImage(named: "menu-1"), for: .normal)
           dotView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.messageDescription.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.tapToCopy.textColor = lightWhite
            
        } else {
            topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
              backGroundDarkView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            backButtonOut.setImage(UIImage(named: "menu"), for: .normal)
            dotView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.messageDescription.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.tapToCopy.textColor = lightGrayColor
            
            
        }
        
    }
  func localizedString() {
    navTitle.text = "Refer A Friend".localizedString
    shareButton.setTitle("SHARE NOW".localizedString, for: .normal)
    tapToCopy.text = "Tap to copy".localizedString
    copied.text = "Copied".localizedString
  }
  
  //MARK: Get Referal Code
  func getReferralCode() {
    TrackOrderModel.getReferralCode(callBack: { (response: String?, amount: Double?, error: Error?) in
      if error == nil {
        self.promoValue.text = response ?? ""
        self.referral = amount ?? 0.0
        self.setMessageFont()
      }
    })
  }
  
  //MARK: Copeid Button
  @IBAction func copyButtonAction(_ sender: UIButton) {
    self.copiedView.isHidden = false
    self.copiedView.alpha = 1
    setView()
  }
  
  func setView() {
    UIView.animate(withDuration: 2.3, delay: 0, options: [], animations: {
      self.copiedView.alpha = 0
    }, completion: { _ in
       UIPasteboard.general.string = self.promoValue.text ?? ""
      self.copiedView.isHidden = true
    })
  }
  
   //MARK:  Set View Dot
    func setViewDot() {
    let yourViewBorder = CAShapeLayer()
    let rect = dotView.bounds
    yourViewBorder.strokeColor = UIColor.gray.cgColor
        yourViewBorder.lineJoin = CAShapeLayerLineJoin.round
    yourViewBorder.lineDashPattern = [2, 2]
    yourViewBorder.frame = rect
    yourViewBorder.fillColor = nil
    yourViewBorder.path = UIBezierPath(rect: dotView.bounds).cgPath
    dotView.layer.addSublayer(yourViewBorder)
    }
    
    //MARK: Set Font
    func setMessageFont() {
      let manager = LoginManagerApi.share.me
      let referBy = manager?.referBy ?? 0.0
      let referTo = manager?.referTo ?? 0.0
      self.promoValue.text = manager?.referalCode
      let str = "For each friend that joins and places its first order, you and your friend will receive".localizedString
      let respect = "respectively".localizedString
      let refer = "Refer your friends to FoodFox.".localizedString
      let sar = "Rs.".localizedString
     let attributedString = NSMutableAttributedString(string: "\(refer) \n\(str) \(sar) \(referTo.roundTo1Decimal()) & \(sar) \(referBy.roundTo1Decimal()) \(respect)")

    attributedString.addAttributes([
        NSAttributedString.Key.font: AppFont.semiBold(size: 14),
        NSAttributedString.Key.foregroundColor: UIColor(red: 198.0 / 255.0, green: 0.0, blue: 60.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 22, length: 8))
      messageDescription.attributedText = attributedString
        
    }
  
    // MARK: Share Button
    @IBAction func shareButtonAction(_ sender: UIButton) {
      self.shareReferral()
    }

  //MARK: Share Refferal
  func shareReferral() {
    
    let manager = LoginManagerApi.share.me
    let referBy = manager?.referBy ?? 0.0
//    let msg = "You will get Rs. \(referBy.roundTo1Decimal()) on your first order."
//    let linkString = "Check out FoodFox, Your friend has shared a referral link".localizedString
//    let text = "\(linkString): https://www.foodfox.in/#/register/\(self.promoValue.text ?? "") \(msg)"
  
    
    let msg = "Signup with referral code \(self.promoValue.text ?? "") and You will get Rs. \(referBy.roundTo1Decimal()) on your first order."
    let linkString = "Check out FoodFox, Your friend has shared a referral link"
    let appLink = "https://apps.apple.com/us/app/foodstar-delivery-pickup/id1509260018?ls=1"
    let text = "\(linkString): \(appLink) \(msg)"
    let textToShare = [ text ]
    print(textToShare)
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
    self.present(activityViewController, animated: true, completion: nil)
  }

    //MARK: Back Button
    @IBAction func backButtonAction(_ sender: UIButton) {
        if isFromSide {
          let language = Localize.currentLang()
          if language == .arabic {
            self.revealViewController().rightRevealToggle(animated: true)
            return
          }
         self.revealViewController().revealToggle(animated: true)
        } else {
        self.navigationController?.popViewController(animated: true)
        }
    }

}
