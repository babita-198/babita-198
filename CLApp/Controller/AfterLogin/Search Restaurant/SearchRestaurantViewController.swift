
//
//  SearchViewController.swift
//  FoodFox
//
//  Created by socomo on 25/10/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit

class SearchRestaurantViewController: UIViewController {
    
    // MARK: - variables
    fileprivate var filtered: [RestaurantNear] = []
    fileprivate var searchActive: Bool = false
    fileprivate var restaurantList = [RestaurantNear]()
    var restaurantData: [RestaurantNear]? {
        didSet {
            guard let data = restaurantData else {
                return
            }
            restaurantList = data
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblNoRestaurant: UILabel! {
        didSet {
            lblNoRestaurant.font = AppFont.regular(size: 13)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionOfRestaurant: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
     @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBackgroundView: UIView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoRestaurant.isHidden = true
        self.collectionOfRestaurant.isHidden = false
        self.collectionOfRestaurant.register(UINib(nibName: "RestaurentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RestaurentCollectionViewCell")
      self.searchBar.delegate = self
      self.searchBar.placeholder = "Search restaurants".localizedString
      self.lblNoRestaurant.text = "No Restaurant Found".localizedString
      if restaurantList.count == 0 {
        self.lblNoRestaurant.isHidden = false
      }
        backBtn.changeBackBlackButton()
    }
    
    
    //MARK:- View will appear
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            self.topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.collectionOfRestaurant.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.searchBar.backgroundImage = UIImage()
            self.searchBar.barTintColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
           self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
            self.searchBackgroundView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.searchBackgroundView.bringSubviewToFront(self.lblNoRestaurant)
            self.lblNoRestaurant.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            self.topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.collectionOfRestaurant.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.searchBar.backgroundImage = UIImage()
            self.searchBar.barTintColor = lightWhite
            self.searchBar.backgroundColor = lightWhite
            self.backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
           self.searchBackgroundView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.searchBackgroundView.bringSubviewToFront(self.lblNoRestaurant)
            self.lblNoRestaurant.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        }
    }
    
    //MARK: - UIActions.
    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionViewDelegate and DataSource
extension SearchRestaurantViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive == false {
            return restaurantList.count
        } else {
            return filtered.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: RestaurentCollectionViewCell  = self.collectionOfRestaurant.dequeueReusableCell(withReuseIdentifier: "RestaurentCollectionViewCell", for: indexPath) as? RestaurentCollectionViewCell else {
            fatalError("Couldn't load RestaurentCollectionViewCell")
        }
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            cell.listView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.cardView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.restaurantNameView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.lineView.backgroundColor = lightGrayColor
            cell.restaurantName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.descriptionLabel.textColor = lightWhite
            cell.timeDurationView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.estimatedTimeLabel.textColor = lightWhite
            cell.deliveryChargesLabel.textColor = lightWhite
            cell.pricelabel.textColor = lightWhite
            
        } else {
            cell.listView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.restaurantNameView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lineView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.restaurantName.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.descriptionLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.timeDurationView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.estimatedTimeLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.deliveryChargesLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.pricelabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
        }
        if searchActive == false {
            cell.restaurantData = restaurantList[indexPath.row]
        } else {
            cell.restaurantData = filtered[indexPath.row]
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let viewcontroller = R.storyboard.home.restaurantMenuDetails() {
            if searchActive == false {
                if let restaurantId = restaurantList[indexPath.row].restaurantId {
                    viewcontroller.restaurantId = restaurantId
                }
            } else {
                if let restaurantId = filtered[indexPath.row].restaurantId {
                    viewcontroller.restaurantId = restaurantId
                }
            }
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension SearchRestaurantViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(Float(self.collectionOfRestaurant.frame.size.width)), height: 300)
    }
}

// MARK: - SearchBarDelegate
extension SearchRestaurantViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.length == 0 {
            filtered = restaurantList
            self.collectionOfRestaurant.isHidden = false
        } else {
            filtered = restaurantList.filter({(cusines: RestaurantNear) in
                return cusines.restaurantName?.lowercased().range(of: (searchText.lowercased())) != nil
            })
        }
        if filtered.count == 0 {
            searchActive = true
            self.collectionOfRestaurant.isHidden = true
            self.lblNoRestaurant.isHidden = false
        } else {
            searchActive = true
        }
        self.collectionOfRestaurant.reloadData()
    }
}
extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}
