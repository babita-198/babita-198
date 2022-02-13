
//
//  chooseDeliveryController.swift
//  FoodFox
//
//  Created by socomo on 14/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit
//import SDKDemo1
//import MZFayeClient
import GooglePlaces
import GoogleMaps
import CoreLocation
//import Hippo
import CoreData

class ChooseDeliveryController: CLBaseViewController {

    @IBOutlet weak var homeDeliveryLabel: UILabel! {
        didSet {
           homeDeliveryLabel.font = AppFont.semiBold(size: 15)
        }
    }
    
    
    @IBOutlet weak var welcomeToFoodStarLbl: UILabel! {
        didSet {
            welcomeToFoodStarLbl.font = AppFont.bold(size: 20)
        }
    }
    
    
    @IBOutlet weak var startLbl: UILabel! {
        didSet {
            startLbl.font = AppFont.regular(size: 14)
        }
    }
    
    @IBOutlet weak var arrowBtn: UIButton!
    
    @IBOutlet weak var pickUpOrderBtn: UIButton! {
        didSet {
            pickUpOrderBtn.titleLabel?.font = AppFont.bold(size: 16)
        }
    }
    
    @IBOutlet weak var homeDeliveryBtn: UIButton! {
        didSet {
            homeDeliveryBtn.titleLabel?.font = AppFont.bold(size: 16)
            homeDeliveryBtn.isHidden = true
        }
    }
    
    
    
    
    @IBOutlet weak var selfPickUpLabel: UILabel! {
        didSet {
            selfPickUpLabel.font = AppFont.semiBold(size: 15)
        }
    }
    
    
    @IBOutlet weak var bottomDeliverOptionView: UIView!
    
    
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var defaultImageView: UIImageView!
    
    var isShowOrHideSelected = false
    
    var tutorialDetails = [Banner]()
    
    override func viewDidLoad() {
        
    super.viewDidLoad()
        
    NotificationCenter.default.addObserver(self, selector: #selector(ChooseDeliveryController.methodOfReceivedPaymentCancelNotify), name: NSNotification.Name(rawValue: "PaymentCancel"), object: nil)
    //defaultImageView.image = #imageLiteral(resourceName: "BG")
    //bottomDeliverOptionView.animShow()
     //defaultImageView.isHidden = true
    self.automaticallyAdjustsScrollViewInsets = false
    self.navigationController?.navigationBar.isHidden = true
    //localizedString()
        
  }
  
     @objc func methodOfReceivedPaymentCancelNotify( ) {
        
         bottomDeliverOptionView.animShow()
        
    }
    
  //MARK: Localized String
  func localizedString() {
        let language = Localize.currentLang()
        if language == .english{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    selfPickUpLabel.textColor = headerColor
    homeDeliveryLabel.textColor = headerColor
    
    pickUpOrderBtn.setTitle("PICKUP ORDER".localizedString, for: UIControl.State.normal)
    homeDeliveryBtn.setTitle("HOME DELIVERY".localizedString, for: UIControl.State.normal)
    welcomeToFoodStarLbl.text = "Welcome to FoodFox".localizedString
    startLbl.text = "Start your Order Now".localizedString
    homeDeliveryLabel.text = "Home Delivery".localizedString
    selfPickUpLabel.text = "Pick UP".localizedString
  }
  
  //MARK: View Will Appear
  override func viewWillAppear(_ animated: Bool) {
    self.addNotifications()
   // self.setUpBorder()
//    self.collectionView.delegate = self
//    self.collectionView.dataSource = self
//    self.collectionView.reloadData()
//    self.getTutorials()
    self.accessTokenApi()
    self.navigationController?.navigationBar.isHidden = true
    self.openMenuController()
  }
    
    
    // MARK: - Api of get tutorial
    func getTutorials() {
        var param: [String: Any] = [:]
        param["latitude"] = LocationTracker.shared.currentLocationLatitude
        param["longitude"] = LocationTracker.shared.currentLocationLongitude
        LoginManagerApi.share.getBanner(parameters: param) {(response: [Banner]?, error: Error?)in
            if let data = response {
                self.tutorialDetails.removeAll()
                self.tutorialDetails = data
                self.collectionView.reloadData()
            }
            //Rami Comment
//            if self.tutorialDetails.count == 0 {
//                self.defaultImageView.isHidden = false
//                self.collectionView.isHidden = true
//            } else {
//                self.defaultImageView.isHidden = true
//                self.collectionView.isHidden = false
//            }
            
        }
    }
    
  
  // MARK: - Api of AccessToken
  /// - access token data fetching from server
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
  
  //MARK: Set Border Color and offset animation
  /// - set Border And background Blurr shadow
  func setUpBorder() {
    if bookingFlow == .home {
      homeDelivery(homeView: self.homeView, pickUp: deliveryView, label: homeDeliveryLabel, pickUpLabel: selfPickUpLabel)
    } else {
      pickUpDelivery(homeView: self.homeView, pickUp: deliveryView, label: homeDeliveryLabel, pickUpLabel: selfPickUpLabel)
    }
  }
    //MARK:- Arrow btn action
    @IBAction func arrowBtnAction(_ sender: Any) {
        if !isShowOrHideSelected == true {
            isShowOrHideSelected = true
            bottomDeliverOptionView.animHide()
            //self.arrowImageView.image = #imageLiteral(resourceName: "downImage")
            
        } else {
            isShowOrHideSelected = false
            bottomDeliverOptionView.animShow()
           // self.arrowImageView.image = #imageLiteral(resourceName: "UP")
            
           
            
        }
    }
    //MARK: Home Delivery
  /// - Home Button Selected for creating booking
  @IBAction func homeDeliveryAction(_ sender: UIButton) {
    homeDeliveryLabel.textColor = darkPinkColor
    selfPickUpLabel.textColor = headerColor
    bottomDeliverOptionView.animHide()
    self.openMenuController()
    bookingFlow = .home
  }
  
  //MARK: Pick Up
  /// - Pick Up Button Selected for creating booking
  @IBAction func pickUpAction(_ sender: UIButton) {
    homeDeliveryLabel.textColor = headerColor
    selfPickUpLabel.textColor = darkPinkColor
    bottomDeliverOptionView.animHide()
    bookingFlow = .pickup
    self.openMenuController()
  }
  
  //MARK: Notification
  /// - Added Notification Observar to check Logout user
  func addNotifications() {
    NotificationCenter.default.removeObserver(self, name: Notification.Name.LoginManagerStatus.logout, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: Notification.Name.LoginManagerStatus.logout, object: nil)
  }
  
  //MARK: User Did LogOut
  /// - call observer when user get loged out with access token expire and
  /// - with force loged out
  @objc func userDidLogout() {
    self.deleteAllRecords()
   // HippoConfig.shared.clearHippoUserData()
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
  
  
  //MARK: Delete storage
  /// - when User get loged out should remove all local cart storage
  func deleteAllRecords() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    if #available(iOS 10.0, *) {
      let context = appDelegate.persistentContainer.viewContext
      
      let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
      do {
        try context.execute(deleteRequest)
        try context.save()
      } catch {
        print("Error")
      }
    }
  }
  
  
  // MARK: - Root controller actions..
  func openMenuController() {
    //MARK: Side Menu for Guest use
    //Home Storyboard
    if !LoginManagerApi.share.isAccessTokenValid {
      let storyboardGuest = R.storyboard.home
      //SideMenuController
      guard let sideMenuControllerGuest = storyboardGuest.sideMenuController(),
        let homeViewControllerGuest = storyboardGuest.homeViewController() else {
          fatalError("Couldn't instantiate view controller")
      }
    let menuNavController: UINavigationController = UINavigationController(rootViewController: sideMenuControllerGuest)
      let homeNavControllerGuest: UINavigationController = UINavigationController(rootViewController: homeViewControllerGuest)
      var itemGuest = MenuViewModel(title: "sideHome".localizedString, image: R.image.cLLogo(), isSelected: true, controller: homeNavControllerGuest)
      sideMenuControllerGuest.guestMenuItems.append(itemGuest)
      //Chat
      let chatNavControllerGuest = UINavigationController(rootViewController: storyboardGuest.chatSupportController() ?? UIViewController())
      itemGuest = MenuViewModel(title: "ChatSupport".localizedString, image: R.image.cLLogo(), isSelected: false, controller: chatNavControllerGuest)
      sideMenuControllerGuest.guestMenuItems.append(itemGuest)
      // Info
      let infoNavControllerGuest = UINavigationController(rootViewController: storyboardGuest.infoController() ?? UIViewController())
      itemGuest = MenuViewModel(title: "Info".localizedString, image: R.image.cLLogo(), isSelected: false, controller: infoNavControllerGuest)
      sideMenuControllerGuest.guestMenuItems.append(itemGuest)
      let reavealViewControllerGuest: SWRevealViewController! = SWRevealViewController(rearViewController: menuNavController, frontViewController: homeNavControllerGuest)
      let language = Localize.currentLang()
      if language == .arabic {
        reavealViewControllerGuest.setRight(sideMenuControllerGuest, animated: true)
      }
      reavealViewControllerGuest?.view.backgroundColor = UIColor.white
      navigationController?.navigationBar.isHidden = true
      navigationController?.pushViewController(reavealViewControllerGuest, animated: false)
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
    
    let menuNavController: UINavigationController = UINavigationController(rootViewController: sideMenuController)
    
    // HomeController
    let homeNavController: UINavigationController = UINavigationController(rootViewController: homeViewController)
    print("home \(homeNavController.viewControllers)")
    var item = MenuViewModel(title: "sideHome".localizedString, image: R.image.cLLogo(), isSelected: true, controller: homeNavController)
    sideMenuController.menuItems.append(item)
    
    // MyProfile
    let profileNavController = UINavigationController(rootViewController: profileController)
    profileNavController.navigationBar.isHidden = true
    item = MenuViewModel(title: "MyProfile".localizedString, image: R.image.cLLogo(), isSelected: false, controller: profileNavController)
    sideMenuController.menuItems.append(item)
    print(item)
    // MyAddress
    let addressNavController = UINavigationController(rootViewController: myAddress )
    item = MenuViewModel(title: "MyAddress".localizedString, image: R.image.cLLogo(), isSelected: false, controller: addressNavController)
    sideMenuController.menuItems.append(item)
    print(item)
    // MyOrder
    let orderNavController = UINavigationController(rootViewController: myOrder)
    item = MenuViewModel(title: "MyOrders".localizedString, image: R.image.cLLogo(), isSelected: false, controller: orderNavController)
    sideMenuController.menuItems.append(item)
    print(item)
    // Refer a friend
    let referNavController = UINavigationController(rootViewController: referVC)
    item = MenuViewModel(title: "Referafriend".localizedString, image: R.image.cLLogo(), isSelected: false, controller: referNavController)
    sideMenuController.menuItems.append(item)
    print(item)
    // Promotion
    let promotionsNavController = UINavigationController(rootViewController: storyboard.promotionsController() ?? UIViewController())
    item = MenuViewModel(title: "Promotions".localizedString, image: R.image.cLLogo(), isSelected: false, controller: promotionsNavController)
    sideMenuController.menuItems.append(item)
    print(item)
    // Chat
    let chatNavController = UINavigationController(rootViewController: storyboard.liveZillaChatVc() ?? UIViewController())
    item = MenuViewModel(title: "ChatSupport".localizedString, image: R.image.cLLogo(), isSelected: false, controller: chatNavController)
    sideMenuController.menuItems.append(item)
    print(item)
    // Info
    let infoNavController = UINavigationController(rootViewController: storyboard.infoController() ?? UIViewController())
    item = MenuViewModel(title: "Info".localizedString, image: R.image.cLLogo(), isSelected: false, controller: infoNavController)
    sideMenuController.menuItems.append(item)
    
    print ("home \(homeNavController.viewControllers) menu \(menuNavController.viewControllers)")
    let reavealViewController: SWRevealViewController! = SWRevealViewController(rearViewController: menuNavController, frontViewController: homeNavController)
    let language = Localize.currentLang()
    if language == .arabic {
      reavealViewController.setRight(sideMenuController, animated: true)
    }
    reavealViewController?.view.backgroundColor = UIColor.white
    navigationController?.navigationBar.isHidden = true
    navigationController?.pushViewController(reavealViewController, animated: false)
  }
}

extension UIView {
    func animShow() {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide() {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        }, completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
