//
//  RestaurentTableCell.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class RestaurentTableCell: UITableViewCell {
    
    
    // MARK: - IBoutlets
    @IBOutlet weak var collectionRestaurent: UICollectionView!
    
    // MARK: - Variables
    fileprivate var width: Float = 0.00
    fileprivate var isGridSelected = false
    fileprivate var selectedIndex = 0
    var userLat = 0.0
    var userLong = 0.0
    var restaurantList = [RestaurantNear]()
    var parentView: HomeViewController?
    var restaurantData: [RestaurantNear]? {
        didSet {
            guard let data = restaurantData else {
                return
            }
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
               self.collectionRestaurent.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                
            } else {
                self.collectionRestaurent.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            restaurantList = data
            self.collectionRestaurent.reloadData()
        }
    }
    
    override func awakeFromNib() {
        self.collectionRestaurent.register(UINib(nibName: Identifier.restaurentCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifier.restaurentCollectionViewCell)
        self.collectionRestaurent.register(UINib(nibName: Identifier.gridCollectionView, bundle: nil), forCellWithReuseIdentifier: Identifier.gridCollectionView)
        NotificationCenter.default.addObserver(self, selector: #selector(gridSelected), name: NSNotification.Name(rawValue: "gridSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(listSelected), name: NSNotification.Name(rawValue: "listSelected"), object: nil)
        self.collectionRestaurent.delegate = self
    }
}

// MARK: - CollectionViewDelegate and DataSource
extension RestaurentTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
  
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantList.count
        
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridSelected == true {
            guard let cell: GridCollectionView  = self.collectionRestaurent.dequeueReusableCell(withReuseIdentifier: Identifier.gridCollectionView, for: indexPath) as? GridCollectionView else {
                fatalError("Couldn't load GridCollectionView")
            }
            
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                cell.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                cell.gridView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                cell.cardView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                cell.restaurantNameView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                cell.separatorView.backgroundColor = lightGrayColor
                cell.restaurantName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.imageBackgroundView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                cell.estimatedtime.textColor = lightWhite
                cell.deliveryChargesLabel.textColor = lightWhite
                cell.priceLabel.textColor = lightWhite
                cell.descriptionLabel.textColor = lightWhite
                cell.priceView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                cell.restaurantDescView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
           
                
            } else {
                cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.gridView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.restaurantNameView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.separatorView.backgroundColor = lightGrayColor
                cell.restaurantName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.imageBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.estimatedtime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.deliveryChargesLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.priceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.descriptionLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.priceView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.restaurantDescView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            cell.restaurantData = restaurantList[indexPath.row]
            collectionView.collectionViewLayout.invalidateLayout()
            return cell
        }
        guard let cell: RestaurentCollectionViewCell  = self.collectionRestaurent.dequeueReusableCell(withReuseIdentifier: Identifier.restaurentCollectionViewCell, for: indexPath) as? RestaurentCollectionViewCell else {
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
        cell.restaurantData = restaurantList[indexPath.row]
        collectionView.collectionViewLayout.invalidateLayout()
        print(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewcontroller = R.storyboard.home.restaurantMenuDetails() {
            viewcontroller.restaurantId = restaurantList[indexPath.row].restaurantId
            LoginManagerApi.share.selectedRestaurantDetail = restaurantList[indexPath.row]
            viewcontroller.userLat = self.userLat
            viewcontroller.userLong = self.userLong
            self.parentView?.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
}

extension RestaurentTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !isGridSelected {
            return CGSize(width: collectionView.bounds.size.width, height: 298)
        }
        return CGSize(width: (collectionView.bounds.size.width/2), height: 262)
    }
}

extension RestaurentTableCell {
    @objc func gridSelected() {
        isGridSelected = true
        collectionRestaurent.reloadData()
    }
    @objc func listSelected() {
        isGridSelected = false
        collectionRestaurent.reloadData()
    }
}
