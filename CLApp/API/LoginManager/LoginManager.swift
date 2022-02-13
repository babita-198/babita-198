
//
//  LoginManager.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
//import Fabric
//import Crashlytics
import KeychainAccess

//Protocol
protocol LoginManagerRoules {
    var requestHeaders: [String: String]? {get}
}

//-----
extension Notification.Name {
    /// Used as a namespace for all `URLSessionTask` related notifications.
    struct LoginManagerStatus {
        /// Posted when a `URLSessionTask` is resumed. The notification `object` contains the resumed `URLSessionTask`.
        static let logout = Notification.Name(rawValue: "clicklabs.LoginManager.logout")
        static let unauthorized = Notification.Name(rawValue: "clicklabs.LoginManager.unauthorized")
        public static let userNotVarified = Notification.Name(rawValue: "clicklabs.LoginManager.userNotVarified")
    }
}

let kAccessToken: String = "AccessToken"
typealias LoginManagerCallBack = ((_ response: Any?, _ error: Error?) -> Void)

final class LoginManagerApi: LoginManagerRoules {
    
    // MARK: -
    private(set) var me: Me?
    
    //: --
    static let share = LoginManagerApi()
    var selectedRestaurantDetail: RestaurantNear?
    var addedItemArray = [MenuQuantityDetails]()
    var promoAmount = 0.0
    var promoName = ""
  
    private let persistencyManager: PersistencyManager<Me>
    private let keychain: Keychain
    
    class private var fileName: String {
        return "user.bin"
    }
    
    class private var keychainServiceName: String {
        let appName = appDelegate.displayName
        return "com.\(appName).login_manager"
    }
    
    /// Return true for valid access token, otherwise retrun false
    public var isAccessTokenValid: Bool {
        if let me = self.me,
            let accessToken = me.accessToken,
            accessToken.isEmpty == false {
            return true
        }
        return false
    }
    
    //Singleton initialization to ensure just one instance is created.
    private init() {
        
        persistencyManager = PersistencyManager()
        keychain = Keychain(service: LoginManagerApi.keychainServiceName)
        
        guard let token = keychain[kAccessToken] else {
            removeUserProfile()
            return
        }
        
        let fileURL: URL = getFilePath()
        guard let me = persistencyManager.getObject(fileURL: fileURL) else {
            removeUserProfile()
            return
        }
        
        self.me = me
        self.me?.accessToken = token

        //HTTP Request unauthorized....
        NotificationCenter.default.removeObserver(self, name: Notification.Name.HTTPRequestStatus.unauthorized, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginManagerApi.afterUnauthorized), name: Notification.Name.HTTPRequestStatus.unauthorized, object: nil)
        
    }
    
    /// Access token.
    final var requestHeaders: [String: String]? {
        var headers = ["": ""]
        headers.removeAll()
       let language = Localize.currentLang()
       if language == .english {
          headers["language"] = "en"
       } else {
        headers["language"] = "en"
      }
      if let accessToken = self.me?.accessToken {
            headers["authorization"] = "bearer \(accessToken)"
        }
        return headers
    }
    
    //Persistency storage.
    private func getFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentsDirectory = paths[0]
        documentsDirectory.appendPathComponent(LoginManagerApi.fileName)
        return documentsDirectory
    }
    
    func saveProfile() {
        if let me = self.me {
            let fileURL: URL = getFilePath()
            let saved = persistencyManager.save(url: fileURL, object: me)
            print("----> saved \(saved)")
            keychain[kAccessToken] = me.accessToken
        }
    }
    
    func removeUserProfile() {
        let fileURL: URL = getFilePath()
        persistencyManager.removeObject(url: fileURL)
        do {
            try keychain.remove(kAccessToken)
        } catch {
            print("KEYCHAIN NOT REMOVE")
            return
        }
        me = nil
    }
    
    private func afterLogin() {
        // TODO: Use the current user's information
        self.saveProfile()
        //Enable location
        guard self.me != nil else {
            return
        }
        if self.me?.isSocial == true {
            
             NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginStatusCheck"), object: nil)
            
              NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "LoginStatusCheck"), object: nil)
            if self.me?.isPhoneVerified == false {
                NotificationCenter.default.post(name: Notification.Name.OtpControllerState.moveToOtp, object: nil)
            } else {
                NotificationCenter.default.post(name: Notification.Name.RootControllerState.openMenu, object: nil)
            }
        }
    }
    
    @objc private func afterUnauthorized() {
        self.removeUserProfile()
        //NotificationCenter.default.post(name: Notification.Name.LoginManagerStatus.logout, object: nil)
    }
    
    @objc private func afterLogout() {
        self.removeUserProfile()
        
        NotificationCenter.default.post(name: Notification.Name.LoginManagerStatus.logout, object: nil)
    }

  //MARK: Update User Profile
    private func updateUserProfile(response: HTTPResponse, callBack: LoginManagerCallBack) {
        if response.error != nil {
            callBack(nil, response.error)
            return
        }
        
        if let jsonObject = response.value as? [String: Any],
            let data = jsonObject["data"] as? [String: Any] {
            print(data)
            let me = Me(with: data)
            self.me = me
            UserDefaults.standard.set(true, forKey: "LoginStatus")
            self.afterLogin()
            
        }
        
        callBack(response.value, nil)
    }
    
    // MARK: - Server requests
    //Public Apis
    func login(parameter: [String: Any], callBack: @escaping LoginManagerCallBack) {
        HTTPRequest(method: .post,
                    path: ApiExtendedUrl.login.rawValue,
                    parameters: parameter,
                    encoding: .json,
                    files: nil)
            .config(isIndicatorEnable: true, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                print("login url ", ApiExtendedUrl.login.rawValue)
                print("login parameters ", parameter)
                print("login response ", response)
                self.updateUserProfile(response: response, callBack: callBack)
        }
    }
    
  //MARK: Social LogIn API
    func socialLogin(parameter: [String: Any], callBack: @escaping LoginManagerCallBack) {
        
        HTTPRequest(method: .post,
                    path: "api/customer/loginViaSocial",
                    parameters: parameter,
                    encoding: .json,
                    files: nil)
            .config(isIndicatorEnable: true, isAlertEnable: true).multipartHandler(completion: { (response: HTTPResponse) in
                
                print("jSon response...  \(response)")
                self.updateUserProfile(response: response, callBack: callBack)
            })
        
    }
    
    
  // MARK: SignUp API
    func signup(parameters: [String: Any], files: [CLFile]?, password: String, callBack: @escaping LoginManagerCallBack) {
        HTTPRequest(method: .post,
                    path: "api/customer/register",
                    parameters: parameters,
                    encoding: .json,
                    files: files).config(isIndicatorEnable: true, isAlertEnable: true)
            .multipartHandler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                
                print("signup url")
                self.updateUserProfile(response: response, callBack: callBack)
                
        }
    }
  
  // MARK: Update Profile API
    func updateProfile(parameters: [String: Any], files: [CLFile]?, password: String, callBack: @escaping LoginManagerCallBack) {
        HTTPRequest(method: .put,
                    path: "api/customer/updateProfile",
                    parameters: parameters,
                    encoding: .json,
                    files: files).config(isIndicatorEnable: true, isAlertEnable: true)
            .multipartHandler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                self.updateUserProfile(response: response, callBack: callBack)
        }
    }
    
    // MARK: Reset Notification Count
    typealias LocationCallBack = ((_ response: Any?, _ error: Error?) -> Void)
    func resetCount(parameters: [String: Any], callBack: @escaping LocationCallBack) {
        HTTPRequest(method: .put,
                    path: "api/customer/resetNotificationCount",
                    parameters: parameters,
                    encoding: .json,
                    files: nil).config(isIndicatorEnable: false, isAlertEnable: false)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                callBack(response.value as? [String: Any], nil)
                
        }
    }
    
    
  // MARK: Change Password API
    func changePassword(parameters: [String: Any], callBack: @escaping LoginManagerCallBack) {
        HTTPRequest(method: .put,
                    path: "api/customer/changePassword",
                    parameters: parameters,
                    encoding: .json,
                    files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                callBack(response.value, nil)
                print("jSon response...  \(response)")
        }
        
    }
    
   

    
    
    // MARK: Get Tutorails API
    typealias BannerCallBack = ((_ response: [Banner]?, _ error: Error?) -> Void)
    func getBanner(parameters: [String: Any], callBack: @escaping BannerCallBack) {
        var param: [String: Any] = parameters
        param["skip"] = 0
        param["limit"] = 5
           HTTPRequest(method: .get,
                        path: "api/customer/getAllBanner",
                        parameters: param,
                        encoding: .url,
                        files: nil).config(isIndicatorEnable: false, isAlertEnable: true)
                .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                    
                    if response.error != nil {
                        callBack(nil, response.error)
                        return
                    }
                    if let dict = response.value as? [String: Any] {
                        print("data", dict)
                        var banner: [Banner] = []
                        if let data = dict["data"] as? [String: Any], let bannerData = data["bannerData"] as? [[String: Any]] {
                            for item in bannerData {
                             let tutorials = Banner(data: item)
                             banner.append(tutorials)
                            }
                            callBack(banner, nil)
                            return
                        }
                    }
                    callBack(nil, response.error)
            }
    }
    
    
  // MARK: Get Tutorails API
    func getTutorials(parameters: [String: Any], callBack: @escaping LoginManagerCallBack) {
        if  let skip = parameters["skip"], let limit = parameters["limit"] {
            let urlPath = "api/admin/getTutorials?limit=\(limit)&skip=\(skip)"
            print(urlPath)
            var param: [String: Any] = parameters
            let language = Localize.currentLang()
            if language == .english {
                param["language"] = "en"
            } else {
                param["language"] = "en"
            }
            
            HTTPRequest(method: .get,
                        path: "api/admin/getTutorials",
                        parameters: param,
                        encoding: .url,
                        files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
                .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                    
                    if response.error != nil {
                        callBack(nil, response.error)
                        return
                    }
                    if let dict = response.value as? [String: Any] {
                        print("data", dict)
                        if let data = dict["data"] as? [String: Any] {
                            let tutorials = TutorialDetails(data: data)
                            print(tutorials.tutorialData)
                            callBack(tutorials, nil)
                            return
                        }
                    }
                    callBack(nil, response.error)
            }
        }
    }
  
  //MARK: Acccess Tokan API
    func accessToken(parameters: [String: Any], callBack: @escaping LoginManagerCallBack) {
        HTTPRequest(method: .get,
                    path: "api/customer/accessTokenLogin",
                    parameters: parameters,
                    encoding: .url,
                    files: nil).config(isIndicatorEnable: true, isAlertEnable: true)
            .handler(httpModel: false, delay: 0.0) { (response: HTTPResponse) in
                if response.error != nil {
                    callBack(nil, response.error)
                    return
                }
                self.updateUserProfile(response: response, callBack: callBack)
        }
    }
  
  //MARK: OTP Resent API
    func resendOTP(callBack: @escaping LoginManagerCallBack) {
        let mobile = self.me?.mobile ?? ""
        var phone: [String: Any] =  ["phoneNo": mobile ]
        let language = Localize.currentLang()
        if language == .english {
         phone["language"] = "en"
            
        } else {
         phone["language"] = "en"
            
         }
        print("resent otp \(phone)")
        HTTPRequest(method: .put, path: "api/customer/resendOTP", parameters: phone, encoding: .json, files: nil).handler { (response: HTTPResponse) in
            callBack(response.value, response.error)
        }
    }
  
  //MARK: changeMobileNumber
    func changeMobileNumber(diallingCode: String, mobile: String, callBack: @escaping LoginManagerCallBack) {
        let param = ["mobile": mobile,
                     "countryCode": diallingCode]
        HTTPRequest(method: .put, path: "user/setPrimaryNumber", parameters: param, encoding: .json, files: nil).handler { (response: HTTPResponse) in
            callBack(response.value, response.error)
        }
    }
    
  //MARK: Verify Mobile API
    func verifyMobileNumber(otp: String, callBack: @escaping LoginManagerCallBack) {
      let otp =  otp
      let param = ["OTPCode": otp]
        HTTPRequest(method: .put,
                    path: "api/customer/verifyOTP",
                    parameters: param,
                    encoding: .json,
                    files: nil).handler(httpModel: false, delay: 0.0, completion: { (response) in
                        self.updateUserProfile(response: response, callBack: callBack)
                    })
    }
  
  // MARK: Forgot Password API
    func forgotPassword(diallingCode: String, phone: String, callBack: @escaping LoginManagerCallBack) {
        var parameters: Dictionary =  [
            "phoneNo": phone,
            "countryCode": diallingCode
            ] as [String: Any]
        let language = Localize.currentLang()
        if language == .english {
            parameters["language"] = "en"
        } else {
            parameters["language"] = "en"
        }
        HTTPRequest(method: .put, path: "api/customer/customerForgotPassword", parameters: parameters, encoding: .json, files: nil).handler { (response: HTTPResponse) in
            callBack(response.value, response.error)
        }    }
  
  // MARK: LogOut API
    func logout(callBack: @escaping LoginManagerCallBack) {
        
        HTTPRequest(method: .put, path: "api/customer/logout", parameters: nil, encoding: .url, files: nil)
            .handler { (response: HTTPResponse) in
                
                if response.error != nil {
                    callBack(nil, response.error)
                    return
                }
                
                if let value = response.value {
                    self.afterLogout()
                    callBack(value, nil)
                }
        }
    }
    
    // MARK: Get app version
    func getAppVersion(callBack: @escaping LoginManagerCallBack) {
        let query = "\(ApiExtendedUrl.getAppVersion.rawValue)?appType=\(deviceType)"
        HTTPRequest(method: .get, path: query, parameters: nil, encoding: .url, files: nil)
            .handler { (response: HTTPResponse) in
                
                if response.error != nil {
                    callBack(nil, response.error)
                    return
                }
                
                if let value = response.value {
                    guard let response = value as? [String: Any], let data = response["data"] as? [String: Any] else {
                        callBack(value, nil)
                        return
                    }
                    print(response)
                    callBack(data, nil)
                }
        }
    }
    func getApkVersion(callBack: @escaping LoginManagerCallBack) {
            let query = "\(ApiExtendedUrl.getApkVersion.rawValue)?appType=\(deviceType)"
            HTTPRequest(method: .get, path: query, parameters: nil, encoding: .url, files: nil)
                .handler { (response: HTTPResponse) in
                    
                    if response.error != nil {
                        callBack(nil, response.error)
                        return
                    }
                    
                    if let value = response.value {
                        guard let response = value as? [String: Any], let data = response["data"] as? [String: Any] else {
                            callBack(value, nil)
                            return
                        }
                        print(response)
                        callBack(data, nil)
                    }
            }
        }
        
}
    

 
