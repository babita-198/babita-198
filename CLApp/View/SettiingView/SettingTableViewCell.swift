//
//  SettingTableViewCell.swift
//  FoodFox
//
//  Created by Nishant Raj on 03/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

protocol NotificationChange: class {
    func changeNotification(type: Bool)
}

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var walletPriceLabel: UILabel! {
        didSet {
            walletPriceLabel.font = AppFont.semiBold(size: 14)
        }
    }
    
    weak var delegate: NotificationChange?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        delegate?.changeNotification(type: sender.isOn)
    }
    
}
