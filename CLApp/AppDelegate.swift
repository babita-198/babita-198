

//
//  AppDelegate.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
//import Fabric
//import Crashlytics
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKCoreKit
import GooglePlaces
import GoogleMaps
import UserNotifications
//import MZFayeClient
//import Hippo
import Firebase
import GoogleSignIn


@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    

   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      //MARK: Initialized Fugu chat
      //MARK: Key and Environment also set in Side Menu for anonymous User checking
//      FuguConfig.shared.setCredential(withAppSecretKey: Fugukey.live, appType: "1")
//      FuguConfig.shared.switchEnvironment(.live)
   //     self.setUpCustomUI()
        //Initialize Twitter
        //initilizeTwitter()
        // Initialize sign-in
        
        //let configureError: NSError?
        //GGLContext.sharedInstance().configureWithError(&configureError)
        //assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        //GIDSignIn.sharedInstance().clientID = Keys.googleClietId
        //GIDSignIn.sharedInstance().delegate = self
        Settings.shared.appID = Keys.fbAppId
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey(Keys.gmsPlacesClientKey)
        GMSServices.provideAPIKey(Keys.gmsServicesKey)
//        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
        
        //LocationTracker.shared.startLocationTracker()
        LocationTracker.shared.configLocation(fromSplash: false)
        
        setInitialViewController()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
      //MARK: Register for Notification
      // iOS 10 support
      if #available(iOS 10, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in }
        application.registerForRemoteNotifications()
      } else if #available(iOS 9, *) {
        // iOS 9 support
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
      } else {
        // iOS 8 support
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
      }
        

      let language = Localize.currentLang()
      if language == .english {
        Localize.setCurrentLanguage(.english)
      } else {
        Localize.setCurrentLanguage(.english)
      }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        if #available(iOS 10.0, *) {
            clLog("second", ofType: .debug, forCategory: .function)
        } else {
            // Fallback on earlier versions
            cllog("testing -----> ------>")
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        if url.scheme?.caseInsensitiveCompare("com.qawafeltech.FoodStar.payments") == .orderedSame {
            let notification = NSNotification.Name(rawValue: "dismissCheckOut")
            NotificationCenter.default.post(name: notification, object: nil)
            return true
        }
        
        if let urlScheme = url.scheme {
            if urlScheme == Keys.facebookSdkScheme {
                let handled: Bool = ApplicationDelegate.shared.application(app, open: url, options: options)
                // Add any custom logic here.
                return handled
            } else if urlScheme == Keys.googleSDKScheme {
                ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )
                
                GIDSignIn.sharedInstance().handle(url)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if let urlScheme = url.scheme {
            if urlScheme == Keys.facebookSdkScheme {
                let handled: Bool = ApplicationDelegate.shared.application(application, open: url as URL, sourceApplication: sourceApplication, annotation: annotation)
                // Add any custom logic here.
                return handled
            }
        }
//        else {
//            return GIDSignIn.sharedInstance().handle(url as URL,
//                                                     sourceApplication: sourceApplication,
//                                                     annotation: annotation)        }
//
        return true
    }
  
    func applicationDidBecomeActive(_ application: UIApplication) {
        EnvironmentView.register()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func setInitialViewController () {
        //Show Login screen
        self.setRootControllerWithIndetifier(identifier: "LaunchLogin")
    }

  
  func setRootControllerWithIndetifier(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("\(identifier)")
        if let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? UINavigationController {
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CLApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
     
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error == nil {
//            // Perform any operations on signed in user here.
//            _ = user.userID                  // For client-side use only!
//            _ = user.authentication.idToken // Safe to send to the server
//            _ = user.profile.name
//            _ = user.profile.givenName
//            _ = user.profile.familyName
//            _ = user.profile.email
//            // ...
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
    
    
//    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//    }
  
  //MARK:-
  func applicationWillEnterForeground(_ application: UIApplication) {
    LocationTracker.shared.startLocationTracker()
  }
}

//extension AppDelegate {
//  func setUpCustomUI() {
//    let hippotheme = HippoTheme.defaultTheme()
//    hippotheme.backgroundColor = headerLight
//    hippotheme.headerBackgroundColor = .white
//    hippotheme.headerTextColor = .white
//    hippotheme.incomingChatBoxColor = .white
//    hippotheme.outgoingChatBoxColor = darkPinkColor
//    hippotheme.outgoingMsgColor = .white
//    hippotheme.incomingMsgColor = lightBlackColor
//    hippotheme.incomingMsgFont = AppFont.regular(size: 14)
//    hippotheme.inOutChatTextFont = AppFont.regular(size: 14)
//    hippotheme.headerText = "support"
//    hippotheme.headerTextColor = lightBlackColor
//    hippotheme.addBtnTintColor = darkPinkColor
//    hippotheme.sendBtnIconTintColor = darkPinkColor
//    hippotheme.readMessageTintColor = .white
//    hippotheme.unreadMessageTintColor = .white
//    let language = Localize.currentLang()
//    if language == .arabic {
//        hippotheme.leftBarButtonImage = #imageLiteral(resourceName: "backMarker")
//    } else {
//        hippotheme.leftBarButtonImage = #imageLiteral(resourceName: "ic_back")
//    }
//    HippoConfig.shared.setCustomisedHippoTheme(theme: hippotheme)
//  }
//  
//}
