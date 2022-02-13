//
//  TrackOrderMapViewController.swift
//  FoodFox
//
//  Created by clicklabs on 13/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
//import SDKDemo1
//import MZFayeClient

class TrackOrderMapViewController: UIViewController {
  
  //MARK: Outlet
  @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var helpButton: UIButton! {
        didSet {
            helpButton.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
  @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverName: UILabel! {
        didSet {
            driverName.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var driverCode: UILabel! {
        didSet {
            driverCode.font = AppFont.regular(size: 14)
        }
    }
  @IBOutlet weak var mapViewShadow: UIView!
 @IBOutlet weak var topNavView: UIView!
    @IBOutlet weak var bottomViewtopNavView: UIView!
  @IBOutlet weak var backBtn: UIButton!
    
  //MARK: Variables
  var startingPointMarker: GMSMarker? = GMSMarker()
  var bookingId = ""
  var orderId = ""
  var timer: Timer?
  var trackData: TrackOrderModel = TrackOrderModel()
  var currentLocation = CLLocationCoordinate2D()
  var prevCurrentLocation = CLLocationCoordinate2D()
  var destinationLocation = CLLocationCoordinate2D()
  var restaurentLocation = CLLocationCoordinate2D()
  
  //MARK: View Did Load
  override func viewDidLoad() {
        super.viewDidLoad()
    prevCurrentLocation = CLLocationCoordinate2D(latitude: LocationTracker.shared.currentLocationLatitude, longitude: LocationTracker.shared.currentLocationLongitude )
    timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: (#selector(TrackOrderMapViewController.getLocation)), userInfo: nil, repeats: true)
   self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      backBtn.changeBackBlackButton()

  }

  //MARK: View Will Appear
  override func viewWillAppear(_ animated: Bool) {
    self.getLocation()
    helpButton.setTitle("HELP".localizedString, for: .normal)
    checkStatusForDarkMode()
  }
  
    
    
    //MARK:- CHECK STATUS OF DARK MODE
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            topNavView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            bottomViewtopNavView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.driverName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.driverCode.textColor = lightWhite
        } else {
            topNavView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            bottomViewtopNavView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.navTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.driverName.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.driverCode.textColor = lightGrayColor
        }
        
    }
    
    
  //MARK: View Will DisAppear
  override func viewDidDisappear(_ animated: Bool) {
      timer?.invalidate()
      timer = nil
  }
  
  //MARK: Back Button
  @IBAction func backButtonAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: Help Button
  @IBAction func helpAction(_ sender: UIButton) {
    guard let chatVc = R.storyboard.home.liveZillaChatVc() else {
        return
    }
    self.present(chatVc, animated: true, completion: nil)
//    let manager = LoginManagerApi.share.me
//    let mobile = manager?.mobile ?? ""
//   let fuguUserDetail = FuguUserDetail(fullName: manager?.fullName ?? "", email: manager?.email ?? "", phoneNumber: mobile, userUniqueKey: manager?.id ?? "")
//    FuguConfig.shared.updateUserDetail(userDetail: fuguUserDetail)
//    FuguConfig.shared.presentChatsViewController()
  }
  
  //MARK: Call Button Action
  @IBAction func callAction(_ sender: UIButton) {
    if let phone = trackData.driverNumber {
      calltoRestaurant(phoneNumber: phone)
    }
  }
  
  // MARK: Call Function
  func calltoRestaurant(phoneNumber: String) {
    let contactSupport = phoneNumber.trimmed()
    guard appDelegate.makePhoneCall(phoneNumber: contactSupport) else {
      customAlert(controller: self, message: "Not able to make phone call ".localizedString)
      return
    }
  }
  
  // MARK: SetUp Details
  func setUpDetail() {
    if let imageUrl = trackData.driverImage {
      driverImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
    }
    driverImage.backgroundColor = .red
    driverImage.clipsToBounds = true
    driverImage.cornerRadius = 25
    if let name = trackData.driverName {
      driverName.text = name
    }
    driverCode.text = ""
    navTitle.text = "#\(orderId)"
  }

  //MARK: Get Location to track
  @objc func getLocation() {
    self.prevCurrentLocation = self.currentLocation
   TrackOrderModel.orderOrderMap(bookingId: bookingId, callBack: { (data: TrackOrderModel?, error: Error?) in
      if error == nil {
        if let data = data {
        self.trackData = data
          if let lat = self.trackData.pickUpLat, let long = self.trackData.pickUpLong {
            self.restaurentLocation = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(long) ?? 0.0 )
          }
        self.getCoreLocation()
         self.setUpDetail()
        }
      }
    })
  }
  
  // MARK: Get Lat Long from backend for Polyline
  func getCoreLocation() {
  
    var wayPoint = ""
    if let lat = trackData.fleetLat, let long = trackData.fleetLong {
      wayPoint = "waypoints=\(lat),\(long)"
    }
    
    let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(trackData.pickUpLat ?? ""),\(trackData.pickUpLong ?? "")&destination=\(trackData.jobLat ?? ""),\(trackData.jobLong ?? "")&\(wayPoint)&mode=driving&key=\(Keys.googleKey)"
    if let lat = trackData.fleetLat, let long = trackData.fleetLong {
    currentLocation = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(long) ?? 0.0 )
    }
    if let lat = trackData.jobLat, let long = trackData.jobLong {
      destinationLocation = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(long) ?? 0.0 )
    }
    TrackOrderModel.sendRequestToServer(baseUrl: url, "", httpMethod: "POST", isZipped: false) { (isSuccess, response) in
      print(response)
      if let routesValue = response["routes"] as? NSArray {
        OperationQueue.main.addOperation({
          self.mapView.clear()
          //Setting Marker for Customer Location
          let stateMarkerDdrop = GMSMarker()
          stateMarkerDdrop.position = self.destinationLocation
          stateMarkerDdrop.icon = #imageLiteral(resourceName: "trackMap")
          stateMarkerDdrop.map = self.mapView
          
          //Setting Marker  for Restaurent Location
          let stateMarker = GMSMarker()
          stateMarker.position = self.restaurentLocation
          stateMarker.icon = #imageLiteral(resourceName: "restaurentMarker")
          stateMarker.map = self.mapView
          
          let angle = getBearingBetweenTwoPoints1(point1: self.prevCurrentLocation, point2: self.currentLocation)
          
          //Setting Marker for Driver Location
          let stateMarkerDriver = GMSMarker()
          stateMarkerDriver.position = self.currentLocation
          stateMarkerDriver.appearAnimation = .none
          stateMarkerDriver.icon = #imageLiteral(resourceName: "car")
          stateMarkerDriver.rotation = angle
          stateMarkerDriver.map = self.mapView
          for route in routesValue {
            if let route = route as? NSDictionary {
            let routeOverviewPolyline: NSDictionary = (route).value(forKey: "overview_polyline") as? NSDictionary ?? [: ]
            let points = routeOverviewPolyline.object(forKey: "points")
            let path = GMSPath.init(fromEncodedPath: points as? String ?? "")
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = darkPinkColor
             if let path = path {
             let bounds = GMSCoordinateBounds(path: path)
             self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 78.0))
             polyline.map = self.mapView
              self.mapView.tintColor = .gray
             }
          }}})
      }
    }
  }
}
