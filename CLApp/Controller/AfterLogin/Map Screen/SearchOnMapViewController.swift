//
//  SearchOnMapViewController.swift
//  FoodFox
//
//  Created by clicklabs on 23/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class SearchOnMapViewController: UIViewController {
  //MARK: Outlet
  @IBOutlet weak var markerImage: UIImageView!
  @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.titleLabel?.font = AppFont.semiBold(size: 14)
        }
    }
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var address: UILabel! {
        didSet {
           address.font = AppFont.semiBold(size: 14)
        }
    }
  @IBOutlet weak var currentBtn: UIButton!
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.font = AppFont.regular(size: 15)
        }
    }
  @IBOutlet weak var backBtn: UIButton!
  
  //MARK: Variable
  var addressString = ""
  var latitude = 0.0
  var longitude = 0.0
  var locationManager = CLLocationManager()
  var searchCallBack: ((Double, Double, String) -> Void)?

  override func viewDidLoad() {
    mapView.bringSubviewToFront(markerImage)
    mapView.bringSubviewToFront(submitButton)
    mapView.bringSubviewToFront(backButton)
//    mapView.bringSubview(toFront: viewTitle)
    mapView.bringSubviewToFront(currentBtn)
    self.addMapView()
    viewTitle.shadowPathCustom(cornerRadius: 5)
    submitButton.setTitle("SUBMIT".localizedString, for: .normal)
    locationLabel.text = "Location".localizedString
    backBtn.changeBackBlackButton()
    
    GMSServices.provideAPIKey(Keys.googleKey)
    GMSPlacesClient.provideAPIKey(Keys.googleKey)
    
  }
    
    
    @IBAction func lblAddress_Tap(_ sender: UITapGestureRecognizer) {
        let addressVC = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        addressVC.autocompleteFilter = filter
        addressVC.delegate = self
        self.present(addressVC,animated: true,completion: nil)
    }
  
  //MARK: BackButton
  @IBAction func backAction(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  //MARK: Get Current Location
  @IBAction func currentLocation(_ sender: UIButton) {
    let initialLocation: CLLocationCoordinate2D?
    initialLocation = CLLocationCoordinate2D(latitude: LocationTracker.shared.currentLocationLatitude, longitude: LocationTracker.shared.currentLocationLongitude)
    if let initialLocation = initialLocation {
      setUpMap(coordinates: initialLocation)
    }
  }
  
  //MARK: Submit Action
  @IBAction func submitAction(_ sender: UIButton) {
    if let callBack = searchCallBack {
      callBack(latitude, longitude, addressString)
      self.dismiss(animated: true, completion: nil)
    }
  }
}

extension SearchOnMapViewController: GMSMapViewDelegate {
  // MARK: - Add MapView
  func addMapView() {
    let initialLocation: CLLocationCoordinate2D?
      initialLocation = CLLocationCoordinate2D(latitude: LocationTracker.shared.currentLocationLatitude, longitude: LocationTracker.shared.currentLocationLongitude)
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
    if let initialLocation = initialLocation {
      setUpMap(coordinates: initialLocation)
    }
    
}
  
  // MARK : SetUp Map View
  func setUpMap(coordinates: CLLocationCoordinate2D?) {
    var camera: GMSCameraPosition?
    if let coordinates = coordinates {
      camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16.0)
    }
    currentCoordinates = coordinates
    if let camera = camera {
      mapView.camera = camera
    }
    mapView.isMyLocationEnabled = false
    mapView.delegate = self
  }
  
  
  // MARK: - MapViewDelegate
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    print(position.target.latitude)
    print(position.target.longitude)
    var updatedCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    updatedCoordinates.latitude = position.target.latitude
    updatedCoordinates.longitude = position.target.longitude
   
    let language = Localize.currentLang()
    var lang = "en"
    if language == .arabic {
        lang = "en"
    }
    let url =  "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(position.target.latitude),\(position.target.longitude)&key=\(Keys.googleKey)&language=\(lang)&sensor=true"
    TrackOrderModel.sendRequestToServer(baseUrl: url, "", httpMethod: "POST", isZipped: false) { (isSuccess, response) in
        print(response)
        if let address = response["results"] as? [[String: Any]], let data = address.first, let formatedAddess = data["formatted_address"] as? String {
            if let geoData = data["geometry"] as? [String: Any], let location = geoData["location"] as? [String: Any], let lat = location["lat"] as? Double, let long = location["lng"] as? Double {
             self.latitude = lat
             self.longitude = long
            }
                self.addressString = formatedAddess
                DispatchQueue.main.async {
                self.address.text = formatedAddess
            }
        }
    }
  }
  

    
  // MARK: - Api call
  func reverseGeocode(locationCoordinates: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(locationCoordinates) { [weak self]response, error in
      if let address = response?.firstResult() {
        print(address)
        guard self != nil else {
          return
        }
         self?.latitude = address.coordinate.latitude
         self?.longitude = address.coordinate.longitude
        if let lines = address.lines {
         self?.addressString = lines.joined(separator: " ")
         self?.address.text = lines.joined(separator: " ")
        }
      }
    }
  }
}

// MARK: LocationManager Delegate
extension SearchOnMapViewController: CLLocationManagerDelegate {
  
  private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = true
    }
  }
  private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if (manager.location?.coordinate) != nil {
      if let currentLocation = locations.first?.coordinate {
        currentCoordinates = currentLocation
        self.setUpMap(coordinates: currentLocation)
      }
      locationManager.stopUpdatingLocation()
    }
  }
}

extension SearchOnMapViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        setUpMap(coordinates: place.coordinate)
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
