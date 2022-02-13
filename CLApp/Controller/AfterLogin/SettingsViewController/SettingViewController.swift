  //
  //  SettingViewController.swift
  //  FoodFox
  //
  //  Created by Nishant Raj on 03/12/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

  import UIKit
  import MessageUI


  class SettingViewController: UIViewController, NotificationChange, MFMailComposeViewControllerDelegate {

      //MARK: Variables
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
           titleLabel.font = AppFont.semiBold(size: 18)
        }
    }
      @IBOutlet weak var tableView: UITableView!
      @IBOutlet weak var topViews: UIView!
      @IBOutlet weak var backBtn: UIButton!
    
    //MARK: Variables
    var notification: NotificationModel?
    
    //MARK: View Did load
      override func viewDidLoad() {
         super.viewDidLoad()
            setUpTable()
            changeConstraint(controller: self, view: topViews)
            getData()
      }
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    //MARK:- CHECK STATUS OF DARK MODE
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            topViews.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            
            backBtn.setImage(UIImage(named: "menu-1"), for: .normal)
           
            tableView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            topViews.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             backBtn.setImage(UIImage(named: "menu"), for: .normal)
            tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.titleLabel.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            
        }
        
    }
    
    
    //MARK: Get Setting Data
    func getData() {
        if LoginManagerApi.share.isAccessTokenValid {
            self.getSettingData()
        }
    }
    //MARK: Server Call To get Setting Data
    func getSettingData() {
        NotificationModel.getSettingData(callBack: { (data: NotificationModel?, error: Error?) in
            if error == nil {
                if let data = data {
                    self.notification = data
                     LoginManagerApi.share.me?.walletAmount = self.notification?.walletAmount ?? 0.0
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    //MARK: Delegate to change notification Setting
    func changeNotification(type: Bool) {
        NotificationModel.updateNotificationSetting(isNotification: type, callBack: {(data: [String: Any]?, error: Error?) in
            if error == nil {
                print("Updated Successfully")
            }

        })
    }
    
    //MARK: Set Up Table
    func setUpTable() {
      titleLabel.text = "Settings".localizedString
      tableView.delegate = self
      tableView.dataSource = self
      tableView.registerCell(Identifier.settingTableViewCell)
      tableView.rowHeight = 60
      tableView.reloadData()
     }
    
    //MARK: Back Button Action
      @IBAction func backButtonClicked(_ sender: UIButton) {
        let language = Localize.currentLang()
        if language == .english {
            self.revealViewController().revealToggle(animated: true)
          return
        }
        self.revealViewController().revealToggle(animated: true)
      }
    
    //MARK: Push to add in Card
      func pushToPaymentController() {
       let storyBoard = UIStoryboard(name: Identifier.paymentStoryBoard, bundle: nil)
              guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.addCardViewController) as? AddCardViewController else {
              fatalError("Could not load Controller")
              }
              self.navigationController?.pushViewController(vc, animated: true)
      }
    
    //MARK: Email send
    func sendEmail() {
        let email = "support@foodfox.in"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    //MARK: Push to Wallet
    func pushToWallet() {
      guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.walletController) as? MyWalletViewController else {
        fatalError("Could not load Controller")
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Push TO Laguage Selection
    func pushToLanguage() {
      let selectLang = SelectLanguageController(nibName: Identifier.selectLanguage, bundle: nil)
      selectLang.yesCancelCallback = {
        if let rootViewController = R.storyboard.main().instantiateInitialViewController() as? UINavigationController {
          if let vc = R.storyboard.main.chooseDeliveryController() {
            if !rootViewController.viewControllers.contains(vc) {
              rootViewController.viewControllers.removeAll()
              rootViewController.viewControllers.append(vc)
              UIApplication.shared.keyWindow?.rootViewController = rootViewController
            }
          }
        }
      }
      selectLang.modalPresentationStyle = .overCurrentContext
      selectLang.modalTransitionStyle = .crossDissolve
      self.present(selectLang, animated: true, completion: nil)
    }
  }

  //MARK: TableView Delegate and Data Source
  extension SettingViewController: UITableViewDataSource, UITableViewDelegate {

      func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !LoginManagerApi.share.isAccessTokenValid {
          return SettingGuest.count
        } else {
          return Setting.count
        }
      }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.settingTableViewCell) as? SettingTableViewCell else {
              fatalError("Could not load nib AddressListCell")
          }
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
             cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
             cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
             cell.name.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.name.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            
        }
        if !LoginManagerApi.share.isAccessTokenValid {
          if let sectionType = SettingGuest(rawValue: indexPath.row) {
            cell.name.text = sectionType.name.localizedString
            cell.settingImage.image = sectionType.image
            cell.walletPriceLabel.isHidden = true
            cell.switchOutlet.isHidden = true
            cell.delegate = self
            return cell
          }
        }
        
          if let sectionType = Setting(rawValue: indexPath.row) {
              cell.name.text = sectionType.name.localizedString
              cell.settingImage.image = sectionType.image
              cell.walletPriceLabel.isHidden = true
              cell.switchOutlet.isHidden = true
              cell.delegate = self
              if sectionType == .notification {
              cell.switchOutlet.isHidden = false
              cell.switchOutlet.isOn = notification?.isNotification ?? true
              }
              if sectionType == .wallet {
                cell.walletPriceLabel.isHidden = false
                let sar = "Rs.".localizedString
                let walletAmt = (LoginManagerApi.share.me?.walletAmount ?? 0.0)
                cell.walletPriceLabel.text = "\(sar) \(walletAmt.roundTo2Decimal())"
              }
          }
         return cell
      }
    
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if !LoginManagerApi.share.isAccessTokenValid {
          if let sectionType = SettingGuest(rawValue: indexPath.row) {
            switch sectionType {
            case .language:
              self.pushToLanguage()
            case .contactus:
                self.sendEmail()
            }
          }
         return
        }
          guard let sectionType = Setting(rawValue: indexPath.row) else {
            return
          }
          switch sectionType {
          //case .language:
//           self.pushToLanguage()
          case .wallet:
            print("other option")
            //self.pushToWallet()
          case .contactus:
            self.sendEmail()
          default:
            print("other option")
          }
      }
  }


  // Enum for Setting
  enum SettingGuest: Int, CaseCountable {
    case language
    case contactus
    var name: String {
      switch self {
      case .language:
        return "Select Language"
      case .contactus:
        return "Contact us"
      }
    }
    var image: UIImage {
      switch self {
      case .language:
        return #imageLiteral(resourceName: "langauge")
      case .contactus:
        return #imageLiteral(resourceName: "ic_mail")
      }
    }
  }



  // Enum for Setting
  enum Setting: Int, CaseCountable {
//    case payment = 0
    case wallet
    case notification
   // case language
    case contactus
      var name: String {
          switch self {
//          case .payment:
//              return "Payment"
          case .wallet:
              return "Wallet"
          case .notification:
              return "Notifications"
         // case .language:
             // return "Select Language"
          case .contactus:
            return "Contact us"
          }
      }
      var image: UIImage {
          switch self {
//          case .payment:
//              return #imageLiteral(resourceName: "paymentImage")
          case .wallet:
              return #imageLiteral(resourceName: "walletImage")
          case .notification:
              return #imageLiteral(resourceName: "notificationImage")
         // case .language:
             // return #imageLiteral(resourceName: "langauge")
          case .contactus:
            return #imageLiteral(resourceName: "ic_mail")
          }
      }
  }
