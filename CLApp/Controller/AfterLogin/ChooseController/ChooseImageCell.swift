//
//  ChooseImageCell.swift
//  FoodFox
//
//  Created by anand kumar on 02/02/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class ChooseImageCell: UICollectionViewCell {

    @IBOutlet weak var imageBanner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Update Celll
    func updateImageCell(data: Banner) {
        if let imageUrl = data.imageUrl {
            self.imageBanner.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "foodstarPlaceholder"))
        }
    }
    
}

//MARK: Collection View Delegate - Data Source
extension ChooseDeliveryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseImageCell", for: indexPath) as? ChooseImageCell else {
            fatalError("Couldn't load TutorialCollectionCell")
        }
        cell.updateImageCell(data: tutorialDetails[indexPath.row])
        return cell
    }
}
