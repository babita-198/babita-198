//
//  SplashViewController.swift
//  FoodFox
//
//  Created by anand kumar on 09/02/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit
import CoreLocation


class SplashViewController: UIViewController {

    @IBOutlet weak var statusMessages: UILabel! {
        didSet {
         statusMessages.font = AppFont.regular(size: 14)
         statusMessages.textColor = headerColor
        }
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var timer: Timer?
    var islocationOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectToNextScreen), name: Notification.Name.RedirectToMainScreen.redirectToMainScreen, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
    getApkVersion()
        // getAppVersion()
    }
    
    @objc func redirectToNextScreen() {
            guard let launchValue = UserDefaults.standard.value(forKey: UserDefaultsKey.isFirstTimeLaunch) else {
                //Show totorial
                Localize.setCurrentLanguage(.english)
                UserDefaults.standard.set("1", forKey: UserDefaultsKey.isFirstTimeLaunch)
//                guard let vc = R.storyboard.main.tutorialContainerController() else {
//                    return
                guard let vc = R.storyboard.main.chooseDeliveryController() else {
                return
                }
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            print(launchValue)
            guard let vc = R.storyboard.main.chooseDeliveryController() else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUP() {
        //accessTokenApi()
       // getAppVersion()
        resetNotifiationCount()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Server call for getting app version
    func getAppVersion() {
        LoginManagerApi.share.getAppVersion { (response, error) in
            print(response ?? "")
            if let error = error {
                print("error blog")
                UIAlertController.presentAlert(title: nil, message: error.localizedDescription, style: UIAlertController.Style.alert).action(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
                })
                return
            }
            print("after error blog")
            if let data = response as? [String: Any] {
                let versionData = AppVersion(with: data)
                print("app verion cherker")
                guard let appVersion = versionData.appVersion, let criticalVersion = versionData.criticalAppVersion else {
                    fatalError("App version not found")
                }
                var forceUpdate = versionData.forceUpdate
                if forceUpdate == true {
                    if appVersion != appDelegate.appVersion  {
                                        self.showAlertForForceUpdate(message: "There is a new Update available, Please update your app to continue", appStoreUrl: "https://apps.apple.com/us/app/id1509260018")
                                        
                                   } else {
                                      self.continueInApp()
                    }
                }else{
                    self.continueInApp()

                }
                
               // self.checkVersion(newVersion: appVersion , forceUpdateVersion: criticalVersion, appStoreURL: "https://apps.apple.com/us/app/id1509260018")
                //self.checkVersion(newVersion: appVersion , forceUpdateVersion: criticalVersion, appStoreURL: "https://apps.apple.com/us/app/id1509260018")
               // https://apps.apple.com/us/app/id1509260018
//                CheckCode.checkVersion(appVersion: appVersion, appCriticalVersion: criticalVersion) { (isforceUpdate) in
//                    if !isforceUpdate {
//                        self.continueInApp()
//                    }
                //}
            }
        }
        
        
    }
        func getApkVersion() {
            LoginManagerApi.share.getApkVersion { (response, error) in
                print(response ?? "")
                if let error = error {
                    print("error blog")
                    UIAlertController.presentAlert(title: nil, message: error.localizedDescription, style: UIAlertController.Style.alert).action(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
                    })
                    return
                }
                print("after error blog")
                if let data = response as? [String: Any] {
                    let versionData = AppVersion(with: data)
                    print("app verion cherker")
                    guard let appVersion = versionData.appVersion, let criticalVersion = versionData.criticalAppVersion else {
                        fatalError("App version not found")
                    }
                    var forceUpdate = versionData.forceUpdate
                    if forceUpdate == true {
                        if appVersion != appDelegate.appVersion  {
                                            self.showAlertForForceUpdate(message: "There is a new Update available, Please update your app to continue", appStoreUrl: "https://apps.apple.com/us/app/id1509260018")
                                            
                                       } else {
                                          self.continueInApp()
                        }
                    }else{
                        self.continueInApp()

                    }
                    
                   // self.checkVersion(newVersion: appVersion , forceUpdateVersion: criticalVersion, appStoreURL: "https://apps.apple.com/us/app/id1509260018")
                    //self.checkVersion(newVersion: appVersion , forceUpdateVersion: criticalVersion, appStoreURL: "https://apps.apple.com/us/app/id1509260018")
                   // https://apps.apple.com/us/app/id1509260018
    //                CheckCode.checkVersion(appVersion: appVersion, appCriticalVersion: criticalVersion) { (isforceUpdate) in
    //                    if !isforceUpdate {
    //                        self.continueInApp()
    //                    }
                    //}
                }
            }
            
            
        }

    
    
    func resetNotifiationCount() {
        var param: [String: Any] = [:]
        
        param["deviceType"] = deviceType
        
        print(param)
        
        LoginManagerApi.share.resetCount(parameters: param) { (response: Any?, error: Error?) in
            print("count:- ", response as Any)
        }
    }
    
    /// app version
    func checkVersion(newVersion: String, forceUpdateVersion: String, appStoreURL: String) {
        let version = VersionManager(newVersion: newVersion, forceUpdateVersion: "\(forceUpdateVersion)", appStoreURL: appStoreURL)
        version.message(message: "There is a new Update available, Please update your app to continue").config(showAlert: false).newVersionAvailable { force in
            if force {
                self.showAlertForForceUpdate(message: "There is a new Update available, Please update your app to continue", appStoreUrl: appStoreURL)
                // Do not let user go inside the app
                //
            } else {
                if newVersion != appDelegate.appVersion {
                     self.showAlertForForceUpdate(message: "There is a new Update available, Please update your app to continue", appStoreUrl: appStoreURL)
                     
                } else {
                   self.continueInApp()
                   // self.showAlert(message: "There is a new Update available, Please update your app to continue", appStoreUrl: appStoreURL)
                   
                }
            }
        }
    }
    
    func continueInApp() {
        
        self.statusMessages.text = "Getting Current Location...".localizedString
        self.indicator.startAnimating()
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(SplashViewController.getLocation)), userInfo: nil, repeats: true)
        
    }
    
    private func showAlert(message: String, appStoreUrl: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            let alertController = UIAlertController(title: "Update".localized, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Later".localized, style: .default, handler: {[weak self] (_) in
                self?.continueInApp()
            })
            let updateAction = UIAlertAction(title: "Update".localized, style: .default, handler: { (_) in
                self.gotoAppStore(appStoreUrl: appStoreUrl)
            })
            alertController.addAction(updateAction)
            alertController.addAction(defaultAction)
            appDelegate.topViewController()?.present(alertController, animated: true, completion: {
            })
        })
    }
    
    private func showAlertForForceUpdate(message: String, appStoreUrl: String) {
        let alertController = UIAlertController(title: "Update".localized, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Update".localized, style: .default, handler: { (_) in
            self.gotoAppStore(appStoreUrl: appStoreUrl)
        })
        alertController.addAction(defaultAction)
        appDelegate.topViewController()?.present(alertController, animated: true, completion: {
        })
    }
    
    private func gotoAppStore(appStoreUrl: String) {
        guard let url  = URL(string: appStoreUrl) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.openURL(url)
        }
    }

    
    //MARK: Server Call After Getting Lat Long
    @objc func getLocation() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse || authorizationStatus == CLAuthorizationStatus.authorizedAlways {
            if LocationTracker.shared.currentLocationLatitude == 0.0 {
                return
            }
            
            if !CLReachability.isReachable {
                statusMessages.text = "Please check your internet connection.".localizedString
                return
            }
            statusMessages.text = "Getting Current Location...".localizedString
            timer?.invalidate()
            timer = nil
            indicator.stopAnimating()
            guard let launchValue = UserDefaults.standard.value(forKey: UserDefaultsKey.isFirstTimeLaunch) else {
                //Show totorial
                Localize.setCurrentLanguage(.english)
                UserDefaults.standard.set("1", forKey: UserDefaultsKey.isFirstTimeLaunch)
                
                
                guard let vc = R.storyboard.main.chooseDeliveryController()
                 else {
                    return
                }
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            print(launchValue)
            guard let vc = R.storyboard.main.chooseDeliveryController() else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
//            }
        }else if authorizationStatus == CLAuthorizationStatus.restricted || authorizationStatus == CLAuthorizationStatus.denied {
            islocationOn = false
            if !CLReachability.isReachable {
                statusMessages.text = "Please check your internet connection.".localizedString
                return
            }
            statusMessages.text = "Getting Current Location...".localizedString
            timer?.invalidate()
            timer = nil
            indicator.stopAnimating()
            guard let launchValue = UserDefaults.standard.value(forKey: UserDefaultsKey.isFirstTimeLaunch) else {
                //Show totorial
                Localize.setCurrentLanguage(.english)
                UserDefaults.standard.set("1", forKey: UserDefaultsKey.isFirstTimeLaunch)
                guard let vc = R.storyboard.main.tutorialContainerController() else {
                    return
                }
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            print(launchValue)
            guard let vc = R.storyboard.main.chooseDeliveryController() else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            LocationTracker.shared.configLocation(fromSplash: false)
        }
     
    }
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
