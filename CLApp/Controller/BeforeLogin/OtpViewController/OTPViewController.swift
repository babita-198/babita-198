
import UIKit

class OTPViewController: UIViewController {
    
    // MARK: - Variables
    fileprivate var otpText = ""
    fileprivate var validatorManager = CLValidatorManager()
    
    // MARK: - IBOutlet
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var detailLabel: UILabel! {
        didSet {
          detailLabel.font = AppFont.regular(size: 17)
        }
    }
    @IBOutlet weak var resendButton: UIButton! {
        didSet {
            detailLabel.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var otpView: OTPView!
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            detailLabel.font = AppFont.semiBold(size: 16)
        }
    }
    @IBOutlet weak var submit: CLButton! {
        didSet {
            detailLabel.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var backButtonOutlet: UIButton!
      @IBOutlet weak var backGroundImage: UIImageView!
    var isFromSignUp = false

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDetailLabel()
        otpView.backgroundColor = .clear
        otpView.completionBlock { (text: String) in
            self.otpText = text
            print("---> ", text)
            self.makeRequest(otp: text)
        }
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        let language = Localize.currentLang()
        if language == .english {
            self.navigationView.semanticContentAttribute = .forceLeftToRight
        } else {
            self.navigationView.semanticContentAttribute = .forceLeftToRight
        }
      resendButton.setTitle("RESEND OTP".localizedString, for: .normal)
      navTitle.text = "OTP Verification".localizedString
      submit.setTitle("SUBMIT".localizedString, for: .normal)
      backButtonOutlet.changeBackBlackButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.navigationView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0, blue: 0.2352941176, alpha: 1)
            self.backGroundImage.backgroundColor = lightBlackColor
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.backButtonOutlet.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
            self.detailLabel.textColor = .white
        } else {
            self.navigationView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            self.backGroundImage.backgroundColor = .white
            
            self.navTitle.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.backButtonOutlet.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
            self.detailLabel.textColor = lightBlackColor
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        otpView.showKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let language = Localize.currentLang()
        if language == .english {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
  
  //MARK: Update UI Details
    func updateDetailLabel() {
        let diallingCode = LoginManagerApi.share.me?.diallingCode ?? ""
        let phoneNumber = LoginManagerApi.share.me?.mobile ?? ""
        let mobil = "\(diallingCode)-\(phoneNumber)"
        let vefiry = "Enter the verification code".localizedString
        let send = "sent to".localizedString
        let sms = "via sms.".localizedString
        let attributedString = NSMutableAttributedString(string: "\(vefiry) \n\(send) \(mobil) \(sms)")
      guard let font = UIFont(name: fontNameMedium, size: 17.0) else {
        return
      }
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 10, length: 17))
        detailLabel.attributedText = attributedString
    }
  
    // MARK: - UIActions
    @IBAction func actionBack(_ sender: Any) {
 
      guard let viewControllers = self.navigationController?.viewControllers else {
        return
      }
      
      for controller in viewControllers {
        if controller.isKind(of: ViewCartController.self) {
          self.navigationController?.popToViewController(controller, animated: true)
          return
        }
      }
      
//      for controller in viewControllers {
//        if controller.isKind(of: SignInController.self) {
//          self.navigationController?.popToViewController(controller, animated: true)
//          return
//        }
//      }
        
        if let rootViewController = R.storyboard.main().instantiateInitialViewController() as? UINavigationController {
            if let vc = R.storyboard.main.chooseDeliveryController() {
                if !rootViewController.viewControllers.contains(vc) {
                    rootViewController.viewControllers.removeAll()
                    rootViewController.viewControllers.append(vc)
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                }
            }
        }
//        _ = self.navigationController?.popViewController(animated: true)
    }
  
  // MARK: - Resend OTP
    @IBAction func resendButtonClicked(_ sender: Any) {
        LoginManagerApi.share.resendOTP { (object: Any?, error: Error?) in
            if error != nil {
                return
            }
            if let response = object as? [String: Any] {
              print(response)
                if let msg = response["message"] as? String {
                    UIAlertController.presentAlert(title: nil, message: msg, style: UIAlertController.Style.alert).action(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
                    })
                }
            }
        }
    }
  
  //MARK: Action to verify OTP
    @IBAction func actionSubmit(_ sender: Any) {
        if otpText.length == 0 {
            var message = ""
            let language = Localize.currentLang()
            switch language {
            case .english:
                message = "Please Enter OTP"
            case .english:
                message = "Please Enter OTP"
            default:
                break
            }
            UIAlertController.presentAlert(title: nil, message: message, style: UIAlertController.Style.alert).action(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            })
            return
        }
        if otpText.length < 4 {
            UIAlertController.presentAlert(title: nil, message: "ErrorCorrectCode".localized, style: UIAlertController.Style.alert).action(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            })
        } else {
            makeRequest(otp: self.otpText)
        }
    }
  
    // MARK: - Api for verify Mobile Number
    private func makeRequest(otp: String) {
        LoginManagerApi.share.verifyMobileNumber(otp: otp) { (resepons: Any?, error: Error?) in
            
            if error != nil {
                return
            }
            print("response \(String(describing: resepons))")
          if let response = resepons as? [String: Any], let dataValue = response["data"] as? [String: Any] {
              guard let data = dataValue["userDetails"] as? [String: Any] else {
                return
              }
                let value = data["IsVerified"] as? Bool
                if value == true {
                    let viewControllers = self.navigationController?.viewControllers
                    if viewControllers?.first is ChooseDeliveryController {
                    }
                  self.navigationController?.popToRootViewController(animated: true)
//     NotificationCenter.default.post(name: Notification.Name.RootControllerState.openMenu, object: nil)
                } else {
                    return
                }
            }
        }
    }
}
