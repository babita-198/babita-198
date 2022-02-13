//
//  SideMenuCell.swift
//  CLApp
//
//  Created by cl-macmini-68 on 17/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
  
    // MARK: - IBOutlet
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet var label: UILabel! {
        didSet {
            label.font = AppFont.regular(size: 20)
        }
    }
    @IBOutlet weak var lblBar: UILabel!
    
    @IBOutlet var menuItemImageView: UIImageView!
    // MARK: - Variable
    fileprivate var menuViewModel: MenuViewModel?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            
            backGroundView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
             self.label.textColor = UIColor.white
            
        } else {
            
            backGroundView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.label.textColor = UIColor.black
        }
        
       
    }
    
    
    func update(menuViewModel: MenuViewModel) {
        if let title = menuViewModel.title {
            self.label.text = title
            
        }
        if let image = menuViewModel.image {
            self.menuItemImageView.image = image
            
        }
    }
    
}
