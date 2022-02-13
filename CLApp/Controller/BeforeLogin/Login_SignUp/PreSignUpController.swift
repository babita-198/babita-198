
//
//  PreSignUpController.swift
//  FoodFox
//
//  Created by Ritu Grodia on 17/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//
import UIKit
import FBSDKLoginKit
//import FBSDKShareKit

struct Social {
    let firstName: String
    let lastName: String
    let email: String
    let socialMode: SocialMode
    let socialId: String
    let socialpicture: String?
    let isTwitter: Bool
}

class PreSignUpController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnSignIn: UIButton! {
        didSet {
            btnSignIn.titleLabel?.font = AppFont.bold(size: 14)
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblOr: UILabel! {
        didSet {
            lblOr.font = AppFont.regular(size: 13)
        }
    }
    
    @IBOutlet weak var btnTitle: UILabel! {
        didSet {
            btnTitle.font = AppFont.regular(size: 16)
        }
    }
    @IBOutlet weak var lblSignUp: UILabel! {
        didSet {
            lblSignUp.font = AppFont.bold(size: 18)
        }
    }
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwitter: CLButton!
    @IBOutlet weak var btnGoogle: CLButton!
    @IBOutlet weak var lblOrSub: UILabel!
    @IBOutlet weak var btnSignUp: UIButton! {
        didSet {
            btnSignUp.titleLabel?.font = AppFont.regular(size: 14)
        }
    }
    
    // MARK: - Varaibles
    fileprivate var isSignUpViaSocial: Bool = false
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultSettings()
      localizedString()
    }
    
    //MARK:- Methods
    func defaultSettings() {
        self.navigationController?.navigationBar.isHidden = true
        self.lblOrSub.layer.cornerRadius = self.lblOrSub.frame.size.height/2
        self.lblOrSub.text = "Or".localizedString
        //GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().uiDelegate = self
    }

  
  //MARK: Localized String File
  func localizedString() {
    btnSignIn.setTitle("SIGN IN".localizedString, for: .normal)
    lblOr.text = "or".localizedString
    btnTitle.text = "Already have an account?".localizedString
    lblSignUp.text = "Sign up".localizedString
    //btnFacebook.setTitle("  " + "Facebook".localizedString, for: .normal)
    //btnTwitter.setTitle("  " + "Twitter".localizedString, for: .normal)
    //btnGoogle.setTitle("  " + "Google".localizedString, for: .normal)
    btnSignUp.setTitle("Email ID/ Phone Number".localizedString, for: .normal)
  }
  
    //MARK:- UIACtions
    @IBAction func actionCancel(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func actionFacebook(_ sender: Any) {
        FacebookManager.share.getUserProfile(from: self) { (error: Error?, fbData: Any?) in
            var emailId = ""
            guard let fbResult = fbData as? [String: Any], let firstName = fbResult["first_name"] as? String, let lastName = fbResult["last_name"] as? String, let id = fbResult["id"]
                as? String else {
                    return
            }
            if let email = fbResult["email"] as? String {
                emailId = email
            }
            var image = ""
            if let picture = fbResult["picture"] as? [String: Any], let data = picture["data"] as? [String: Any], let imgStr = data["url"] as? String {
                image = imgStr
                
                
            }
            let social = Social(firstName: firstName, lastName: lastName, email: emailId, socialMode: .facebook, socialId: id, socialpicture: image, isTwitter: false)
            self.signViaSocial(social: social)
            
        }
    }
    
    @IBAction func actionGoogle(_ sender: Any) {
        //GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func actionSignUp(_ sender: Any) {
    }
    
    func signViaSocial(social: Social) {
      
      var tokan = "iOSToken"
      if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
        tokan = deviceToken
      }
      
        var emailId = ""
        var param: [String: Any] = [:]
        if social.isTwitter == false {
            if social.email.length != 0 {
                emailId = social.email
                param["email"] = emailId
            }
        }
        param["socialId"] = social.socialId
        param["deviceType"] = deviceType
        param["deviceToken"] = tokan
        param["appVersion"] = appDelegate.appVersion
        param["socialMode"] = social.socialMode.rawValue
        param["flushPreviousSessions"] = true
        param["latitude"] = LocationTracker.shared.currentLocationLatitude
        param["longitude"] = LocationTracker.shared.currentLocationLongitude
        
        print(" param is....\(param)")
        LoginManagerApi.share.socialLogin(parameter: param) { (object: Any?, error: Error?) in
            self.isSignUpViaSocial = true
            print(object as Any)
            guard let me = LoginManagerApi.share.me else {
                return
            }
            print("is Social \(me.isSocial)")
            if me.isSocial == false {
                if let viewController = R.storyboard.main.signUpController() {
                    viewController.signUpViaSocial = self.isSignUpViaSocial
                    viewController.firstName = social.firstName
                    if let pic = social.socialpicture {
                        viewController.profilepic = pic
                    }
                    viewController.socialId = social.socialId
                    viewController.socialMode = social.socialMode.rawValue
                    if social.isTwitter == false {
                        viewController.lastName = social.lastName
                    }
                    if social.email.isEmpty == false {
                        emailId = social.email
                        viewController.email = emailId
                    }
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            
        }
    }
}
// MARK: - GoogleSignIn Integration
//extension PreSignUpController: GIDSignInDelegate, GIDSignInUIDelegate {
//    func sign(_ signIn: GIDSignIn!,
//              present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//    func sign(_ signIn: GIDSignIn!,
//              dismiss viewController: UIViewController!) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error == nil {
//            let name = user.profile.name.components(separatedBy: " ")
//            var lastName = ""
//            let firstName = name[0]
//            if name.count > 1 {
//                lastName = name[1]
//            }
//            var image = ""
//            if user.profile.hasImage {
//                let dimension = UInt(round(100 * UIScreen.main.scale))
//                image = user.profile.imageURL(withDimension: dimension).absoluteString
//            }
//
//            let socialData = Social(firstName: firstName, lastName: lastName, email: user.profile.email, socialMode: .googleplus, socialId: user.authentication.idToken, socialpicture: image, isTwitter: false)
//            self.signViaSocial(social: socialData)
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        print("error \(error.localizedDescription)")
//    }
//}
