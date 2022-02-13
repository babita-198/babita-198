      //
      //  SaveAddressViewController.swift
      //  FoodFox
      //
      //  Created by clicklabs on 30/11/17.
      //  Copyright © 2017 Click-Labs. All rights reserved.
      //

      import UIKit
      import MapKit
      import GoogleMaps
      import CoreLocation

      enum SaveAddressEnum: Int, CaseCountable {
        case textField = 0
        case buttonField
      }

  var currentCoordinates: CLLocationCoordinate2D?
  class SaveAddressViewController: UIViewController {
    
          // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveAddressButton: UIButton! {
        didSet {
        saveAddressButton.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var currentLocation: UIButton!
    
          // MARK: Variables
          var addressAddingType: AddressAddingType = .addNew
          var addressDetail: AddressModel?
          var centercoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
          var locationManager = CLLocationManager()
          var latitude = CLLocationDegrees()
          var longitude = CLLocationDegrees()
          var address = ""
          var addressTitle: Int = 1
          var addressLandmark: String = ""
          var country: String = ""
          var city: String = ""
          var zipCode = ""
          var restaurantId = ""
          var branchId = ""
          var addressId = ""
          var local = ""
          var isFromSideMenu = false
          var extraInfo = ""
    
    // MARK: View did load
          override func viewDidLoad() {
              super.viewDidLoad()
              localizedString()
              editAddress()
            mapView.bringSubviewToFront(backBtn)
            mapView.bringSubviewToFront(markerImageView)
            mapView.bringSubviewToFront(currentLocation)
              backBtn.changeBackRedButton()
              self.addMapView()
              registerNib()
              tableView.delegate = self
              tableView.dataSource = self
              tableView.estimatedRowHeight = 10
              tableView.reloadData()
           }

        // MARK : Register Nib
        func registerNib() {
        tableView.registerCell(Identifier.addressTextCell)
        tableView.registerCell(Identifier.addressTitleButtonCell)
        }
    
        //MARK : Localized String for SaveAddressViewController
        func localizedString() {
          if addressAddingType == .editAddres {
          saveAddressButton.setTitle("UPDATE & PROCEED".localizedString, for: .normal)
          } else {
          saveAddressButton.setTitle("SAVE & PROCEED".localizedString, for: .normal)
          }
        }
    
    override func viewDidLayoutSubviews() {
      mapView.padding = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 0)
    }
          //MARK: setText
          func setAddressText() {
            DispatchQueue.main.async {
                if self.addressAddingType != .editAddres {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    
    func getCurrentLocation() {
      if let current = currentCoordinates {
        setUpMap(coordinates: current)
      }
    }
    
    //MARK: Next Controller
      func nextController() {
        if isFromSideMenu {
          self.navigationController?.popViewController(animated: true)
        } else {
         let storyBoard = UIStoryboard(name: Identifier.paymentStoryBoard, bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.paymentOptionViewController) as? PaymentOptionViewController else {
          fatalError("Could not load Controller")
        }
        vc.extraInfo = self.extraInfo
        vc.branchId = self.branchId
        vc.restaurantId = self.restaurantId
        vc.addressId = self.addressId
        vc.isFromMap = true
       self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    
    //MARK:- CHECK STATUS OF DARK MODE
    func checkStatusForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            tableView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        } else {
            tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
        // MARK : Save Address Button Action
        @IBAction func saveAddressAction(_ sender: UIButton) {
          var param: [String: Any] = [:]
          param["address"] = self.address
          param["pinCode"] = zipCode
          param["city"] =  city + ", " + country
          if self.addressLandmark != "" {
          param["landMark"] = self.addressLandmark
          }
          param["addressType"] = self.addressTitle
          param["locationLat"] = latitude
          param["locationLong"] = longitude
            print(param)
          if addressAddingType == .editAddres {
            param["addressId"] = addressDetail?.addressId ?? ""
            AddressModel.updateAddress(parameters: param, callBack: {(response: Any?, error: Error?)in
              if error == nil {
                self.addressId = self.addressDetail?.addressId ?? ""
                self.nextController()
            }
            })
          } else {
          param["IsDefaultAddress"] = false
            print(param)
          AddressModel.saveAddress(parameters: param, callBack: {(response: String?, error: Error?)in
            if error == nil {
              if let id = response {
                self.addressId = id
                self.nextController()
              }
            }
          })
          }
        }
    
        // MARK : Edit Address
        func editAddress() {
          if let address = addressDetail?.address {
            self.address = address
          }
          if let zipCode = addressDetail?.pincode {
            self.zipCode = zipCode
          }
          if let city = addressDetail?.city {
            self.city = city
          }
          if let landMark = addressDetail?.landMark {
            self.addressLandmark = landMark
          }
          if let addressType = addressDetail?.addresType {
            self.addressTitle = addressType
          }
          if let locationLat = addressDetail?.latitute {
            self.latitude = locationLat
          }
          if let longitude = addressDetail?.longitute {
            self.longitude = longitude
          }
          
        }
    
    
    @IBAction func currentLocation(_ sender: Any) {
      getCurrentLocation()
      
    }
    
          // MARK : back Button Action
          @IBAction func backButtonAction(_ sender: UIButton) {
              self.navigationController?.popViewController(animated: true)

          }
    
      }


      //MARK: TableView Data Source and Delegate
      extension SaveAddressViewController: UITableViewDelegate, UITableViewDataSource {
        
          func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
              return 35
          }
        
          func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
              guard let sectionType = SaveAddressEnum(rawValue: section) else {
                  fatalError()
              }
              let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
              view.backgroundColor = .white
              let label: UILabel = UILabel()
              label.frame = CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: 35)
              label.font = AppFont.semiBold(size: 14)
              label.textColor = lightBlackColor
              if sectionType == .textField {
                  label.text = "Save delivery location".localizedString
                  view.addSubview(label)
              } else if sectionType == .buttonField {
                  label.text = "Save as".localizedString
                  view.addSubview(label)
              }
            
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            if isDarkMode == true {
            
                view.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                label.textColor = lightWhite
            
            } else {
               view.backgroundColor = headerLight
                label.textColor = lightBlackColor
                
                
            }

            
             return view
          }

        
        func numberOfSections(in tableView: UITableView) -> Int {
          return SaveAddressEnum.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          guard let sectionType = SaveAddressEnum(rawValue: indexPath.row) else {
            fatalError("Could not find enum value")
          }
          switch sectionType {
          case .textField:
            return UITableView.automaticDimension
          case .buttonField:
            return 50
          }
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          guard let sectionType = SaveAddressEnum(rawValue: indexPath
              .section) else {
            fatalError("Could not find enum value")
          }
          switch sectionType {
          case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addressTextCell) as? AddressTextCell else {
              fatalError("Could not load nib AddressTextCell")
            }
            
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            if isDarkMode == true {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.addressTextField.textColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.addressTextField.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.landmarkTextField.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.landmarkTextField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.addressTitle.textColor = lightWhite
                cell.landMarkTitle.textColor = lightWhite
            } else {
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.addressTextField.textColor =  #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.landmarkTextField.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.addressTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.landMarkTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            }
            
            cell.addressTextField.text = address
            cell.landmarkTextField.text = addressLandmark
            cell.textFieldCallBack = { (landMark) in
              self.addressLandmark = landMark
            }
            cell.textFieldAddressCallBack = { (addressTextField) in
              self.address = addressTextField
            }
            return cell
          case .buttonField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addressTitleButtonCell) as? AddressTitleButtonCell else {
              fatalError("Could not load nib AddressTitleButtonCell")
            }
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            if isDarkMode == true {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.homeButton.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.workButton.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.otherButton.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                cell.otherButton.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
                
            } else {
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.homeButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.workButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.otherButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.otherButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
            
            if let type = ButtonSelected(rawValue: addressTitle), addressAddingType == .editAddres {
              cell.buttonSelected = type
              cell.buttonUIChange()
            }
            cell.buttonCallback = { (value)in
              self.addressTitle = value
            }
            return cell
          }
        }
      }

      //MARK: GMSMapViewDelegate
      extension SaveAddressViewController: GMSMapViewDelegate {
          // MARK: - Add MapView
          func addMapView() {
            let initialLocation: CLLocationCoordinate2D?
            if addressAddingType == .editAddres {
            initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
              initialLocation = CLLocationCoordinate2D(latitude: LocationTracker.shared.currentLocationLatitude, longitude: LocationTracker.shared.currentLocationLongitude)
            }
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
              centercoordinates.latitude = position.target.latitude
              centercoordinates.longitude = position.target.longitude
              updatedCoordinates.latitude = position.target.latitude
             updatedCoordinates.longitude = position.target.longitude
            
            let language = Localize.currentLang()
            var lang = "en"
            if language == .english {
                lang = "en"
            }
            let url =  "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(position.target.latitude),\(position.target.longitude)&key=\(Keys.googleKey)&language=\(lang)&sensor=true"
            TrackOrderModel.sendRequestToServer(baseUrl: url, "", httpMethod: "POST", isZipped: false) { (isSuccess, response) in
                if let address = response["results"] as? [[String: Any]], let data = address.first, let formatedAddess = data["formatted_address"] as? String {
                    if let geoData = data["geometry"] as? [String: Any], let location = geoData["location"] as? [String: Any], let lat = location["lat"] as? Double, let long = location["lng"] as? Double {
                        self.latitude = lat
                        self.longitude = long
                    }
                    if self.addressAddingType != .editAddres {
                        self.address = formatedAddess
                    }
                    if let list = data["address_components"] as? [[String: Any]] {
                        for each in list {
                            if let array = each["types"] as? [String] {
                                
                                if array.contains("street_number") {
                                    self.local = each["long_name"] as? String ?? ""
                                }
                                if array.contains("locality") {
                                    self.city = each["long_name"] as? String ?? ""
                                }
                                if array.contains("country") {
                                    self.country = each["long_name"] as? String ?? ""
                                }
                                
                                if array.contains("postal_code") {
                                    self.zipCode = each["long_name"] as? String ?? ""
                                }
                            }
                        }
                    }
                    self.setAddressText()
                }
            }
            
            // reverseGeocode(locationCoordinates: updatedCoordinates)
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
                self?.address = lines.joined(separator: " ")
              }
              self?.setAddressText()
              self?.zipCode = address.postalCode ?? ""
              self?.city = address.locality ?? ""
              self?.country = address.country ?? ""
            }
          }
        }
      }

    // MARK: LocationManager Delegate
    extension SaveAddressViewController: CLLocationManagerDelegate {
      
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
