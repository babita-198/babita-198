//
//  TutorialCollectionCell.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 13/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

struct TutorialData {
    var title: String
    var image: UIImage
}

class TutorialCollectionCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    // MARK: - Variable
    var tutorialData: TutorialDataDetails? {
        didSet {
            if let data = tutorialData {
                self.setData(tutorialData: data)
            }
        }
    }
    
    func setData(tutorialData: TutorialDataDetails) {
        self.lblDesc.text = tutorialData.description
        if let imageUrl = tutorialData.tutorialImaageUrl {
            self.imgBg.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        }
    }
}
