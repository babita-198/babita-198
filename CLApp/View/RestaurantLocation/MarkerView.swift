//
//  MarkerView.swift
//  FoodFox
//
//  Created by socomo on 22/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import Kingfisher

class MarkerView: UIView {
    
    @IBOutlet weak var resturantImageView: UIImageView!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    // MARK: SetupView
    func setupView(image: String?) -> MarkerView {
        guard let viewToBeLoaded = Bundle.main.loadNibNamed("MarkerView", owner: self, options: nil)?.first as? MarkerView else {
            fatalError("View Not Found")
        }
        let imageUrl = URL(string: image ?? "")
        resturantImageView.kf.setImage(with: imageUrl)
        return viewToBeLoaded
    }
    
}
