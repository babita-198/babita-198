    //
    //  HomeViewController.swift
    //  CLApp
    //
    //  Created by cl-macmini-68 on 17/12/16.
    //  Copyright © 2016 Hardeep Singh. All rights reserved.
    //
    import UIKit
    import GooglePlaces
    import GoogleMaps
    import CoreLocation
    //import MZFayeClient
   // import Hippo
    import CoreData

class HomeViewController: CLBaseViewController {

    @IBOutlet weak var advCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    // MARK: - IBOutlets
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var showHideBtn: UIButton!
    @IBOutlet weak var showOrHideLbl: UILabel! {
        didSet {
            showOrHideLbl.font = AppFont.regular(size: 11)
        }
    }
    @IBOutlet weak var advertisingLbl: UILabel! {
        didSet {
            advertisingLbl.font = AppFont.bold(size: 18)
        }
    }
    @IBOutlet weak var nearRestaurantCountLbl: UILabel! {
        didSet {
            nearRestaurantCountLbl.font = AppFont.bold(size: 18)
        }
    }
    @IBOutlet weak var pickUpOrderBtn: UIButton! {
        didSet {
            pickUpOrderBtn.titleLabel?.font = AppFont.bold(size: 20)
        }
    }
    @IBOutlet weak var homeDeliveryBtn: UIButton! {
        didSet {
            homeDeliveryBtn.titleLabel?.font = AppFont.bold(size: 20)
        }
    }

    var paymentTypes: [String] = []

    var timer: Timer!
    @IBOutlet weak var advView: UIView!
    @IBOutlet weak var topBtnStackView: UIStackView!
    @IBOutlet weak var advViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var addsViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet var filterBtn: UIButton!

    @IBOutlet var gridViewBtn: UIButton!
    @IBOutlet weak var tableHome: UITableView!
    @IBOutlet weak var viewHomeDelivery: UIView!
    @IBOutlet weak var viewPickup: UIView!
    @IBOutlet weak var imgHomeDelivery: UIImageView!

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var locationNearBtn: UIButton!
    @IBOutlet weak var locationArrowBtn: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!

    @IBOutlet weak var imgPickup: UIImageView!

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.font = AppFont.regular(size: 18)
        }
    }
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var restaurantCountDisplayView: UIView!

    @IBOutlet weak var addsView: UIView!
    var islocationOn = false
    // MARK: - Constants
    var count: Int = 0
    var state: Int = 0
    var arraySections = [HomeSection]()
    var sponserDetails = [SponseredDetails]()
    var discoverDetails = [DiscoverData]()
    var restaurantDetails = [RestaurantNear]()
    var newRestaurantDetails = [RestaurantNear]()
    var userlat = CLLocationDegrees()
    var userlong = CLLocationDegrees ()
    var isHomedelivery: Bool = true
    var isGridSelected = false
    var isShowOrHideSelected = false
    var selected: Int?

    var advertisementImagesArr  = [String]()

    //MARK: View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.methodOfReceivedNotification), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
        advertisementImagesArr = ["color1.jpg", "color2.jpg", "color3.jpg"]
        
        changeConstraint(controller: self, view: topView)
        
        self.title = self.menuItem.title
        if !islocationOn && LocationTracker.shared.currentLocationLatitude == 0.0{
        locationCheck()
        }else{
            self.userlat = LocationTracker.shared.currentLocationLatitude
            self.userlong = LocationTracker.shared.currentLocationLongitude
            self.getLocationAddress()
        }
       // self.userlat = LocationTracker.shared.currentLocationLatitude
       // self.userlong = LocationTracker.shared.currentLocationLongitude
        self.getLocationAddress()
        //self.openMenuController()
        tableHome.backgroundView = LoadingTaskView.loadingTaskView(view: tableHome)
        defaultSettings()
        localizedString()
        LocationTracker.shared.configLocation(fromSplash: false)
        self.navigationController?.navigationBar.isHidden = true
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        self.pageControl.currentPage = page
    }

    //MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(HomeViewController.customerLocationUpdateMethod), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: statusBarHeight))
            statusbarView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            view.addSubview(statusbarView)
            locationLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            menuBtn.setImage(UIImage(named: "menu-1"), for: UIControl.State.normal)
            logoImageView.image = UIImage(named: "LogoI")
            locationArrowBtn.setImage(UIImage(named: "war"), for: UIControl.State.normal)
            searchBtn.setImage(UIImage(named: "search"), for: UIControl.State.normal)
            locationNearBtn.setImage(UIImage(named: "map"), for: UIControl.State.normal)
            nearRestaurantCountLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            filterBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            gridViewBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            showOrHideLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            restaurantCountDisplayView.backgroundColor  = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            addsView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            advertisingLbl.textColor = lightWhite
            advView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            topBtnStackView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            advCollectionView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.tableHome.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.arrowImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.tableHome.reloadData()
            gridViewBtn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        } else {
            
            gridViewBtn.setImage(#imageLiteral(resourceName: "ic_grid"), for: .normal)
            menuBtn.setImage(UIImage(named: "menu"), for: UIControl.State.normal)
            logoImageView.image = UIImage(named: "ic_logo_small")
            locationArrowBtn.setImage(UIImage(named: "dropdown"), for: UIControl.State.normal)
            searchBtn.setImage(UIImage(named: "ic_search"), for: UIControl.State.normal)
            locationNearBtn.setImage(UIImage(named: "ic_maps"), for: UIControl.State.normal)
            topView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            locationLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            nearRestaurantCountLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            filterBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            gridViewBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            showOrHideLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            restaurantCountDisplayView.backgroundColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addsView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            advertisingLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            advView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            topBtnStackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            advCollectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.tableHome.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.tableHome.reloadData()
            self.arrowImageView.tintColor = UIColor.clear
        }
        addNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        firstTime = false
    }

    @objc func methodOfReceivedNotification( ) {
        print("notification calling")
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        if isDarkMode == true {
            gridViewBtn.setImage(#imageLiteral(resourceName: "ic_grid"), for: .normal)
            menuBtn.setImage(UIImage(named: "menu"), for: UIControl.State.normal)
            logoImageView.image = UIImage(named: "ic_logo_small")
            locationArrowBtn.setImage(UIImage(named: "dropdown"), for: UIControl.State.normal)
            searchBtn.setImage(UIImage(named: "ic_search"), for: UIControl.State.normal)
            locationNearBtn.setImage(UIImage(named: "ic_maps"), for: UIControl.State.normal)
            topView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            locationLabel.textColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            nearRestaurantCountLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            filterBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            gridViewBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            showOrHideLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            restaurantCountDisplayView.backgroundColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addsView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            advertisingLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            advView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            topBtnStackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            advCollectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.tableHome.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.tableHome.reloadData()
            self.arrowImageView.tintColor = UIColor.clear
            
        } else {
            gridViewBtn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
            topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            locationLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            menuBtn.setImage(UIImage(named: "menu-1"), for: UIControl.State.normal)
            logoImageView.image = UIImage(named: "LogoI")
            locationArrowBtn.setImage(UIImage(named: "war"), for: UIControl.State.normal)
            searchBtn.setImage(UIImage(named: "search"), for: UIControl.State.normal)
            locationNearBtn.setImage(UIImage(named: "map"), for: UIControl.State.normal)
            nearRestaurantCountLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            filterBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            gridViewBtn.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            showOrHideLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            restaurantCountDisplayView.backgroundColor  = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            addsView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            advertisingLbl.textColor = lightWhite
            advView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            topBtnStackView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            advCollectionView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.tableHome.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.arrowImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.tableHome.reloadData()
            
        }
        addNotifications()
    }

    //MARK: Localized String
    func localizedString() {
        
        self.arrowImageView.image = #imageLiteral(resourceName: "UP")
        self.showOrHideLbl.text = "Hide".localizedString
        locationLabel.text = "Getting address...".localizedString
        advertisingLbl.text = "Advertising".localizedString
        pickUpOrderBtn.setTitle("PICKUP ORDER".localizedString, for: UIControl.State.normal)
        homeDeliveryBtn.setTitle("HOME DELIVERY".localizedString, for: UIControl.State.normal)
    }

    //MARK: Get Location Address
    func getLocationAddress() {
        var updatedCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
        if self.userlat == 0.0 && self.userlong == 0.0 {
            updatedCoordinates.latitude = LocationTracker.shared.currentLocationLatitude
            updatedCoordinates.longitude = LocationTracker.shared.currentLocationLongitude
            self.userlat = LocationTracker.shared.currentLocationLatitude
            self.userlong = LocationTracker.shared.currentLocationLongitude
        } else {
            updatedCoordinates.latitude = self.userlat
            updatedCoordinates.longitude = self.userlong
        }
        let language = Localize.currentLang()
        var lang = "en"
        if language == .arabic {
            lang = "en"
        }
        let url =  "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(self.userlat),\(self.userlong)&key=\(Keys.googleKey)&language=\(lang)&sensor=true"
        TrackOrderModel.sendRequestToServer(baseUrl: url, "", httpMethod: "POST", isZipped: false) { (isSuccess, response) in
            print(response)
            if let address = response["results"] as? [[String: Any]], let data = address.first, let formatedAddess = data["formatted_address"] as? String {
                DispatchQueue.main.async {
                    self.locationLabel.text = formatedAddess
                }
            }
        }
        //self.reverseGeocode(locationCoordinates: updatedCoordinates)
    }

    // MARK: - Api call
    func reverseGeocode(locationCoordinates: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(locationCoordinates) { [weak self]response, error in
            if let address = response?.firstResult() {
                guard self != nil else {
                    return
                }
                if let lines = address.lines {
                    self?.locationLabel.text = lines.joined(separator: " ")
                }
            }
        }
    }

    //MARK:- customer location update
    @objc func customerLocationUpdateMethod( ) {
        
        let checkLoginStatus = UserDefaults.standard.bool(forKey: "LoginStatus")  // Retrieve the state
        
        if checkLoginStatus == true {
            print("check login status is true")
            updateLocation()
        } else {
            print("check login statusd is false")
        }
        
    //            print("timer run")
    }

    func updateLocation() {
        
        var param: [String: Any] = [:]
        
        param["latitude"] = userlat
        param["longitude"] = userlong
        print(param)
        RestaurantManager.share.customerLocationUpdate(parameters: param) { (response: Any?, error: Error?)in
            print("location", response as Any)
            
            if let response = response as? [String: Any] {
                
                if let status = response["statusCode"] as? Int {
                    
                    switch status {
                    case 200: break
                    case 401:
                        self.timer .invalidate()
                        self.timer = nil
                    default:
                        break
                    }
                }
            }
        }
    }

    // MARK: - Server Call for HomeDetails Data
    func homeDetailsApi(lat: CLLocationDegrees?, long: CLLocationDegrees?, categoryId: String?) {

    self.getLocationAddress()

    var param: [String: Any] = [:]

    if lat == 0.0 && long == 0.0 {
        param["latitude"] = LocationTracker.shared.currentLocationLatitude
        param["longitude"] = LocationTracker.shared.currentLocationLongitude
    } else {
        param["latitude"] = lat
        param["longitude"] = long
    }
    if categoryId != "" {
        param["categoryId"] = categoryId
    }
    param["limit"] = 10
    param["skip"] = 0
    param["sorting"] = 0
    if isHomedelivery {
        param["type"] = Type.delivery.rawValue
    } else {
        param["type"] = Type.pickup.rawValue
    }
    self.tableHome.backgroundView = LoadingTaskView.loadingTaskView(view: self.tableHome)
    RestaurantManager.share.homeScreen(parameter: param) {(response: Any?, error: Error?)in
        print(response as Any)
        self.tableHome.backgroundView = nil
        if let data = response as? Home {
            
            self.sponserDetails = data.sponsoredData
            
            print("sponser data have", self.sponserDetails.count)
            
            if self.sponserDetails.count != 0 {
                
                self.addsView.isHidden = false
                self.addsViewHeightConstarint.constant = 35
                self.tableViewTopConstarint.constant = 35
                
            } else {
                
                self.addsView.isHidden = true
                self.addsViewHeightConstarint.constant = 0
                self.tableViewTopConstarint.constant = -35
            }
            
            self.discoverDetails = data.discoverData
            
            self.count = data.restaurantNearToYouCount
            
            let str = "RESTAURANTS NEAR YOU".localizedString
            self.nearRestaurantCountLbl.text = "\(self.count) \(str) "
            
            self.gridViewBtn.isHidden = false
            if !self.isGridSelected {
                self.gridViewBtn.setImage(#imageLiteral(resourceName: "ic_grid"), for: .normal)
            } else {
                self.gridViewBtn.setImage(#imageLiteral(resourceName: "selectedgrid"), for: .normal)
            }
            
            self.restaurantDetails = data.restaurantNearToYou
            self.newRestaurantDetails = data.newRestaurant
            self.tableHome.reloadData()
            self.view.layoutIfNeeded()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableHome.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    }

    //MARK: Default Settings
    func defaultSettings() {
    self.tableHome.estimatedSectionHeaderHeight = 40.0
    if bookingFlow == .home {
        self.setupDeliveryViewAsPerType(type: .homeDelivery)
    } else {
        self.setupDeliveryViewAsPerType(type: .pickup)
    }
    setUpSections()
    }

    // MARK: Add Session Expire Notification
    func addNotifications() {

    //        NotificationCenter.default.removeObserver(self, name: Notification.Name.HTTPRequestStatus.unauthorized, object: nil)
    //        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.afterUnauthorized), name: Notification.Name.HTTPRequestStatus.unauthorized, object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.LoginManagerStatus.logout, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: Notification.Name.LoginManagerStatus.logout, object: nil)
    }

    @objc private func afterUnauthorized() {
    print("after un authorication notification calling")
    NotificationCenter.default.removeObserver(self, name: Notification.Name.LoginManagerStatus.logout, object: nil)
    LoginManagerApi.share.removeUserProfile()
    NotificationCenter.default.post(name: Notification.Name.LoginManagerStatus.logout, object: nil)
    }

    //MARK: User Did LogOut
    /// - call observer when user get loged out with access token expire and
    /// - with force loged out
    @objc func userDidLogout() {
    print("user did logout after un authorication notification calling")
    self.deleteAllRecords()
    //HippoConfig.shared.clearHippoUserData()
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

    //MARK: SetUp Section
    func setUpSections() {
    self.arraySections.removeAll()
    self.arraySections.append(.sponser)
    self.arraySections.append(.discover)
    self.arraySections.append(.newrestaurent)
    self.arraySections.append(.restaurent)
    }

    // MARK: - UIActions
    @IBAction func actionLocation(_ sender: Any) {
    let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
    guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.searchOnMapViewController) as? SearchOnMapViewController else {
        return
    }
    vc.searchCallBack = { (latitude, longitude, address) in
        self.userlat = latitude
        self.userlong = longitude
        self.locationLabel.text = address
        self.selected = -1
        self.homeDetailsApi(lat: self.userlat, long: self.userlong, categoryId: "")
        self.getLocationAddress()
    }
    self.present(vc, animated: true, completion: nil)
    }

    // MARK: Action for Location Search
    @IBAction func ationSearch(_ sender: Any) {
    if let viewController = R.storyboard.home.searchRestaurantViewController() {
        viewController.restaurantData = self.restaurantDetails
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    }

    // MARK: Open Map
    @IBAction func actionMap(_ sender: Any) {
    if let viewController = R.storyboard.home.mapViewController() {
        viewController.restaurantData = self.restaurantDetails
        viewController.location = self.locationLabel.text ?? ""
        viewController.userlat = self.userlat
        viewController.userlong = self.userlong
        viewController.changeLocalion = { (lat, long) in
            self.selected = -1
            self.homeDetailsApi(lat: lat, long: long, categoryId: "")
            self.userlat = lat
            self.userlong = long
            self.getLocationAddress()
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    }
    //MARK:- Filter btn Action
    @IBAction func filterAction(_ sender: Any) {
    }
    //MARK:- SHOW/HIDE BTN ACTION
    @IBAction func showOrHideAdvBtnAction(_ sender: UIButton) {

    if !isShowOrHideSelected == true {
        isShowOrHideSelected = true
        
        self.showOrHideLbl.text = "Show".localizedString
        self.arrowImageView.image = #imageLiteral(resourceName: "downImage")
        self.tableHome.reloadData()
    } else {
        self.tableHome.reloadData()
        isShowOrHideSelected = false
        
        self.arrowImageView.image = #imageLiteral(resourceName: "UP")
        self.showOrHideLbl.text = "Hide".localizedString
    }
    }
    // MARK: Change the Grid State
    @IBAction func actiongrid(_ sender: UIButton) {
    if self.state == 0 {
        self.state = 1
        sender.setImage(#imageLiteral(resourceName: "selectedgrid"), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gridSelected"), object: nil)
        isGridSelected = true
        tableHome.reloadData()
        tableHome.scrollsToTop = true
    } else {
        sender.setImage(#imageLiteral(resourceName: "ic_grid"), for: .normal)
        self.state = 0
        isGridSelected = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listSelected"), object: nil)
        tableHome.reloadData()
        tableHome.scrollsToTop = true
    }
    }
    //MARK: Set Reveal to Side Menu
    @IBAction func actionMenu(_ sender: Any) {
    let language = Localize.currentLang()
    if language == .arabic {
        self.revealViewController().rightRevealToggle(animated: true)
        return
    }
    self.revealViewController().revealToggle(animated: true)
    }
    //MARK: Change the Deviler and PickUp View State
    func setupDeliveryViewAsPerType(type: DeliveryType) {
    self.selected = -1
    if type == .homeDelivery {
        bookingFlow = .home
        
        self.isHomedelivery = true
        self.homeDetailsApi(lat: userlat, long: userlong, categoryId: "")
        
        homeDeliveryBtn.backgroundColor = UIColor(red: 198.0/255.0, green: 0.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        pickUpOrderBtn.backgroundColor = UIColor(red: 198.0/255.0, green: 0.0/255.0, blue: 60.0/255.0, alpha: 0.7)
        
    } else {
        bookingFlow = .pickup
        
        self.isHomedelivery = false
        self.homeDetailsApi(lat: userlat, long: userlong, categoryId: "")
        
        pickUpOrderBtn.backgroundColor = UIColor(red: 198.0/255.0, green: 0.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        homeDeliveryBtn.backgroundColor = UIColor(red: 198.0/255.0, green: 0.0/255.0, blue: 60.0/255.0, alpha: 0.7)
    }
    }

    //MARK: Action Home Delivery
    @IBAction func actionHomeDelivery(_ sender: Any) {
    self.setupDeliveryViewAsPerType(type: .homeDelivery)
    }

    // MARK: Action for PickUp
    @IBAction func actionPickup(_ sender: Any) {
    self.setupDeliveryViewAsPerType(type: .pickup)
    }

    //MARK: Push Through sponser
    func pushTroughSponser(data: SponseredDetails) {
    if let viewController = R.storyboard.home.restaurantMenuDetails() {
        if let restId = data.restaurentId {
            viewController.restaurantId = restId
            viewController.userLat = self.userlat
            viewController.isFromSponser = true
            viewController.userLong = self.userlong
            self.navigationController?.pushViewController(viewController, animated: true)
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
    // MARK: - TableViewDelegate and Data Source
    extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = HomeSection(rawValue: section) else {
            fatalError()
        }
        guard let cell: SectionCell = self.tableHome.dequeueReusableCell(withIdentifier: Identifier.selectionCell) as? SectionCell else {
            fatalError("Couldn't load SectionCell")
        }
        switch sectionType {
        case .restaurent:
            let str = "RESTAURANTS NEAR YOU".localizedString
            cell.lblLeftTitle.text = "\(count) \(str) "
            cell.lblLeftTitle.font = AppFont.regular(size: 13)
            cell.gridView.isHidden = false
            if !isGridSelected {
                cell.gridView.setImage(#imageLiteral(resourceName: "ic_grid"), for: .normal)
            } else {
                cell.gridView.setImage(#imageLiteral(resourceName: "selectedgrid"), for: .normal)
            }
        default: break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = HomeSection(rawValue: section) else {
            fatalError()
        }
        return sectionType == .restaurent ? 0 : 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = HomeSection(rawValue: indexPath.section) else {
            fatalError()
        }
        switch sectionType {
        case .sponser:
            if isShowOrHideSelected == false {
                return sponserDetails.count == 0 ? 0 : 250
            } else {
                return 0
            }
        case .discover:
            return discoverDetails.count == 0 ? 0 : 128
        case .restaurent:
            let count = self.restaurantDetails.count
            if !isGridSelected {
                return  CGFloat(count * 300)
            } else {
                return (count)%2 == 0 ?  CGFloat(count * 265/2) : CGFloat(((count - 1) * 265/2)+265)
            }
        case .newrestaurent:
            //let count = self.restaurantDetails.count
            return newRestaurantDetails.count == 0 ? 0 : 315
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    }
    // MARK: - TableViewDataSource
    extension HomeViewController: UITableViewDataSource {
    func locationCheck(){
               if !islocationOn && LocationTracker.shared.currentLocationLatitude == 0.0{
                   let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
                   guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.searchOnMapViewController) as? SearchOnMapViewController else {
                       return
                   }
                   vc.searchCallBack = { (latitude, longitude, address) in
                       self.userlat = latitude
                       self.userlong = longitude
                       LocationTracker.shared.currentLocationLatitude = latitude
                       LocationTracker.shared.currentLocationLongitude = longitude
                       self.locationLabel.text = address
                       self.selected = -1
                       self.homeDetailsApi(lat: self.userlat, long: self.userlong, categoryId: "")
                       self.getLocationAddress()
                   }
                   self.present(vc, animated: true, completion: nil)
                 }
           }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableHome.contentOffset.y >= tableHome.contentSize.height {
            if bookingFlow == .home {
                setupDeliveryViewAsPerType(type: .homeDelivery)
            } else {
               // setupDeliveryViewAsPerType(type: .pickup)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return arraySections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = HomeSection(rawValue: indexPath.section) else {
            fatalError()
        }
        if sectionType == .sponser {
            //Sponcer Cell
            guard let cell: SponserTableCell = self.tableHome.dequeueReusableCell(withIdentifier: Identifier.sponserTableCell) as? SponserTableCell else {
                fatalError("Couldn't load SponserTableCell")
            }
            cell.sponsoredData = self.sponserDetails
            cell.sponserCall = { sponserData in
                if let sponser = sponserData {
                    self.pushTroughSponser(data: sponser)
                }
            }
            return cell
        } else if sectionType == .discover {
            //Cuisine Cell Cell
            
            guard let cell: CuisineTableCell = self.tableHome.dequeueReusableCell(withIdentifier: Identifier.cuisineTableCell) as? CuisineTableCell else {
                fatalError("Couldn't load CuisineTableCell")
            }
            // Retrieve the state
            
            cell.discoverData = self.discoverDetails
            if let index = selected, index == -1 {
                cell.selectedIndex = index
            }
            cell.disCoverSelected = { (categoryId, index)in
                self.selected = index
                self.homeDetailsApi(lat: self.userlat, long: self.userlong, categoryId: categoryId)
            }
            return cell
        } else if sectionType == .restaurent {
            guard let cell: RestaurentTableCell = self.tableHome.dequeueReusableCell(withIdentifier: Identifier.restaurentTableCell) as? RestaurentTableCell else {
                fatalError("Couldn't load RestaurentTableCell")
            }
            cell.parentView = self
            cell.restaurantData = self.restaurantDetails
            cell.userLat = self.userlat
            cell.userLong = self.userlong
            cell.collectionRestaurent?.reloadData()
            return cell
        } else {
            guard let cell: NewRestaurentTableCell = self.tableHome.dequeueReusableCell(withIdentifier: Identifier.newRestaurentTableCell) as? NewRestaurentTableCell else {
                fatalError("Couldn't load RestaurentTableCell")
            }
            
            cell.parentView = self
            cell.restaurantData = self.newRestaurantDetails
            cell.userLat = self.userlat
            cell.userLong = self.userlong
            cell.collectionRestaurent?.reloadData()
            return cell
        }
    }
    }
