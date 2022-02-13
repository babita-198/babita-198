  //
  //  RestaurantMenuDetails.swift
  //  FoodFox
  //
  //  Created by socomo on 27/10/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //
  
  import Foundation
  import UIKit
  import GooglePlaces
  import MapKit
  import CoreLocation

  
  class RestaurantMenuDetails: UIViewController {
    
    // MARK: - Variables
    var restaurantId: String?
    fileprivate var latitude: CLLocationDegrees?
    fileprivate var longitude: CLLocationDegrees?
    var restaurantBranches = [BranchesDetails]()
    var contact: String?
    var deliveryPrice = 0.0
    var userLat = 0.0
    var userLong = 0.0
    var reviewCount = 0
    var isFromSponser = false
    var restaurantDesc: String?
    var estimatedPreparationTime = 0.0
    var addNoteMessage = String()
   // var minimumOrderValueFetch = String()
    var paymentTypes: [String] = []
    
    @IBOutlet var icCardImageView: UIImageView!
    @IBOutlet var icCarImage2View: UIImageView!
     @IBOutlet var icWalletImageView: UIImageView!
    
    // MARK: -  IBOutlets
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var restaurantReview: UILabel! {
        didSet {
            restaurantReview.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var restaurantImage: UIImageView!
    
    

    @IBOutlet weak var restaurantName: UILabel!
    
    //{
//        didSet {
//            restaurantName.font = AppFont.bold(size: 25)
//        }
//    }
    
    @IBOutlet weak var restaurantRating: UILabel! {
        didSet {
            restaurantRating.font = AppFont.regular(size: 14)
        }
    }
    
    @IBOutlet weak var restaurantDescription: UILabel!
//        {
//        didSet {
//            restaurantDescription.font = AppFont.regular(size: 16)
//        }
//    }
    
   
    @IBOutlet weak var deliveryTime: UILabel! {
        didSet {
            deliveryTime.font = AppFont.regular(size: 13)
        }
    }
    @IBOutlet weak var restaurantAddress: UILabel! {
        didSet {
            restaurantAddress.font = AppFont.regular(size: 16)
        }
    }
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var nextController: UIButton! {
        didSet {
            nextController.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var getLocationBtn: UIButton! {
        didSet {
            getLocationBtn.titleLabel?.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var deliveryCost: UILabel! {
        didSet {
            deliveryCost.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var deliveryCostTitle: UILabel! {
        didSet {
            deliveryCostTitle.font = AppFont.light(size: 13)
        }
    }
    @IBOutlet weak var minTime: UILabel! {
        didSet {
            minTime.font = AppFont.light(size: 12)
        }
    }
   
    @IBOutlet weak var addressTitle: UILabel! {
        didSet {
            addressTitle.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var openStatus: UILabel! {
        didSet {
            openStatus.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var openingStatus: UILabel! {
        didSet {
            openingStatus.font = AppFont.semiBold(size: 16)
        }
    }
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var blurViewTemper: UIView!
     @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewReview: UIView!
    @IBOutlet weak var scrollVW: UIScrollView!
   
    @IBOutlet weak var directionImage: UIImageView!
   
    @IBOutlet weak var timeImage: UIImageView!
     @IBOutlet weak var cabImage: UIImageView!
    @IBOutlet weak var rateImage: UIImageView!
   
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedString()
        backBtn.changeBackWhiteButton()
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        
        let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: statusBarHeight))
        statusbarView.backgroundColor = UIColor(red: 250/255, green: 140/255, blue: 05/255, alpha: 1.0)
        view.addSubview(statusbarView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(RestaurantMenuDetails.restaurantDiscTapFunction))
        restaurantDescription.isUserInteractionEnabled = false
        //restaurantDescription.addGestureRecognizer(tap)
    }
    // MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getRestaurantMenu()
        NotificationCenter.default.post(name: Notification.Name("dcds"), object: nil, userInfo:nil)
        self.checkStatusOfDarkMode()
      
    }
    
    //MARK:- DarkMode Check Status
    func checkStatusOfDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            mainView.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            scrollVW.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            //self.minOrder.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.minTime.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //self.minimumOrderValue.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.restaurantAddress.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.addressTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.deliveryCost.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.deliveryCostTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.deliveryTime.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.restaurantReview.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.getLocationBtn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.getLocationBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.viewReview.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.directionImage.image = UIImage(named: "direcW")
            self.rateImage.image = UIImage(named: "starW")
           // self.cashImage.image = UIImage(named: "cashw")
            self.timeImage.image = UIImage(named: "timew")
            self.cabImage.image = UIImage(named: "cabw")
           
        } else {
            mainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            scrollVW.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //self.minOrder.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.minTime.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            //self.minimumOrderValue.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.restaurantAddress.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.addressTitle.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.deliveryCost.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.deliveryCostTitle.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.deliveryTime.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.restaurantReview.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.viewReview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.getLocationBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.getLocationBtn.setTitleColor(#colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1), for: .normal)
            self.directionImage.image = UIImage(named: "direc")
            self.rateImage.image = UIImage(named: "star")
            //self.cashImage.image = UIImage(named: "cash")
            self.timeImage.image = UIImage(named: "time")
            self.cabImage.image = UIImage(named: "cab")
        }
        
    }
    
    
    
    
    @objc
    func restaurantDiscTapFunction(sender: UITapGestureRecognizer) {
       
        
       
        let alertVC = PMAlertController(title: "Description".localizedString, description: self.restaurantDescription.text ?? "", image: UIImage(named: ""), style: .walkthrough)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            alertVC.alertView.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            alertVC.alertDescription.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            alertVC.alertDescription.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            alertVC.alertActionStackView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            alertVC.alertView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            alertVC.alertDescription.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            alertVC.alertDescription.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            alertVC.alertActionStackView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        
        alertVC.addAction(PMAlertAction(title: "Cancel".localizedString, style: .cancel, action: { () -> Void in
            print("Cancel")
        }))
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    //MARK: Localized String
    func localizedString() {
        
        if bookingFlow == .pickup {
            minTime.text = "Preparation Time".localizedString
            deliveryCostTitle.text = "Distance".localizedString
        } else {
            minTime.text = "Delivery Time".localizedString
            deliveryCostTitle.text = "Delivery Cost".localizedString
        }
        //minOrder.text = "Min order".localizedString
        nextController.setTitle("VIEW ONLINE MENU".localizedString, for: .normal)
        getLocationBtn.setTitle("GET THE DIRECTIONS".localizedString, for: .normal)
        //getLocationBtn.setTitle("GET DIRECTIONS".localizedString + " >", for: .normal)
        addressTitle.text = "Address".localizedString
    }
    
    //MARK: Review Controller
    @IBAction func reviewController(_ sender: UIButton) {
        
        if reviewCount == 0 {
            return
        }
        let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.reviewController) as? ReviewViewController else {
            fatalError()
        }
        vc.restaurantId = self.restaurantId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Refer to friend
    @IBAction func referFriend(_ sender: UIButton) {
        self.shareLink()
    }
    
    //MARK: Share the link
    func shareLink() {
        var bookingType = Booking.home.rawValue
        if bookingFlow == .pickup {
            bookingType = Booking.pickUp.rawValue
        }
        guard let id = restaurantId else {
            return
        }
        let text = "https://api.foodfox.in/restaurant-detail/" + "\(id)/" + "\(self.latitude ?? 0.0)/" + "\(self.longitude ?? 0.0)/\(bookingType)"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- Api of get RestaurantMenu
    func getRestaurantMenu() {
        var param: [String: Any] = [:]
        param["restaurantId"] = self.restaurantId
        param["latitude"] = self.userLat
        param["longitude"] = self.userLong
        if bookingFlow == .home {
            param["bookingType"] = Booking.home.rawValue
        } else {
            param["bookingType"] = Booking.pickUp.rawValue
        }
        print("restaurantmenu params... \(param)")
        RestaurantManager.share.restaurantMenu(parameters: param) {(response: Any?, error: Error?)in
            //print(response as Any)
            if let data = response as? MenuDetails {
                self.updateUI(data: data)
            }
            //              guard  let viewAvailable = Bundle.main.loadNibNamed("AvailabilityView", owner: self, options: nil) else {
            //                  return
            //              }
            //              if let view = viewAvailable[0] as? AvailabilityView {
            //                  view.frame = CGRect(x: 0, y: 0, width: self.availabilityView.frame.width, height: self.availabilityView.frame.height)
            //                  self.availabilityView.addSubview(view)
            //              }
        }
    }
    
    
    //MARK: Update UI
    /// -get backend Data and Update UI Accordingly
    func updateUI(data: MenuDetails) {
        if let image = data.imageUrl, let review = data.reviews, let logoImage = data.logoImageUrl, let rating = data.rating {
            self.menuImage.imageUrl(imageUrl: image, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
              self.restaurantReview.text = "VIEW REVIEWS".localizedString  +  " (\(String(describing: review)))"
            //self.restaurantReview.text = "\(String(describing: review)) " + "Reviews".localizedString + ">"
            self.restaurantImage.imageUrl(imageUrl: logoImage, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
            self.restaurantImage.clipsToBounds = true
            self.restaurantRating.text = String(describing: rating.roundTo1Decimal())
            self.restaurantRating.backgroundColor = UIColor.ratingColor(rating: rating)
            
            
            
        }
        reviewCount = data.reviews ?? 0
        let sar = "Rs.".localizedString
        if data.restaurantBranches.count == 0 {
            self.nextController.alpha = 0.6
            self.restaurantAddress.text = data.address
            self.nextController.isUserInteractionEnabled = false
        } else {
            self.restaurantAddress.text = data.restaurantBranches.first?.restaurantBranchAddress
            self.nextController.alpha = 1
            self.nextController.isUserInteractionEnabled = true
//            addNoteMessage = data.restaurantBranches.first?.addNotMessage ?? ""
//            minimumOrderValueFetch = data.restaurantBranches.first?.minimumOrderValue ?? 0
//            UserDefaults.standard.set(minimumOrderValueFetch, forKey: "minimumOrderValue")
//            UserDefaults.standard.set(addNoteMessage, forKey: "noteMessage")
        }
        if bookingFlow == .pickup {
           // self.contactNo.text = data.phoneNo
            self.contact = data.phoneNo
        } else {
            //self.contactNo.text = data.restaurantBranches.first?.phoneNumber
            self.contact = data.restaurantBranches.first?.phoneNumber
        }
        if data.restaurantBranches.count == 0 {
           // self.contactNo.text = data.phoneNo
            self.contact = data.phoneNo
        }
        
        self.restaurantName.text = data.restaurantName
        self.restaurantDescription.text = data.description
        self.restaurantDesc = data.description
        
        //self.minimumOrderValue.text = "\(sar) \(0)"
        
        if let orderValue = data.minimumOrderValue {
            //self.minimumOrderValue.text = "\(sar) \(orderValue)"
        }
        
        if let time = data.estimateDeliveryTime {
            self.deliveryTime.text = "\(time)" + "Mins".localizedString
        }
        if let cost = data.deliveryCharge {
            self.deliveryPrice = cost
            self.deliveryCost.text = "\(sar) \(cost)"
        }
        self.latitude = data.lat
        self.longitude = data.long
        
        self.paymentTypes = data.paymentMethods
        
        print("payment cards ", self.paymentTypes)
      
        paymentTypesCheck()
        
        self.restaurantBranches = data.restaurantBranches
        let isOpen = getStatusType(status: data.openStatus ?? -1)
        let statusString = getStatusName(status: data.openStatus ?? -1)
        let statusStr = getStatus(status: data.openStatus ?? -1)
        
        print("opening status ", statusString)
        if statusString == "Open Now" {
             self.openStatus.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else if statusString == "Busy Now" {
             self.openStatus.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else if statusString == "Closed Now" {
            self.openStatus.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        self.openingStatus.text = statusString.localizedString
        self.openStatus.text = "  \(statusStr.localizedString)     "
        if isOpen {
            self.blurViewTemper.backgroundColor = .black
            self.blurViewTemper.isHidden = false
        } else {
            self.blurViewTemper.backgroundColor = .black
            self.blurViewTemper.isHidden = false
//            self.blurViewTemper.backgroundColor = .white
//            self.blurViewTemper.isHidden = true
        }
        
        //MARK: if User From Sponser show tha Branches
        if bookingFlow == .pickup {
            self.restaurantAddress.text = data.address
            if let estimatedTime = data.estimatedPreparationTime {
                let min = "Mins".localizedString
                self.deliveryTime.text = "\(estimatedTime) \(min)"
                self.estimatedPreparationTime = estimatedTime
            }
            if let deliveryCharges = data.calculatedDistance {
                let km = "Km".localizedString
                self.deliveryCost.text = "\(deliveryCharges.roundTo1Decimal()) \(km)"
            }
            if self.restaurantBranches.count == 0 {
               // self.contactNo.isHidden = true
               // self.callImage.isHidden = true
               // self.callButton.isHidden = true
                return
            }
            let status = !getStatusType(status: data.openStatus ?? -1)
            if status {
                openBranch()
            }
           // self.contactNo.isHidden = true
           // self.callImage.isHidden = true
            //self.callButton.isHidden = true
        } else {
            if data.openStatus == 2 {
               // self.contactNo.isHidden = true
               // self.callImage.isHidden = true
                //self.callButton.isHidden = true
            } else {
                //self.contactNo.isHidden = true
               // self.callImage.isHidden = true
                //self.callButton.isHidden = true
            }
        }
    }
    
    
    //MARK:- PAYMENT TYPE CHECK
    func paymentTypesCheck( ) {
        
        if paymentTypes.contains("1") && paymentTypes.contains("2") && paymentTypes.contains("4") {
            
            print("okay payment 1,2,4")
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = false
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("2") && paymentTypes.contains("3") {
            
            print("okay payment 1,2,3")
            self.icCardImageView.isHidden = false
            self.icWalletImageView.isHidden = true
            self.icCarImage2View.isHidden = false
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("2") {
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = true
            print("okay payment 1,2 ")
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("3") {
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = true
            print("okay payment 1,3")
            
        } else if paymentTypes.contains("1") && paymentTypes.contains("4") {
            
            print("okay payment 1,4")
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = false
            
        } else if paymentTypes.contains("2") && paymentTypes.contains("4") {
            
            print("okay payment 2,4")
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = false
            
        } else if paymentTypes.contains("2") && paymentTypes.contains("3") {
            
            print("okay payment 2,3")
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = true
            
        } else if paymentTypes.contains("1") {
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = false
            self.icWalletImageView.isHidden = true
            
            print("okay payment 1")
            
        } else if paymentTypes.contains("2") {
            
            self.icCardImageView.isHidden = false
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = true
            
            print("okay payment 2")
            
        } else if paymentTypes.contains("3") {
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = true
            
            print("okay payment 3")
            
        } else if paymentTypes.contains("4") {
            
            self.icCardImageView.isHidden = true
            self.icCarImage2View.isHidden = true
            self.icWalletImageView.isHidden = false
            print("okay payment 4")
            
        }
        
    }
    
    
    //MARK:- Map Naigation
    func mapNavigation() {
        
        let lat: CLLocationDegrees = Double(self.latitude ?? 0.0)
        let long: CLLocationDegrees = Double(self.longitude ?? 0.0)
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.restaurantName.text
        mapItem.openInMaps(launchOptions: nil)
    }
    
    
    //MARK:- UIActions
    @IBAction func actionViewOnlineMenu(_ sender: Any) {
        checkOut()
    }
    
    //MARK: Check Out
    func checkOut () {
        
        if self.restaurantBranches.count == 1 && bookingFlow == .home {
            if let viewController = R.storyboard.home.onlineMenuDetails() {
                viewController.restaurantId = self.restaurantId
                viewController.lat = self.userLat
                viewController.long = self.userLong
                viewController.branchId = restaurantBranches.first?.restaurantBranchesId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } else if self.restaurantBranches.count > 0 && bookingFlow == .pickup {
            self.openBranch ()
        }
        
    }
    
    
    // MARK: Open Branch
    func openBranch () {
        if let viewController = R.storyboard.home.restaurantBranchesController() {
            viewController.restaurantId = self.restaurantId
            viewController.branchDetails = self.restaurantBranches
            viewController.lat = self.userLat
            viewController.long = self.userLong
           viewController.estimatedPreparationTime = self.estimatedPreparationTime
            viewController.restaurantDesc = self.restaurantDesc
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    //MARK: Call to restaurent
//    @IBAction func actionCall(_ sender: Any) {
//        calltoRestaurant()
//    }
    
    // MARK: Call to Restaurant
    func calltoRestaurant() {
        
        if let restaurantContactNo = contact {
            let contactSupport = restaurantContactNo.trimmed()
            guard appDelegate.makePhoneCall(phoneNumber: contactSupport) else {
                customAlert(controller: self, message: "Not able to make phone call ".localizedString)
                return
            }
        }
        
    }
    
    
    // MARK: Get Direction Action
    @IBAction func actionGetDirections(_ sender: Any) {
        self.mapNavigation()
    }
    
    // MARK: BackButton Action
    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
  }
