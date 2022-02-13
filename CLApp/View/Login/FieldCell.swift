//
//  FieldCell.swift
//  CLApp
//
//  Created by cl-macmini-68 on 03/01/17.
//  Copyright © 2017 Hardeep Singh. All rights reserved.
//

import UIKit

class FieldCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet var textField: CLTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
  
}
