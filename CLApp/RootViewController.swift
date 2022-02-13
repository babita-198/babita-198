
//
//  RootViewController.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

extension Notification.Name {
  /// Used as a namespace for all `RootViewController` related notifications.
  struct RootControllerState {
    static let openMenu = Notification.Name(rawValue: "clicklabs.RootControllerState.opneMenuController")
//    static let openMenu = Notification.Name(rawValue: "clicklabs.RootControllerState.opneMenuController")
  }
    
    struct RedirectToMainScreen {
        static let redirectToMainScreen = Notification.Name(rawValue: "RedirectToMainScreen")
        //    static let openMenu = Notification.Name(rawValue: "clicklabs.RootControllerState.opneMenuController")
    }
    struct OtpControllerState {
        static let moveToOtp = Notification.Name(rawValue: "clicklabs.OtpControllerState.moveToOtpVC")
        //    static let openMenu = Notification.Name(rawValue: "clicklabs.RootControllerState.opneMenuController")
    }
}

class RootViewController: UIViewController {
  
  @IBOutlet weak var logoImageView: UIImageView!
  
  @IBOutlet weak var flageImageView: UIImageView!
  @IBOutlet weak var diallingCodeLabel: UILabel!
  @IBOutlet weak var diallingCodeButton: CLButton!
  
  @IBOutlet var loginButton: CLButton!
  @IBOutlet var signupButton: CLButton!
    
  var window: UIWindow?
    
  // MARK: -
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //How use custom button
    // simple way to add targets...
    loginButton.setTitle(R.string.localizable.login(), for: .normal)
    loginButton.titleLabel?.font = AppFont.regular(size: 16)
    loginButton.addAction {[weak self] (button: CLButton) in
      
      if let loginViewController = R.storyboard.main.loginViewController() {
        self?.navigationController?.pushViewController(loginViewController, animated: true)
      }
      
    }
    
    //signup Button
    signupButton.setTitle(R.string.localizable.signUp(), for: .normal)
    signupButton.titleLabel?.font = AppFont.regular(size: 16)
    signupButton.addAction {[weak self] (button: CLButton) in
      if let signupViewController = R.storyboard.main.signupViewController() {
        self?.navigationController?.pushViewController(signupViewController, animated: true)
      }
    }
    
    //Dialling code button
    diallingCodeButton.titleLabel?.font = AppFont.regular(size: 14)
    diallingCodeButton.addAction { (button: CLButton) in
      self.diallingCodeButtonClicked()
    }
    
    //Country picker controller
    let country = CountryManager.currentCountry
    diallingCodeLabel.text = country?.dialingCode()
    flageImageView.image = country?.flag
    
    //--- Register Notifications...
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(RootViewController.userDidLogout), name: Notification.Name.LoginManagerStatus.logout, object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(openMenuController), name: Notification.Name.RootControllerState.openMenu, object: nil)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if LoginManagerApi.share.isAccessTokenValid {
      openMenuController()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
  }
  
  // MARK: - HOW USE Country Picker Country
  func diallingCodeButtonClicked() {
    
    let controller = CLCountryPickerController.presentController(on: self) { (country: Country) in
      self.diallingCodeLabel.text = country.dialingCode()
      self.flageImageView.image = country.flag
    }
    
    controller.tintColor = AppColor.themePrimaryColor
    
    controller.isHideFlagImage = false
    controller.isHideDiallingCode = false
    
    controller.separatorLineColor = UIColor.lightGray.withAlphaComponent(0.5)
    
    controller.labelColor = AppColor.themePrimaryColor
    controller.labelFont = AppFont.regular(size: 16)
    
    //controller.labelFont = AppFont.regular(size: 11)
    controller.detailColor = AppColor.themeSecondaryColor
    
  }
  
  private func profileVerify() -> Bool {
    if LoginManagerApi.share.me?.isVerified == false {
      if let viewController = R.storyboard.main.oTPViewController() {
        self.navigationController?.pushViewController(viewController, animated: true)
      }
      return false
    }
    return true
  }
  
  // MARK: - Root controller actions..
  @objc func openMenuController() {
    if profileVerify() == false {
      return
    }
    
    //Home Storyboard
    let storyboard = R.storyboard.home
    
    //SideMenuController
    guard let sideMenuController = storyboard.sideMenuController(),
      let homeViewController = storyboard.homeViewController(),
      let helpCenterViewController =  storyboard.helpCenterViewController() else {
        fatalError("Couldn't instantiate view controller")
    }
    
    let menuNavController: UINavigationController = UINavigationController(rootViewController: sideMenuController)
    
    // HomeController
    let homeNavController: UINavigationController = UINavigationController(rootViewController: homeViewController)
    var item = MenuViewModel(title: R.string.localizable.home(), image: R.image.cLLogo(), isSelected: true, controller: homeNavController)
    sideMenuController.menuItems.append(item)
    
    // HomeController
    let helpNavController = UINavigationController(rootViewController: helpCenterViewController)
    item = MenuViewModel(title: R.string.localizable.help(), image: R.image.cLLogo(), isSelected: false, controller: helpNavController)
    sideMenuController.menuItems.append(item)
    
//    item = MenuViewModel(title: R.string.localizable.logout(), image: R.image.cLLogo(), isSelected: false,controller: nil)
    sideMenuController.menuItems.append(item)
    
    let reavealViewController: SWRevealViewController! = SWRevealViewController(rearViewController: menuNavController, frontViewController: homeNavController)
    reavealViewController?.view.backgroundColor = UIColor.white
    navigationController?.navigationBar.isHidden = true
    
    _ = navigationController?.popToRootViewController(animated: false)
    navigationController?.pushViewController(reavealViewController, animated: false)
    
  }
  
  //Observer...
  @objc func userDidLogout() {
    navigationController?.navigationBar.isHidden = false
    self.setRootControllerWithIndetifier(identifier: "LaunchLogin")
    
    _ = navigationController?.popToRootViewController(animated: true)
  }
    
    func setRootControllerWithIndetifier(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("\(identifier)")
        if let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? UINavigationController {
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
//        UserDefaults.standard.set("1", forKey: UserDefaultsKey.isFirstTimeLaunch)
    }
  //TODO: MenuBarController
//  func openTabbarController() {
//    
//    self.navigationController?.isNavigationBarHidden = true
//    let homeViewController = R.storyboard.home.homeViewController()
//    let image = R.image.tickMark()
//    let selected = R.image.cLLogoWithText()
//    let item1 = ItemContent<CustomMenuItem>(title: "Home", image: image!, selectedImg: selected!)
//    let homeNavController = UINavigationController(rootViewController: homeViewController!)
//    homeNavController.barMenuItem = MenuBarItem(item: item1)
//    
//    let helpCenterViewController =  R.storyboard.home.helpCenterViewController()
//    
//    let item2 = ItemContent<CustomMenuItem>(title: "Help", image: R.image.tickMark(), selectedImg: R.image.cLLogoWithText())
//    let helpNavController = UINavigationController(rootViewController: helpCenterViewController!)
//    helpNavController.barMenuItem = MenuBarItem(item: item2)
//    let menuBarController =  R.storyboard.home.menuBarController()
//    menuBarController?.viewControllers = [homeNavController, helpNavController]
//    self.navigationController?.pushViewController(menuBarController!, animated: true)
//  }
  
}
