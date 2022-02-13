//
//  CuisineTableCell.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class CuisineTableCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var collectionCuisine: UICollectionView!
    @IBOutlet weak var trendingLbl: UILabel! {
        didSet {
            trendingLbl.font = AppFont.bold(size: 18)
        }
    }
    var disCoverSelected: ((String, Int) -> Void)?
    var selectedIndex: Int = -1
  
    // MARK: - Variables
    var discoverList = [DiscoverData]()
    var discoverData: [DiscoverData]? {
        didSet {
            guard let data = discoverData else {
                return
            }
            discoverList = data
            trendingLbl.text = "Trending".localizedString
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
            
            if isDarkMode == true {
                self.collectionCuisine.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                self.backgroundView?.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
                trendingLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            } else {
                self.collectionCuisine.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.backgroundView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                trendingLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            self.collectionCuisine.reloadData()
        }
    }
}
// MARK: - CollectionView DataSourceawake
extension CuisineTableCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverList.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CuisineCollectionCell = self.collectionCuisine.dequeueReusableCell(withReuseIdentifier: Identifier.cuisineCollectionCell, for: indexPath) as? CuisineCollectionCell else {
            fatalError("Couldn't load CuisineCollectionCell")
        }
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
           cell.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.discoverLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.discoverLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        cell.discoverData = discoverList[indexPath.row]
        cell.setupCell(selectedIndex: selectedIndex, indexPath: indexPath)
        return cell
    }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    collectionCuisine.reloadData()
    guard let id = discoverList[indexPath.row].categoryId else {
      return
     }
      if let selected = disCoverSelected {
       selected(id, indexPath.row)
     }
  }
}

// MARK: - CollectionViewDelegateFlowLayout
extension CuisineTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
}
