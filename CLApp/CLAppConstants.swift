//
//  CLAppConstants.swift
//  CLApp
//
//  Created by cl-macmini-68 on 09/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation


//let appVersionValue = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
let appVersionValue = "2.3"

/*
 
 */
struct AppColor {
    static let themePrimaryColor = UIColor(red: 41.0/255.0, green: 186.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    static let themeSecondaryColor = UIColor(red: 168.0/255.0, green: 211.0/255.0, blue: 121.0/255.0, alpha: 1.0)
}

/*
 
 */


// AppFont

struct AppFont {
    
    static func semiBold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Cairo-SemiBold", size: size) {
            return font
        }
        fatalError("Could not load bold Italic font")
    }
    
    static func bold(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Cairo-Bold", size: size) {
            return font
        }
        fatalError("Could not load bold font")
    }
    
    static func light(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Cairo-Light", size: size) {
            return font
        }
        fatalError("Could not load light font")
    }
    
    static func regular(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Cairo-Regular", size: size) {
            return font
        }
        fatalError("Could not load regular font")
    }
    
}



enum ApiExtendedUrl: String {
    case login = "api/customer/login"
    case getAppVersion = "api/admin/getAppVersion"
    case getApkVersion = "api/admin/getApkVersion"
}
// MARK: -  values
let totalprice = "$ 0.0"
let totalNumberOfItems = "ITEM IN CART"
let skipValue = 0
let numberOfLimit = 10
let tableHeaderText = "PRICE DETAILS"
let quantityText = "items"
let itemsButtonText = "+ " + "ADD MORE ITEMS".localizedString
let addNewAddressText = "+ " + "ADD MORE ADDRESS".localizedString
let newAddressText = "+ " + "ADD NEW ADDRESS".localizedString
let deliveryTimetext = "Mins".localizedString
let mapAlertMessage = "app is not installed on your Phone. Continue navigation with default Navigation App?".localizedString
let mapAlertTitle = "Continue".localizedString
let priceSymbol = "$"
let reviewText = "Reviews".localizedString + ">"
let mapCustomUrl = "comgooglemaps://"
let cancelButtonText = "Cancel".localizedString
let selectBranchesText = "Select Outlet".localizedString
let addOnType = "Customize".localizedString
let countryCode = "+91"
let logoutAlert = "Do you really want to logout?".localizedString
let cameraAlert = "AlertNoCamera".localizedString
let changeMobileNoText = "Change Mobile Number".localizedString
let deviceToken = "deviceTokenIOS123"
let deviceTokenForLogin = "iOSToken"
var trsansationID = ""
var signatureRazorPayment:String = ""

// MARK: - colors
let darkPinkColor = UIColor(red: 250.0/255.0, green: 140/255.0, blue: 05/255.0, alpha: 1.0)
let lightWhite = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1.0)
let whiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let lightBlackColor = UIColor(red: 63.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1.0)
let lightGrayColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
let darkGrayColor = UIColor(red: 110.0/255.0, green: 116.0/255.0, blue: 132.0/255.0, alpha: 1.0)
let headerColor = UIColor(red: 128.0/255.0, green: 138.0/255.0, blue: 145.0/255.0, alpha: 1.0)
let headerLight = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
let lineColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
let lightGreen = UIColor(red: 126/255.0, green: 211/255.0, blue: 33/255.0, alpha: 1.0)

// MARK: - Font
let fontNameMedium = "Poppins-Medium"
let fontStyleSemiBold = "Cairo-SemiBold"
let fontNameRegular = "Cairo-Regular"
let ppURL = "https://admin.foodfox.in/#/page/contentPrivacyPolicy"

// MARK: Data Formatter
func dateFormatted(date: String) -> String {
  let dateFor = DateFormatter()
  dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
  let dateValue = dateFor.date(from: date)
  let dateFormate = DateFormatter()
  dateFormate.dateFormat = "hh:mm a, dd MMM yyyy"
  return dateFormate.string(from: dateValue ?? Date())
}

func dateFormatted1(date: String) -> String {
  let dateFor = DateFormatter()
  dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    dateFor.timeZone = NSTimeZone(name: "UTC") as TimeZone?
  let dateValue = dateFor.date(from: date)
  let dateFormate = DateFormatter()
  dateFormate.dateFormat = "hh:mm a, dd MMM yyyy"
    dateFormate.timeZone = NSTimeZone(name: "UTC") as TimeZone?
  return dateFormate.string(from: dateValue ?? Date())
}

func dateFormatted2(date: String) -> String {
  let dateFor = DateFormatter()
  dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//    dateFor.timeZone = NSTimeZone(name: "UTC") as TimeZone?
  let dateValue = dateFor.date(from: date)
  let dateFormate = DateFormatter()
  dateFormate.dateFormat = "hh:mm a, dd MMM yyyy"
//    dateFormate.timeZone = NSTimeZone(name: "UTC") as TimeZone?
  return dateFormate.string(from: dateValue ?? Date())
}
//MARK: Home Delivery Button
func homeDelivery(homeView: UIView, pickUp: UIView, label: UILabel, pickUpLabel: UILabel) {
    homeView.layer.borderColor = UIColor.themeColor.cgColor
    label.textColor = UIColor.themeColor
    pickUp.layer.borderColor = lightGrayColor.cgColor
    pickUpLabel.textColor = UIColor.lightGray
    homeView.shadowPathRedCustom(cornerRadius: 5, color: UIColor.themeColor)
    pickUp.shadowPathRedCustom(cornerRadius: 5, color: lightGrayColor)
//    homeView.dropShadow(color: UIColor.themeColor, opacity: 0.5, offSet: CGSize(width: 2, height: 4), radius: 1, scale: true)
//   pickUp.dropShadow(color: lightGrayColor, opacity: 0.5, offSet: CGSize(width: 2, height: 4), radius: 1, scale: true)
}

//MARK: PickUp Delivery Button
func pickUpDelivery(homeView: UIView, pickUp: UIView, label: UILabel, pickUpLabel: UILabel) {
  pickUp.layer.borderColor = UIColor.themeColor.cgColor
  pickUpLabel.textColor = UIColor.themeColor
  homeView.layer.borderColor = lightGrayColor.cgColor
  label.textColor = UIColor.lightGray
    homeView.shadowPathRedCustom(cornerRadius: 5, color: lightGrayColor)
    pickUp.shadowPathRedCustom(cornerRadius: 5, color: UIColor.themeColor)
//   pickUp.dropShadow(color: UIColor.themeColor, opacity: 0.5, offSet: CGSize(width: 2, height: 4), radius: 1, scale: true)
//  homeView.dropShadow(color: lightGrayColor, opacity: 0.5, offSet: CGSize(width: 2, height: 4), radius: 1, scale: true)
}


//MARK: Base Controller for Side menu image
func baseController(controller: UIViewController) {
    
  if controller.revealViewController() != nil {
    controller.revealViewController().delegate = controller
    controller.view.addGestureRecognizer(controller.revealViewController().panGestureRecognizer())
    controller.view.addGestureRecognizer(controller.revealViewController().tapGestureRecognizer())
  }
}

func changeConstraint(controller: UIViewController, view: UIView) {
    if #available(iOS 11.0, *) {
        let safeAreaLayout = controller.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([ view.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 20.0)])
        
    } else {
    NSLayoutConstraint.activate([view.topAnchor.constraint(equalTo: controller.view.topAnchor, constant: 20.0)])
    }
}


//MARK: Home View Controller Enum

enum DeliveryType: String {
  case homeDelivery = "Home Delivery"
  case pickup = "Pick UP"
}

enum Type: String {
  case delivery = "Delivery"
  case pickup = "Pickup"
}

enum FlowType: Int {
  case home = 1
  case pickup
  var value: String {
    switch self {
    case .home:
      return "2"
    case .pickup:
      return "1"
    }
    
  }
}

enum HomeSection: Int {
  case sponser = 0
  case discover
  case newrestaurent
  case restaurent
  func getTitle() -> String {
    switch self {
    case .sponser:
      return "Sponsored".localizedString.uppercased()
    case .discover:
      return "Discover".localizedString.uppercased()
    case .restaurent:
      return "Restaurants near you".localizedString.uppercased()
    case .newrestaurent:
        return "Explore new restaurants".localizedString.uppercased()
    }
  }
}

var bookingFlow: FlowType = .pickup


func paymentType(status: Int) -> String {
    switch status {
    case 1:
        return "Cash"
    case 2:
        return "Card"
    case 4:
        return "Wallet"
    case 3:
        return "Mada"
    default:
        return ""
    }
}


func getStatus(status: Int) -> String {
  switch status {
  case 1:
    return "Open Now"
  case 2:
    return "Closed Now"
  case 3:
    return "Busy Now"
  default:
    return ""
  }
}

func getStatusName(status: Int) -> String {
  switch status {
  case 1:
    return "Open Now"
  case 2:
    return "Closed Now"
  case 3:
    return "Busy Now"
  default:
    return ""
  }
}


func getStatusType(status: Int) -> Bool {
  switch status {
  case 1:
    return false
  case 2:
    return true
  case 3:
    return true
  default:
    return true
  }
}


func blurView(image: UIImageView) -> UIView {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0.7
    blurView.frame = image.bounds
    return blurView
}

func blurViewFree(image: UIImageView) -> UIView {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.alpha = 0
    blurView.frame = image.bounds
    return blurView
}


func convertInUTC() -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
  dateFormatter.timeZone = TimeZone(identifier: "UTC")
  let date = dateFormatter.string(from: Date())
  return date
}

// MARK: Data Formatter
func dateTime(date: String) -> Date {
  let dateFor = DateFormatter()
  dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
  dateFor.timeZone = TimeZone(abbreviation: "UTC")
  let dateValue = dateFor.date(from: date)
  return dateValue ?? Date()
}


// MARK: Delivery Data Formatter
func dateDeliveryFormate(date: String) -> String {
  let dateFor = DateFormatter()
  dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
  let dateValue = dateFor.date(from: date)
  let dateFormate = DateFormatter()
  dateFormate.dateFormat = "hh:mma, ddMMM"
  return dateFormate.string(from: dateValue ?? Date())
}

//MARK: Custom Alert
func customAlert(controller: UIViewController, message: String) {
   let customView = MessageAlertView(nibName: Identifier.messageAlert, bundle: nil)
   customView.modalPresentationStyle = .overCurrentContext
   customView.modalTransitionStyle = .crossDissolve
   customView.messageString = message
   controller.present(customView, animated: true, completion: nil)
}



//MARK: Get Bearer Angle Between two Coordinates
func getBearingBetweenTwoPoints1(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
  let lat1 = degreesToRadians(degrees: point1.latitude)
  let lon1 = degreesToRadians(degrees: point1.longitude)
  let lat2 = degreesToRadians(degrees: point2.latitude)
  let lon2 = degreesToRadians(degrees: point2.longitude)
  let dLon = lon2 - lon1
  let y = sin(dLon) * cos(lat2)
  let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
  let radiansBearing = atan2(y, x)
  return radiansToDegrees(radians: radiansBearing)
}

func degreesToRadians(degrees: Double) -> Double {
return degrees * Double.pi / 180.0
}

func radiansToDegrees(radians: Double) -> Double {
  return radians * 180.0 / Double.pi
}

struct Keys {
    static let fbAppId = "935443273620643"
    static let facebookSdkScheme = "fb935443273620643"
    static let googleSDKScheme = "com.googleusercontent.apps.386261241269-2sf4q9ec3gqcngqh0j1a4ml3mdacrsnq"
    static let googleClietId  = "386261241269-2sf4q9ec3gqcngqh0j1a4ml3mdacrsnq.apps.googleusercontent.com"
    static let gmsPlacesClientKey = "AIzaSyA6JXZX69RmR61hCh7UjQu6m7nAtzVgHtM"
    static let gmsServicesKey = "AIzaSyA6JXZX69RmR61hCh7UjQu6m7nAtzVgHtM"
    static let twitterConsumerKey = "n40SGCZelZTPpwNFME593lNoy"
    static let twitterconsumerSecret = "uJwocLQdhEvtiGIySDErDoKTE50kpqPYzis1Po6GpandEHhYhW"
    static let googleKey = "AIzaSyA6JXZX69RmR61hCh7UjQu6m7nAtzVgHtM"
}

struct Fugukey {
   static let dev = "3de65b7282dc45ed6c4a36a742f46587"
   static let test = "3de65b7282dc45ed6c4a36a742f46587"
   static let live = "3de65b7282dc45ed6c4a36a742f46587"
   static let anonymous = "3de65b7282dc45ed6c4a36a742f46587"
}

// MARK: - USER_DEFAULT KEYS
struct UserDefaultsKey {
    static let accessToken = "accessToken"
    static let isFirstTimeLaunch = "FirstLaunch"
}

let deviceType: String = "IOS"
let maxLenthTextField = 30

enum SocialMode: String {
    case facebook = "Facebook"
    case googleplus = "Google plus"
    case twitter = "Twitter"
    case apple = "Apple"
}

enum Booking: String {
  case home = "2"
  case pickUp = "1"
}

extension Double {
  func roundTo2Decimal() -> String {
    let tempVar =  String(format: "%.2f", self)
    return tempVar
  }
  
  func roundTo1Decimal() -> String {
    let tempVar =  String(format: "%.1f", self)
    return tempVar
  }
}
