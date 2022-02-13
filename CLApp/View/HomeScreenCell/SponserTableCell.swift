//
//  SponserTableCell.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

//MARK: Case For Image Direction Movement
enum Direction {
  case forward
  case backword
}


class SponserTableCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var collectionSponser: UICollectionView!
    
   
    
    var currentIndex = 0
    let temIndex = 0
    var timer: Timer?
    var direction: Direction = .forward
  
    // MARK: - Varaibles
    var sponserList = [SponseredDetails]()
    var sponserCall: ((SponseredDetails?) -> Void)?
  
    override func awakeFromNib() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            self.collectionSponser.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            
        } else {
            self.collectionSponser.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: (#selector(SponserTableCell.timerFire)), userInfo: nil, repeats: true)
    }
  
    var sponsoredData: [SponseredDetails]? {
        didSet {
            guard let data = sponsoredData else {
                return
            }
            sponserList = data
            self.collectionSponser.reloadData()
        }
    }
}
// MARK: - CollectionViewDataSource
extension SponserTableCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponserList.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SponserCollectionCell = self.collectionSponser.dequeueReusableCell(withReuseIdentifier: "SponserCollectionCell", for: indexPath) as? SponserCollectionCell else {
            fatalError("Couldn't load SponserCollectionCell")
        }
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            cell.viewBg.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            
        } else {
            cell.viewBg.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        cell.sponserData = sponserList[indexPath.row]
        return cell
    }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let call = sponserCall {
      let sponser = sponserList[indexPath.row]
      call(sponser)
    }
  }
}

extension SponserTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 250)
    }
}

//MARK: Move Sponser Cell Automatic
// - timerFire called every 2 second to move the image in collection view

extension SponserTableCell {
  
  @objc private func timerFire() {

    if self.sponserList.count == 0 {
      return
    }
    
    let lastIndex = self.sponserList.count - 1
      if currentIndex < lastIndex {
          currentIndex += 1
      } else {
            currentIndex = 0
    }
    
    
    
   let indexPath = IndexPath(item: currentIndex, section: 0)
    if currentIndex == 0 {
      collectionSponser.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    } else {
      collectionSponser.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    }
}
