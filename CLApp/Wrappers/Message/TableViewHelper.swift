//
//  TableViewHelper.swift
//  FoodFox
//
//  Created by Nishant Raj on 06/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper {
    class func emptyMessage(message: String, viewController: UITableView) {
        let rect = CGRect(x: 0, y: 0, width: viewController.bounds.size.width, height: viewController.bounds.size.height)
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = lightBlackColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: fontStyleSemiBold, size: 17)
        messageLabel.sizeToFit()
        viewController.backgroundView = messageLabel
        viewController.separatorStyle = .none
    }
}
