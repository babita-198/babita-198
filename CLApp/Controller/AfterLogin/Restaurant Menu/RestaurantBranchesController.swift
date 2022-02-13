//
//  RestaurantBranchesController.swift
//  FoodFox
//
//  Created by socomo on 08/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class RestaurantBranchesController: UIViewController, SelectButton {
    
    // MARK: - IBOutlet
  @IBOutlet weak var restaurantBranchesTable: UITableView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var tableHeight: NSLayoutConstraint!
  @IBOutlet weak var outlet: UILabel!
  @IBOutlet weak var outletView: UIView!
  
    @IBOutlet var selectOutletBtn: UIButton!
    // MARK: - Variables
    var branchDetails = [BranchesDetails]()
    var restaurantId: String?
    var tapGesture = UITapGestureRecognizer()
    var lat: Double = 0.0
    var long: Double = 0.0
    let tableSize = 500
    let headerHeight = 40
    var restaurantDesc: String?
    var estimatedPreparationTime = 0.0
    var addNoteMessage = String()
    var minimumOrderValueFetch = Int()
   
    @IBOutlet var downArrowImageView: UIImageView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantBranchesTable.registerCell("RestaurantBranchesViewCellTableViewCell")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        downArrowImageView.isUserInteractionEnabled = true
        downArrowImageView.addGestureRecognizer(tapGestureRecognizer)
        
//        downArrowImageView.addGestureRecognizer(tapGesture)
//        downArrowImageView.isUserInteractionEnabled = true
        selectOutletBtn.addTarget(self, action: #selector(viewTaped), for: .touchUpInside)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped))
        self.backgroundView.addGestureRecognizer(tapGesture)
    }
  
  
  override func viewWillAppear(_ animated: Bool) {
    setUpTable()
    checkStatusOfDarkMode()
  }
  
    func checkStatusOfDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            self.outletView.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.restaurantBranchesTable.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.outlet.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.selectOutletBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.downArrowImageView.image = UIImage(named: "dwW")
        } else {
             self.outletView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             self.restaurantBranchesTable.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             self.outlet.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
             self.selectOutletBtn.setTitleColor(#colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1), for: .normal)
            self.downArrowImageView.image = UIImage(named: "dw-1")
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Setup Height of Table
    func setUpTable() {
        
        selectOutletBtn.setTitle("SELECT OUTLET".localizedString, for: .normal)
        outlet.text = "Select Outlet".localizedString
        restaurantBranchesTable.rowHeight = UITableView.automaticDimension
        restaurantBranchesTable.estimatedRowHeight = 220
    }
    
  // MARK: - View Canceled Notification
    @objc func viewTaped() {
        self.dismiss(animated: true, completion: nil)
    }
  
    //MARK: Get Direction of Branches
    func getDirection(_ tag: Int) {
        let location = self.branchDetails[tag]
        
        let lat: CLLocationDegrees = Double(location.lat)
        let long: CLLocationDegrees = Double(location.long)
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.branchDetails[tag].restaurantBranchName
        mapItem.openInMaps(launchOptions: nil)
    }
    
    
    //MARK:- Map Naigation
    func mapNavigation() {
        
    }
    
  //MARK: View Timing
  func viewTime(_ tag: Int) {
    let orderCancel = ViewTimingController(nibName: Identifier.viewTiming, bundle: nil)
    orderCancel.modalPresentationStyle = .overCurrentContext
    orderCancel.modalTransitionStyle = .crossDissolve
    orderCancel.branchId = self.branchDetails[tag].restaurantBranchesId
    self.present(orderCancel, animated: true, completion: nil)
  }
    
    // MARK: Call to Branch
    func call(_ tag: Int) {
        if let restaurantContactNo = branchDetails[tag].phoneNumber {
            let contactSupport = restaurantContactNo.trimmed()
            guard appDelegate.makePhoneCall(phoneNumber: contactSupport) else {
                customAlert(controller: self, message: "Not able to make phone call ".localizedString)
                return
            }
        }
    }
  
    
  //MARK: Selected Branch
  func selectedButton(_ tag: Int) {
        if let VC = self.presentingViewController {
            self.dismiss(animated: false) {
                if let viewController = R.storyboard.home.onlineMenuDetails() {
                    viewController.restaurantId = self.restaurantId
                    viewController.lat = self.lat
                    viewController.long = self.long
                    viewController.branchId = self.branchDetails[tag].restaurantBranchesId
                    viewController.branchName = self.branchDetails[tag].restaurantBranchName
                    viewController.restaurantDesc = self.restaurantDesc
                    viewController.estimatedPreparationTime = self.estimatedPreparationTime
                    self.addNoteMessage = self.branchDetails[tag].addNotMessage ?? ""
                    self.minimumOrderValueFetch  = self.branchDetails[tag].minimumOrderValue ?? 0
                    UserDefaults.standard.set(self.minimumOrderValueFetch, forKey: "minimumOrderValue")
                    UserDefaults.standard.set( self.addNoteMessage, forKey: "noteMessage")
                    VC.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}

// MARK: - TableView Delegate and DataSource
extension RestaurantBranchesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branchDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.restaurantBranchesTable.dequeueReusableCell(withIdentifier: "RestaurantBranchesViewCellTableViewCell") as? RestaurantBranchesViewCellTableViewCell else {
            fatalError("Couldn't load RestaurantBranchesViewCellTableViewCell")
        }
       
        cell.delegate = self
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            cell.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.distance.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.getDirection.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cell.lblBranchName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lblBranchAddress.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.phoneNumner.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.callBtn.setImage(UIImage(named: "call"), for: .normal)
            cell.cabImageView.image = UIImage(named: "cabw")
            cell.viewBackground.shadowPathCustomDark(cornerRadius: 5)
            
        } else {
            cell.viewBackground.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.distance.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.getDirection.setTitleColor(#colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1), for: .normal)
            cell.lblBranchName.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.lblBranchAddress.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.phoneNumner.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.callBtn.setImage(UIImage(named: "call"), for: .normal)
            cell.cabImageView.image = UIImage(named: "cab")
            cell.viewBackground.shadowPathCustom(cornerRadius: 5)
        }
        
        if bookingFlow == .pickup {
          let distance = self.branchDetails[indexPath.row].calculatedDistance.roundTo2Decimal()
          let km = "Km".localizedString
         cell.distance.text = "\(distance) \(km)"
        } else {
          cell.distance.isHidden = true
        }
        cell.callBtn.tag = indexPath.row
        cell.selectButton.tag = indexPath.row
        cell.getDirection.tag = indexPath.row
        let data = self.branchDetails[indexPath.row]
        cell.lblBranchName.text = data.restaurantBranchName
        cell.lblBranchAddress.text = data.restaurantBranchAddress
        cell.phoneNumner.text = data.phoneNumber ?? ""
    
        let minimumOrder: String = String(data.minimumOrderValue ?? 0)
        let addnote: String = String(data.addNotes ?? 0)
        if minimumOrder == ""{

        }else{
            cell.lblMinimumOrder.text = "Min. Order :  \(minimumOrder)"
           

        }
        
       
        if data.openingStatus == "1" && data.pickupservice == "1" {
            cell.lblStatus.text = "Open Now"
            cell.lblStatus.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else if data.openingStatus == "2" || data.pickupservice == "2" {
            cell.lblStatus.text = "Close Now"
            cell.lblStatus.textColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
        } else if data.openingStatus == "3" || data.pickupservice == "3" {
            cell.lblStatus.text = "Busy Now"
            cell.lblStatus.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let VC = self.presentingViewController {
            self.dismiss(animated: false) {
                if let viewController = R.storyboard.home.onlineMenuDetails() {
                    viewController.restaurantId = self.restaurantId
                    viewController.lat = self.lat
                    viewController.long = self.long
                    viewController.branchId = self.branchDetails[indexPath.row].restaurantBranchesId
                    viewController.branchName = self.branchDetails[indexPath.row].restaurantBranchName
                    viewController.restaurantDesc = self.restaurantDesc
                    viewController.estimatedPreparationTime = self.estimatedPreparationTime
                    self.addNoteMessage = self.branchDetails[indexPath.row].addNotMessage ?? ""
                    self.minimumOrderValueFetch  = self.branchDetails[indexPath.row].minimumOrderValue ?? 0
                    UserDefaults.standard.set(self.minimumOrderValueFetch, forKey: "minimumOrderValue")
                    UserDefaults.standard.set( self.addNoteMessage, forKey: "noteMessage")
                    VC.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if restaurantBranchesTable.contentSize.height > CGFloat(tableSize) {
            self.tableHeight.constant = CGFloat(tableSize)
        } else {
            self.tableHeight.constant = restaurantBranchesTable.contentSize.height
        }
    }

}
