 //
 //  SideMenuController.swift
 //  CLApp
 //
 //  Created by cl-macmini-68 on 17/12/16.
 //  Copyright © 2016 Hardeep Singh. All rights reserved.
 //
 
 import UIKit
// import SDKDemo1
 //import MZFayeClient
// import Hippo
 
 class SideMenuController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var profileDeatilsView: UIView!
    
    
    @IBOutlet weak var lblName: UILabel! {
        didSet {
            lblName.font = AppFont.bold(size: 16)
        }
    }
    
    @IBOutlet weak var platinumMemLbl: UILabel! { didSet {
        platinumMemLbl.font = AppFont.bold(size: 12)
        }
    }
    
    
    @IBOutlet weak var pointsLbl: UILabel! {
        didSet {
            pointsLbl.font = AppFont.regular(size: 10)
        }
    }
    
    @IBOutlet weak var pointNumLbl: UILabel! {
        didSet {
            pointNumLbl.font = AppFont.bold(size: 12)
        }
    }
    
    @IBOutlet weak var gotLevelLbl: UILabel! {
        didSet {
            gotLevelLbl.font = AppFont.regular(size: 8)
        }
    }
    
    @IBOutlet weak var separatorLbl: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel! {
        didSet {
            lblEmail.font = AppFont.bold(size: 16)
        }
    }
    
    @IBOutlet var nightSwitch: UISwitch!
    
    @IBOutlet var nightModeView: UIView!
    
    @IBOutlet weak var switchToNightModeLbl: UILabel! {
        didSet {
            switchToNightModeLbl.font = AppFont.regular(size: 16)
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var settingOutlet: UIButton!
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            signUpBtn.titleLabel?.font = AppFont.bold(size: 18)
        }
    }
    
    // MARK: - Variables
    fileprivate var darkR: CGFloat = 172
    fileprivate var darkG: CGFloat = 21
    fileprivate var darkB: CGFloat = 74
    fileprivate var litR: CGFloat = 179
    fileprivate var litG: CGFloat = 20
    fileprivate var litB: CGFloat = 75
    fileprivate var chatIndex: Int = 6
    fileprivate var chatGuestIndex: Int = 1
    fileprivate var selectedIndex: Int = -1
    var menuItems: [MenuViewModel] = [MenuViewModel]()
    var guestMenuItems: [MenuViewModel] = [MenuViewModel]()
    
    let menuCell = SideMenuCell()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if !LoginManagerApi.share.isAccessTokenValid {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        profileDeatilsView.addGestureRecognizer(tap)
        }
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.registerCell("SideMenuCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.hideLastCellLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpSideMenu()
        openMenuController()
        self.accessTokenApi()
        tableView.reloadData()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.navigationBar.isHidden = false
        if let rootViewController = R.storyboard.main().instantiateInitialViewController() as? UINavigationController {
            if let vc = R.storyboard.main.signInController() {
                if !rootViewController.viewControllers.contains(vc) {
                    rootViewController.viewControllers.removeAll()
                    rootViewController.viewControllers.append(vc)
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                }
            }
        }
    }
    
    //MARK: SetUp SideMenu Data for Guest User and Loged in User
    func setUpSideMenu() {
        
        switchToNightModeLbl.text = "Switch to Night Mode".localizedString
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            nightSwitch.setOn(true, animated: false)
            nightSwitch.thumbTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nightSwitch.onTintColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            nightSwitch.tintColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            nightSwitch.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            nightModeView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            switchToNightModeLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            tableView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            
        } else {
            nightModeView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nightSwitch.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            switchToNightModeLbl.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            nightSwitch.onTintColor = UIColor.lightGray
            nightSwitch.tintColor = UIColor.lightGray
            nightSwitch.thumbTintColor = UIColor.darkGray
              nightSwitch.setOn(false, animated: false)
            
        }
        
        
        if !LoginManagerApi.share.isAccessTokenValid {
            self.lblEmail.text = ""
            self.lblName.text = ""
            self.platinumMemLbl.isHidden = true
            self.pointsLbl.text = ""
            self.pointNumLbl.text = ""
            self.gotLevelLbl.text = ""
            signUpBtn.isHidden = false
            signUpBtn.setTitle("SignIn/SignUp".localizedString, for: .normal)
        } else {
            self.platinumMemLbl.isHidden = false
          
            pointsLbl.text = "Points:".localizedString
            gotLevelLbl.text = "You Have Got The Heighest Level".localizedString
            signUpBtn.isHidden = true
            self.setData()
        }
    }
    
    //MARK: SignUp Button Action
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        navigationController?.navigationBar.isHidden = false
        if let rootViewController = R.storyboard.main().instantiateInitialViewController() as? UINavigationController {
            if let vc = R.storyboard.main.signInController() {
                if !rootViewController.viewControllers.contains(vc) {
                    rootViewController.viewControllers.removeAll()
                    rootViewController.viewControllers.append(vc)
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                }
            }
        }
    }
    
    //MARK: Open Chat View Controller
    func openChat() {
//        let manager = LoginManagerApi.share.me
//        let hippoUserDetail = HippoUserDetail(fullName: manager?.fullName ?? "", email: manager?.email ?? "", phoneNumber: manager?.mobile ?? "", userUniqueKey: manager?.id ?? "")
//        HippoConfig.shared.updateUserDetail(userDetail: hippoUserDetail)
//        HippoConfig.shared.presentChatsViewController()
    }
    
    // MARK: Set Data
    func setData() {
        self.imgProfile.clipsToBounds = true
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
        self.lblName.text = LoginManagerApi.share.me?.fullName
        self.lblEmail.text = LoginManagerApi.share.me?.email
        let points:String = String(format:"%.2f", LoginManagerApi.share.me?.loyalityPoint ?? 0.0)
        self.pointNumLbl.text = points
        
        
         let totalOrdersBooking:String = String(format:"%.0f", LoginManagerApi.share.me?.totalPoints ?? 0)
        
        
        let number = Int(totalOrdersBooking)
        
        if number ?? 0 >= Int(0) && number ?? 0 <= Int(20) {
         
            gotLevelLbl.isHidden = true
//            let gradient = CAGradientLayer(start: .center, end: .bottomRight, colors: [UIColor.black.cgColor, UIColor.white.cgColor], type: .radial)
//            gradient.frame = view.frame.size
            
             self.profileDeatilsView.setGradientBackground(colorOne: hexStringToUIColor(hex: "#d2d2d2"), colorTwo: hexStringToUIColor(hex: "#5d5d5d"))
            
           //self.profileDeatilsView.backgroundColor = hexStringToUIColor(hex: "#d2d2d2")
           // self.profileDeatilsView.bottomColor = hexStringToUIColor(hex: "#252642")
            
              platinumMemLbl.text = "  SILVER MEMBER  ".localizedString
        } else if number ?? 0 >= Int(21) && number ?? 0 <= Int(50) {
              platinumMemLbl.text = "  GOLD MEMBER  ".localizedString
              self.profileDeatilsView.setGradientBackground(colorOne: hexStringToUIColor(hex: "#e2c454"), colorTwo: hexStringToUIColor(hex: "#b47600"))
//             self.profileDeatilsView.backgroundColor = hexStringToUIColor(hex: "#e2c454")
              gotLevelLbl.isHidden = true
        } else if number ?? 0 >= Int(51) {
              platinumMemLbl.text = "  PLATINUM MEMBER  ".localizedString
              gotLevelLbl.isHidden = false
              self.profileDeatilsView.setGradientBackground(colorOne: hexStringToUIColor(hex: "#9396b5"), colorTwo: hexStringToUIColor(hex: "#252642"))
//             self.profileDeatilsView.backgroundColor = hexStringToUIColor(hex: "#d2d2d2")
        }
        
 
        if let imageUrl = LoginManagerApi.share.me?.imageUrl {
            imgProfile.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholder"))
        }
    }
    
    
//    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.locations = [0, 1]
//        gradientLayer.frame = bounds
//
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    //HEX COLOR CONVETER 
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func accessTokenApi() {
      var tokan = "iOSToken"
      if let deviceToken = UserDefaults.standard.value(forKey: "devicetoken") as? String {
        tokan = deviceToken
      }
      if LoginManagerApi.share.me?.accessToken != nil {
        var param: [String: Any] = [:]
        param["deviceToken"] = tokan
        param["deviceType"] = deviceType
        param["appVersion"] = "\(appVersionValue)"
        param["latitude"] = LocationTracker.shared.currentLocationLatitude
        param["longitude"] = LocationTracker.shared.currentLocationLongitude
        LoginManagerApi.share.accessToken(parameters: param) { (object: Any?, error: Error?) in
          if error != nil {
            return
          }
        }
      }
    }
    
    //MARK:- SWITCH TO NIGHT MODE ACTION
    @IBAction func switchToNightModeBtnAction(_ sender: UISwitch) {
        
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.post(name: notificationName, object: nil)

        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if isDarkMode == true {
            UserDefaults.standard.set(false, forKey: "isDarkMode")  // Set the state
        } else {
            
            UserDefaults.standard.set(true, forKey: "isDarkMode")  // Set the state
        }
        
        let storyboard = R.storyboard.home
        let sideMenuController = storyboard.sideMenuController()
        let homeViewController = storyboard.homeViewController()
        let menuNavController: UINavigationController = UINavigationController(rootViewController: sideMenuController!)
        
        // HomeController
        let homeNavController: UINavigationController = UINavigationController(rootViewController: homeViewController!)
        
         self.revealViewController().setFront(homeNavController, animated: true)
 
        let language = Localize.currentLang()
        if language == .english {
                        self.revealViewController().rightRevealToggle(animated: true)
                        return
                    }
        self.revealViewController().revealToggle(animated: true)
        
        self.selectedIndex = 0
        
//
//        let storyBoard = R.storyboard.home
//        guard let vc = storyBoard.homeViewController() else {
//            fatalError("Could not load Controller")
//        }
//        self.revealViewController().setFront(vc, animated: true)
//        let language = Localize.currentLang()
//        if language == .arabic {
//            self.revealViewController().rightRevealToggle(animated: true)
//            return
//        }
//        self.revealViewController().revealToggle(animated: true)
    
  
    }
    
  
    // MARK: Setting Button Clicked
    @IBAction func settingButtonClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.settingViewController) as? SettingViewController else {
            fatalError("Could not load Controller")
        }
        self.revealViewController().setFront(vc, animated: true)
        let language = Localize.currentLang()
        if language == .english {
            self.revealViewController().revealToggle(animated: true)
            return
        }
        self.revealViewController().revealToggle(animated: true)
    }
 }
 
 // MARK: - UITableViewDelegate
 extension SideMenuController: UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //      if indexPath.section == chatGuestIndex && !LoginManagerApi.share.isAccessTokenValid {
        //      // self.openChat()
        //        selectedIndex = indexPath.section
        //        self.tableView.reloadData()
        //        return
        //      }
        //
        //      if indexPath.section == chatIndex {
        //       self.openChat()
        //        selectedIndex = indexPath.section
        //        self.tableView.reloadData()
        //       return
        //      }
        
        if LoginManagerApi.share.isAccessTokenValid {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let item = self.menuItems[indexPath.section]
                let language = Localize.currentLang()
                if let controller = item.controller {
                    if controller == self.revealViewController().frontViewController {
                        if language == .english {
                            self.revealViewController().revealToggle(animated: true)
                            return
                        }
                        self.revealViewController().revealToggle(animated: true)
                        return
                    }
                    self.revealViewController().setFront(item.controller, animated: true)
                    if language == .english {
                        self.revealViewController().revealToggle(animated: true)
                        return
                    }
                    self.revealViewController().revealToggle(animated: true)
                    return
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let item = self.guestMenuItems[indexPath.section]
                let language = Localize.currentLang()
                if let controller = item.controller {
                    if controller == self.revealViewController().frontViewController {
                        if language == .english {
                            self.revealViewController().revealToggle(animated: true)
                            return
                        }
                        self.revealViewController().revealToggle(animated: true)
                        return
                    }
                    self.revealViewController().setFront(item.controller, animated: true)
                    if language == .english {
                        self.revealViewController().revealToggle(animated: true)
                        return
                    }
                    self.revealViewController().revealToggle(animated: true)
                    return
                }
            }
        }
        selectedIndex = indexPath.section
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
 }
 
 // MARK: - UITableViewDataSource
 extension SideMenuController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if LoginManagerApi.share.isAccessTokenValid {
            print("*******\(self.menuItems.count)")
            return self.menuItems.count
        }
        return self.guestMenuItems.count // Home, Chat Support, Info
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sideMenuCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as? SideMenuCell else {
            fatalError("SideMenuCell not loaded")
        }
        //        let darkColor = UIColor(red: darkR/255, green: darkG/255, blue: darkB/255, alpha: 1.0)
        //        let lightColor = UIColor(red: litR/255, green: litG/255, blue: litB/255, alpha: 1.0)
        //        let gradientLayer = CAGradientLayer()
        //        gradientLayer.frame = sideMenuCell.contentView.bounds
        //        gradientLayer.colors = [darkColor.cgColor, lightColor.cgColor]
        //        sideMenuCell.backGroundView.layer.addSublayer(gradientLayer)
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            sideMenuCell.backGroundView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            sideMenuCell.label.textColor = UIColor.white
            
        } else {
            
            sideMenuCell.backGroundView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sideMenuCell.label.textColor = UIColor.black
        }
        
      
        
        if indexPath.section == selectedIndex {
            
            // sideMenuCell.lblBar.isHidden = false
           
            sideMenuCell.label.font = UIFont(name: fontNameRegular, size: 20.0)
            // sideMenuCell.label.font = UIFont(name: fontNameMedium, size: 24.0)
        } else {
             
            //sideMenuCell.lblBar.isHidden = true
            sideMenuCell.label.font = UIFont(name: fontNameRegular, size: 20.0)
        }
        if LoginManagerApi.share.isAccessTokenValid {
            let item = self.menuItems[indexPath.section]
            sideMenuCell.update(menuViewModel: item)
        } else {
            let item = self.guestMenuItems[indexPath.section]
            sideMenuCell.update(menuViewModel: item)
        }
        return sideMenuCell
    }
 }
 
 
 extension SideMenuController {
    
    // MARK: - Root controller actions..
    
    func openMenuController() {
        //MARK: Side Menu for Guest use
        //Home Storyboard
        menuItems.removeAll()
        guestMenuItems.removeAll()
        if !LoginManagerApi.share.isAccessTokenValid {
            let storyboardGuest = R.storyboard.home
            let addressBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
            //SideMenuController
            guard let sideMenuControllerGuest = storyboardGuest.sideMenuController(),
                let homeViewControllerGuest = storyboardGuest.homeViewController() else {
                    fatalError("Couldn't instantiate view controller")
            }
            guard let setting = addressBoard.instantiateViewController(withIdentifier: Identifier.settingViewController) as? SettingViewController else {
                fatalError("Could not load Controller")
            }
            let menuNavController: UINavigationController = UINavigationController(rootViewController: sideMenuControllerGuest)
            var itemGuest = MenuViewModel()
            let homeNavControllerGuest: UINavigationController = UINavigationController(rootViewController: homeViewControllerGuest)
            if selectedIndex == 0 {
                itemGuest = MenuViewModel(title: "sideHome".localizedString, image: UIImage(named: "R_Home"), isSelected: true, controller: homeNavControllerGuest)
                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
            } else {
                itemGuest = MenuViewModel(title: "sideHome".localizedString, image: UIImage(named: "Home"), isSelected: true, controller: homeNavControllerGuest)
                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
            }
            
            //Chat
           /* let chatNavControllerGuest = UINavigationController(rootViewController: storyboardGuest.liveZillaChatVc() ?? UIViewController())
            if selectedIndex == 1 {
                itemGuest = MenuViewModel(title: "ChatSupport".localizedString, image: UIImage(named: "R_ChatSupport"), isSelected: false, controller: chatNavControllerGuest)
                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
            } else {
                itemGuest = MenuViewModel(title: "ChatSupport".localizedString, image: UIImage(named: "ChatSupport"), isSelected: false, controller: chatNavControllerGuest)
                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
            }*/
            
//            // Info
//            let infoNavControllerGuest = UINavigationController(rootViewController: storyboardGuest.infoController() ?? UIViewController())
//            if selectedIndex == 2{
//                itemGuest = MenuViewModel(title: "Info".localizedString, image: UIImage(named: "R_MyOrders"), isSelected: false, controller: infoNavControllerGuest)
//                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
//            }else{
//                itemGuest = MenuViewModel(title: "Info".localizedString, image: UIImage(named: "MyOrders"), isSelected: false, controller: infoNavControllerGuest)
//                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
//            }
           
            
            //Setting
            
            /*let settingNavController = UINavigationController(rootViewController: setting)
            settingNavController.navigationBar.isHidden = true
            if selectedIndex == 3 {
                itemGuest = MenuViewModel(title: "Setting".localizedString, image: UIImage(named: "R_settings"), isSelected: false, controller: settingNavController)
                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
            } else {
                itemGuest = MenuViewModel(title: "Setting".localizedString, image: UIImage(named: "settings"), isSelected: false, controller: settingNavController)
                sideMenuControllerGuest.guestMenuItems.append(itemGuest)
            }*/
            
           
            
            //            let settingNavControllerGuest = UINavigationController(rootViewController: storyboardGuest.SettingViewController() ?? UIViewController())
            //            itemGuest = MenuViewModel(title: "setting".localizedString, image: UIImage(named: "setting.png"), isSelected: false, controller: settingNavControllerGuest)
            //            sideMenuControllerGuest.guestMenuItems.append(itemGuest)
            
            
            
            
            let reavealViewControllerGuest: SWRevealViewController! = SWRevealViewController(rearViewController: menuNavController, frontViewController: homeNavControllerGuest)
            let language = Localize.currentLang()
            if language == .arabic {
                reavealViewControllerGuest.setRight(sideMenuControllerGuest, animated: true)
            }
            reavealViewControllerGuest?.view.backgroundColor = UIColor.white
            navigationController?.navigationBar.isHidden = true
            guestMenuItems = sideMenuControllerGuest.guestMenuItems
            tableView.reloadData()
            return
        }
        //me Storyboard
        let storyboard = R.storyboard.home
        let addressStoryBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
        let orderStoryBoard = UIStoryboard(name: Identifier.orderStoryBoard, bundle: nil)
        
        //SideMenuController
        guard let sideMenuController = storyboard.sideMenuController(),
            let homeViewController = storyboard.homeViewController(),
            let profileController = storyboard.myProfileController(), let referVC = storyboard.referController() else {
                fatalError("Couldn't instantiate view controller")
        }
        guard let myOrder = orderStoryBoard.instantiateViewController(withIdentifier: Identifier.myOrderController) as? MyOrderController else {
            fatalError("Could not load Controller")
        }
        
        guard let myAddress = addressStoryBoard.instantiateViewController(withIdentifier: Identifier.myAddressController) as? MyAddressController else {
            fatalError("Could not load Controller")
        }
        guard let setting = addressStoryBoard.instantiateViewController(withIdentifier: Identifier.settingViewController) as? SettingViewController else {
            fatalError("Could not load Controller")
        }
        
        let menuNavController: UINavigationController = UINavigationController(rootViewController: sideMenuController)
        
        // HomeController
        let homeNavController: UINavigationController = UINavigationController(rootViewController: homeViewController)
        print("home \(homeNavController.viewControllers)")
        var item = MenuViewModel()
//            var item = MenuViewModel(title: "Home".localizedString, image: UIImage(named: "Home"), isSelected: true, controller: homeNavController)
        if selectedIndex == 0 {
            item = MenuViewModel(title: "Home".localizedString, image: UIImage(named: "R_Home"), isSelected: true, controller: homeNavController)
        } else {
             item = MenuViewModel(title: "Home".localizedString, image: UIImage(named: "Home"), isSelected: true, controller: homeNavController)
        }
            sideMenuController.menuItems.append(item)
        
      
        
        // MyProfile
        let profileNavController = UINavigationController(rootViewController: profileController)
        profileNavController.navigationBar.isHidden = true
       
        if selectedIndex == 1 {
            item = MenuViewModel(title: "MyProfile".localizedString, image: UIImage(named: "R_My-Profile"), isSelected: false, controller: profileNavController)
            sideMenuController.menuItems.append(item)
        } else {
             item = MenuViewModel(title: "MyProfile".localizedString, image: UIImage(named: "My-Profile"), isSelected: false, controller: profileNavController)
            sideMenuController.menuItems.append(item)
        }
        print(item)
        // MyAddress
        let addressNavController = UINavigationController(rootViewController: myAddress )
        if selectedIndex == 2 {
        item = MenuViewModel(title: "MyAddress".localizedString, image:UIImage.init(named: "R_My-Addresses"), isSelected: false, controller: addressNavController)
        sideMenuController.menuItems.append(item)
        } else {
            item = MenuViewModel(title: "MyAddress".localizedString, image: UIImage.init(named: "My-Addresses"), isSelected: false, controller: addressNavController)
            sideMenuController.menuItems.append(item)
        }
        print(item)
        // MyOrder
        let orderNavController = UINavigationController(rootViewController: myOrder)
        if selectedIndex == 3 {
        item = MenuViewModel(title: "MyOrders".localizedString, image: UIImage(named: "R_MyOrders"), isSelected: false, controller: orderNavController)
        sideMenuController.menuItems.append(item)
        } else {
            item = MenuViewModel(title: "MyOrders".localizedString, image: UIImage(named: "MyOrders"), isSelected: false, controller: orderNavController)
            sideMenuController.menuItems.append(item)
        }
        print(item)
        // Refer a friend
        let referNavController = UINavigationController(rootViewController: referVC)
        if selectedIndex == 4 {
        item = MenuViewModel(title: "Referafriend".localizedString, image: UIImage(named: "R_ReferaFriend"), isSelected: false, controller: referNavController)
        sideMenuController.menuItems.append(item)
        } else {
            item = MenuViewModel(title: "Referafriend".localizedString, image: UIImage(named: "ReferaFriend"), isSelected: false, controller: referNavController)
            sideMenuController.menuItems.append(item)
        }
        print(item)
        // Promotion
        let promotionsNavController = UINavigationController(rootViewController: storyboard.promotionsController() ?? UIViewController())
        if selectedIndex == 5 {
        item = MenuViewModel(title: "Promotions".localizedString, image: UIImage(named: "R_Promotions"), isSelected: false, controller: promotionsNavController)
        sideMenuController.menuItems.append(item)
        } else {
            item = MenuViewModel(title: "Promotions".localizedString, image: UIImage(named: "Promotions"), isSelected: false, controller: promotionsNavController)
            sideMenuController.menuItems.append(item)
        }
        print(item)
        // Chat
        /*let chatNavController = UINavigationController(rootViewController: storyboard.liveZillaChatVc() ?? UIViewController())
        if selectedIndex == 6 {
        item = MenuViewModel(title: "ChatSupport".localizedString, image: UIImage(named: "R_ChatSupport"), isSelected: false, controller: chatNavController)
        sideMenuController.menuItems.append(item)
        } else {
            item = MenuViewModel(title: "ChatSupport".localizedString, image: UIImage(named: "ChatSupport"), isSelected: false, controller: chatNavController)
            sideMenuController.menuItems.append(item)
        }
        print(item)*/
        
        // Info
        //        let infoNavController = UINavigationController(rootViewController: storyboard.infoController() ?? UIViewController())
        //        item = MenuViewModel(title: "Info".localizedString, image: UIImage(named: "MyOrder.png"), isSelected: false, controller: infoNavController)
        //        sideMenuController.menuItems.append(item)
        
        //Setting
        let settingNavController = UINavigationController(rootViewController: setting)
        settingNavController.navigationBar.isHidden = true
        if selectedIndex == 7 {
        item = MenuViewModel(title: "Wallet and Others".localizedString, image: UIImage(named: "R_settings"), isSelected: false, controller: settingNavController)
        sideMenuController.menuItems.append(item)
        } else {
            item = MenuViewModel(title: "Wallet and Others".localizedString, image: UIImage(named: "settings"), isSelected: false, controller: settingNavController)
            sideMenuController.menuItems.append(item)
        }
        print ("home \(homeNavController.viewControllers) menu \(menuNavController.viewControllers)")
        let reavealViewController: SWRevealViewController! = SWRevealViewController(rearViewController: menuNavController, frontViewController: homeNavController)
        let language = Localize.currentLang()
        if language == .english {
            reavealViewController.setRight(sideMenuController, animated: true)
        }
        reavealViewController?.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        menuItems = sideMenuController.menuItems
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
 }
