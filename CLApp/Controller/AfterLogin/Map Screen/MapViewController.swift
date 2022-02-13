//
//  MapViewController.swift
//  FoodFox
//
//  Created by socomo on 24/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Kingfisher
import MapKit

struct Place {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    // MARK: Variables
    fileprivate var markerView = MarkerView()
    fileprivate var places = [Place]()
    fileprivate var restaurantList = [RestaurantNear]()
    let autocompleteController = GMSAutocompleteViewController()
    var userlat = CLLocationDegrees()
    var userlong = CLLocationDegrees ()
    var location = ""
    var changeLocalion: ((Double, Double) -> Void)?
    var restaurantData: [RestaurantNear]? {
        didSet {
            guard let data = restaurantData else {
                return
            }
            restaurantList = data
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.font = AppFont.regular(size: 14)
        }
    }
    
    @IBOutlet weak var mapCollectionview: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerImageView: UIImageView!
     @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
     @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
     @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         self.mapView.delegate = self
        self.locationLabel.text = location
        self.mapCollectionview.register(UINib(nibName: Identifier.mapCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifier.mapCollectionViewCell)
         setUpMapOnSearch()
        showServiceProvidersOnMap(restaurantList)
        backBtn.changeBackBlackButton()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkStatusForDarkMode()
    }
    
    
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.searchView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.locationLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
            self.searchBtn.setImage(UIImage(named: "search"), for: .normal)
            self.cancelBtn.setImage(UIImage(named: "resturantW"), for: .normal)
            downArrowImageView.image = UIImage(named: "DownW")
        } else {
            self.topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.searchView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.locationLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
            self.searchBtn.setImage(UIImage(named: "ic_search"), for: .normal)
            self.cancelBtn.setImage(UIImage(named: "restaurant"), for: .normal)
             downArrowImageView.image = UIImage(named: "dropdown")
        }
    }
    
    
  
  //MARK: On Updating the Map View
  func setUpMapOnSearch() {
    self.addMapView()
    for iVar in restaurantList {
      if let lat = iVar.latitude, let long = iVar.longitude {
        places.append(Place(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)))
      }
    }
  }
  
  //MARK: Update Map on Seaching Restaurant Near by your location
  func updateMap() {
    var param: [String: Any] = [:]
    param["latitude"] = userlat
    param["longitude"] = userlong
    param["limit"] = 20
    param["skip"] = 0
    param["sorting"] = 0
    param["type"] = Type.delivery.rawValue
    RestaurantManager.share.homeScreen(parameter: param) {(response: Any?, error: Error?)in
      self.restaurantList.removeAll()
      if let data = response as? Home {
        self.restaurantData = data.restaurantNearToYou
        self.showServiceProvidersOnMap(self.restaurantList)
        self.setUpMapOnSearch()
        self.mapCollectionview.reloadData()
      }
    }
  }
  
    // MARK: - Add MapView
    func addMapView() {
        self.mapView.isMyLocationEnabled = false
        self.mapView.delegate = self
        let placeCamera = GMSCameraPosition.camera(withLatitude: userlat, longitude: userlong, zoom: 13)
       mapView.camera = placeCamera
      let placeMarker = GMSMarker()
      let lat = LocationTracker.shared.currentLocationLatitude
      let long = LocationTracker.shared.currentLocationLongitude
      placeMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
      placeMarker.icon = #imageLiteral(resourceName: "markerImage")
      placeMarker.map = mapView
      self.mapView.tintColor = .gray
    }
    
    // MARK: - Add MArker
    func addMarkers() {
        for resturant in restaurantList {
            let placeMarker = GMSMarker()
            if let latitude = resturant.latitude, let longitude = resturant.longitude {
              placeMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
              placeMarker.title = resturant.restaurantName
              placeMarker.snippet = resturant.restaurantDescription
            }
            markerView = markerView.setupView(image: resturant.logoImageUrl)
            placeMarker.icon = UIImage.init(view: markerView)
            placeMarker.userData = resturant
            placeMarker.map = mapView
       }
    }
    
  //MARK: Show service all providers on map, Parameter serviceProviders: Contains alll service providers object list
    func showServiceProvidersOnMap(_ restaurantDataArray: [RestaurantNear]) {
          if restaurantDataArray.count == 0 {
           self.mapView.clear()
           }
        for (index, restaurantValue) in restaurantDataArray.enumerated() {
            print(index)
          let restaurantMarker = GMSMarker()
          restaurantMarker.title = restaurantValue.restaurantName
          restaurantMarker.snippet = restaurantValue.restaurantDescription
          restaurantMarker.userData = index
            restaurantMarker.iconView = self.downloadImagesFromServer(restaurantValue)
            if let latitude = restaurantValue.latitude, let longitude = restaurantValue.longitude {
                restaurantMarker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            }
            restaurantMarker.map = mapView
        }
    }
    
   //MARK: Parameter provider: service provider object, Returns: return image of service provider
    func downloadImagesFromServer(_ currentRestaurant: RestaurantNear) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame.size.width =  30
        imageView.frame.size.height = 30
        imageView.cornerRadius = 8
        imageView.border(width: 1.5, color: UIColor.red, radius: 15)
        guard let image = currentRestaurant.logoImageUrl else {
            fatalError("Image Not Found")
        }
        let imageUrl = URL(string: image)
        imageView.kf.setImage(with: imageUrl, placeholder: R.image.mapMarker(), options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        return imageView
    }
  
  //MARK: Search Restaurent
  @IBAction func searchRestaurant(_ sender: UIButton) {
    if let viewController = R.storyboard.home.searchRestaurantViewController() {
      viewController.restaurantData = self.restaurantList
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }
  // MARK :- UIActions...
    @IBAction func actionBack(_ sender: Any) {
      if let call = changeLocalion {
        call(self.userlat, self.userlong)
      }
        _ = self.navigationController?.popViewController(animated: true)
    }
  
  // MARK: Action Location
    @IBAction func actionLocation(_ sender: Any) {
      let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
      guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.searchOnMapViewController) as? SearchOnMapViewController else {
        return
      }
      vc.searchCallBack = { (latitude, longitude, address) in
        self.userlat = latitude
        self.userlong = longitude
        self.locationLabel.text = address
        self.updateMap()
      }
      self.present(vc, animated: true, completion: nil)
    }
  
  // MARK: Restaurent Action Button
    @IBAction func actionButtonRestaurant(_ sender: Any) {
       if let call = changeLocalion {
         call(self.userlat, self.userlong)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionViewDelegate and CollectionViewDataSource
extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantList.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MapCollectionViewCell  = self.mapCollectionview.dequeueReusableCell(withReuseIdentifier: Identifier.mapCollectionViewCell, for: indexPath) as? MapCollectionViewCell else {
            fatalError("Couldn't load MapCollectionViewCell")
        }
        cell.restaurantData = restaurantList[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewcontroller = R.storyboard.home.restaurantMenuDetails() {
            if let restaurantId = restaurantList[indexPath.row].restaurantId {
                viewcontroller.restaurantId = restaurantId
                viewcontroller.userLat = self.userlat
                viewcontroller.userLong = self.userlong
            }
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.view.frame.size.width), height: 120)
    }
}


extension MapViewController {
//MARK: Did Tap the Info Window of Marker
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    if let viewcontroller = R.storyboard.home.restaurantMenuDetails() {
      guard let index = marker.userData as? Int else {
        return
      }
      if let restaurantId = restaurantList[index].restaurantId {
        viewcontroller.restaurantId = restaurantId
//        viewcontroller.userLat = restaurantList[index].latitude ?? 0.0
//        viewcontroller.userLong = restaurantList[index].longitude ?? 0.0
        viewcontroller.userLat = self.userlat
        viewcontroller.userLong = self.userlong
      }
      self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
  }
  
    //MARK: Marker Info Windows
  func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    if let infoWindow = Bundle.main.loadNibNamed(Identifier.customMarkerView, owner: self.view, options: nil), let window = infoWindow.first as? CustomMarkerView {
      window.restaurentDescriptiom.text = marker.snippet
      window.restaurentName.text = marker.title
      guard let index = marker.userData as? Int else {
        return UIView()
      }
      let indexPath = IndexPath(item: index, section: 0)
      self.mapCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      if let uslString = restaurantList[index].logoImageUrl {
       let imageUrl = URL(string: uslString)
       window.restaurantImage.kf.setImage(with: imageUrl)
      }
      return window
    }
    return UIView()
  }
}
