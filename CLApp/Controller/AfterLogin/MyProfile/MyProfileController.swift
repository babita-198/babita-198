//
//  MyProfileController.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class MyProfileController: CLBaseViewController {
    
    @IBOutlet var mbProgressView: MBCircularProgressBarView!
    // MARK: - IBOutlet
    @IBOutlet weak var userProfilepic: UIImageView!
    @IBOutlet weak var userName: UILabel! {
        didSet {
            userName.font = AppFont.semiBold(size: 20)
        }
    }
    @IBOutlet weak var goldLeveLbl: UILabel! {
        didSet {
            goldLeveLbl.font = AppFont.regular(size: 15)
        }
    }
    @IBOutlet weak var userEmailid: UILabel! {
        didSet {
            userEmailid.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var userContactNo: UILabel! {
        didSet {
            userContactNo.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var editBtn: UIButton! {
        didSet {
            editBtn.titleLabel?.font = AppFont.regular(size: 17)
        }
    }
    
    @IBOutlet weak var platinumLbl: UILabel! {
        didSet {
            platinumLbl.font = AppFont.bold(size: 15)
        }
    }
    
    @IBOutlet weak var emailLbl: UILabel! {
        didSet {
            emailLbl.font = AppFont.regular(size: 18)
        }
    }
    
    @IBOutlet weak var phoneNoLbl: UILabel! {
        didSet {
            phoneNoLbl.font = AppFont.regular(size: 18)
        }
    }
    
    
    @IBOutlet weak var changePasswordLbl: UILabel! {
        didSet {
            changePasswordLbl.font = AppFont.regular(size: 18)
        }
    }
    
    @IBOutlet weak var rewardsLbl: UILabel! {
        didSet {
            rewardsLbl.font = AppFont.bold(size: 25)
        }
    }
    
    @IBOutlet weak var pointsLbl: UILabel! {
        didSet {
            pointsLbl.font = AppFont.regular(size: 19)
        }
    }
    
    @IBOutlet weak var rewardPoints: UILabel! {
        didSet {
            rewardPoints.font = AppFont.bold(size: 26)
        }
    }
    
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 22)
        }
    }
    @IBOutlet weak var logOutBtn: UIButton! {
        didSet {
            logOutBtn.titleLabel?.font = AppFont.semiBold(size: 22)
        }
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var percentageValue: UILabel!
    @IBOutlet weak var profileDetailsView: UIView!
    @IBOutlet weak var changePassView: UIView!
    @IBOutlet weak var rewardsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mbProgressView.
        //let number = Int.random(in: 1 ..< 49)
        mbProgressView.value = CGFloat(LoginManagerApi.share.me?.totalPoints  ?? 0)
       
        let referBy: String = String(format: "%.0f", LoginManagerApi.share.me?.referBy ?? 0)
        
        let totalOrderValue: String = String(format: "%.0f", CGFloat(LoginManagerApi.share.me?.totalPoints  ?? 0))
        if mbProgressView.value == 50 || mbProgressView.value >= 50 {
           
            mbProgressView.value = 50
            mbProgressView.maxValue = 50
            print("equal or more", mbProgressView.value, mbProgressView.maxValue)
            self.percentageValue.text = totalOrderValue + "/" + "50" + "+"
            
        } else {
            mbProgressView.maxValue = 50
            print("less", mbProgressView.value)
            self.percentageValue.text = totalOrderValue + "/" + "50"
            // mbProgressView.unitString = "/" + "50"
        }
        
        changeConstraint(controller: self, view: topView)
//        self.setData()
        localizedString()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkStatusForDarkMode()
        self.setData()
    }
    
    //MARK:- DARK MODE STATUS CHECK
    func checkStatusForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            self.topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.profileDetailsView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.emailLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.userEmailid.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.phoneNoLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.userContactNo.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.changePasswordLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.rewardsLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.rewardPoints.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.pointsLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            mbProgressView.progressStrokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.changePassView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.bottomView.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.rewardsView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.mainView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            mbProgressView.fontColor = UIColor.clear
            self.percentageValue.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.btnMenu.setImage(UIImage(named: "menu-1"), for: .normal)
            self.lockImageView.image = UIImage(named: "PasswordW")
            self.arrowImageView.image = #imageLiteral(resourceName: "ar")
        } else {
            self.topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.navTitle.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            mbProgressView.fontColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.profileDetailsView.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.5098039216, blue: 0.5529411765, alpha: 1)
            self.emailLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.userEmailid.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.phoneNoLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.userContactNo.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.changePasswordLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.rewardsLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.rewardPoints.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.pointsLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
               self.percentageValue.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.lockImageView.image = UIImage(named: "Password")
            self.arrowImageView.image = #imageLiteral(resourceName: "ar_menu")
            mbProgressView.progressStrokeColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
             mbProgressView.fontColor = UIColor.clear
            self.changePassView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.bottomView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.rewardsView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.mainView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.btnMenu.setImage(UIImage(named: "menu"), for: .normal)
            
        }
    }
    
    
    //MARK: Localized
    func localizedString() {
        
        editBtn.setTitle("  "+"Edit".localizedString, for: .normal)
        navTitle.text = "My Profile".localizedString
        //platinumLbl.text = "  PLATINUM MEMBER  ".localizedString
        emailLbl.text = "E-mail".localizedString
        phoneNoLbl.text = "Phone No".localizedString
        // goldLeveLbl.text = "Gold Level".localizedString
        changePasswordLbl.text = "Change Password".localizedString
        rewardsLbl.text = "REWARDS".localizedString
        pointsLbl.text = "Points".localizedString
        logOutBtn.setTitle("LOGOUT".localizedString, for: .normal)
        
    }
    
    // MARK: -  Set Data
    func setData() {
        self.userName.text = LoginManagerApi.share.me?.fullName
        self.userEmailid.text = LoginManagerApi.share.me?.email
        
        
        let rewards = LoginManagerApi.share.me?.loyalityPoint
        let points: String = String(format: "%.2f", rewards ?? 0.0)
        print("points", points)
        self.rewardPoints.text = points
        
        let totalOrdersBooking: String = String(format: "%.0f", LoginManagerApi.share.me?.totalPoints ?? 0)
        
        let number = Int(totalOrdersBooking)
        
        print("total order booking num", number!)
        if number ?? 0 >= Int(0) && number ?? 0 <= Int(20) {
            print("total order booking num exist")
            platinumLbl.text = "  SILVER MEMBER  ".localizedString
            goldLeveLbl.text = "Silver Level".localizedString
        } else if number ?? 0 >= Int(21) && number ?? 0 <= Int(50) {
            platinumLbl.text = "  GOLD MEMBER  ".localizedString
            goldLeveLbl.text = "Gold Level".localizedString
        } else if number ?? 0 >= Int(51) {
            platinumLbl.text = "  PLATINUM MEMBER  ".localizedString
            goldLeveLbl.text = "Platinum Level".localizedString
        }
        
        
        if LoginManagerApi.share.me?.socialLogin == true {
            if LoginManagerApi.share.me?.mobile != nil {
                if let mobileno = LoginManagerApi.share.me?.mobile {
                    self.userContactNo.text = mobileno
                }
            } else {
                self.userContactNo.text = " "
                
                
                
            }
        } else {
            if LoginManagerApi.share.me?.mobile != nil {
                if let contactNumber = LoginManagerApi.share.me?.mobile {
                    let countryCode = LoginManagerApi.share.me?.diallingCode
            //                    self.userContactNo.text = countryCode.localized + "\(contactNumber)"
                    self.userContactNo.text = countryCode! + "\(contactNumber)"
                }
            } else {
                self.userContactNo.text = " "
            }
        }
        
        if LoginManagerApi.share.me?.socialLogin == true {
             changePassView.isHidden = true
         }
        
        
        if let imageUrl = LoginManagerApi.share.me?.imageUrl {
            userProfilepic.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholder"))
            self.userProfilepic.layer.cornerRadius = self.userProfilepic.frame.size.height/2
        }
    }
    
    // MARK: - UIActions
    @IBAction func actionMenu(_ sender: Any) {
        let language = Localize.currentLang()
        if language == .arabic {
            self.revealViewController().rightRevealToggle(animated: true)
            return
        }
        self.revealViewController().revealToggle(animated: true)
    }
    
    //MARK:- Change Password Action
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        
        if let viewcontroller = R.storyboard.main.resetPasswordController() {
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
    }
    // MARK: LogOut Action
    @IBAction func logout(_ sender: Any) {
        
    
        UIAlertController.presentAlert(title: nil, message: "Do you really want to logout?".localizedString, style: .actionSheet).action(title: "Logout".localizedString, style: .destructive, handler: { (actions: UIAlertAction) in
           
            UserDefaults.standard.set(false, forKey: "LoginStatus")
     
            LoginManagerApi.share.logout(callBack: { (object: Any?, error: Error?) in
                
            })
            
        }).action(title: "Cancel".localizedString, style: .cancel, handler: nil)
        
    }
}
