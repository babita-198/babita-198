//
//  InfoCell.swift
//  FoodFox
//
//  Created by clicklabs on 21/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
  @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoName: UILabel! {
        didSet {
            infoName.font = AppFont.regular(size: 14)
        }
    }
}
