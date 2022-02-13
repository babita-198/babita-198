//
//  AddressTitleButtonCell.swift
//  FoodFox
//
//  Created by clicklabs on 30/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

enum ButtonSelected: Int {
    case home = 1
    case work
    case other
    case unknown
    var statusValue: Int {
        switch self {
        case .home:
            return 1
        case .work:
            return 2
        case .other:
            return 3
        case .unknown:
            return 4
        }
    }
  
  var statusString: String {
    switch self {
    case .home:
      return "Home"
    case .work:
      return "Work"
    case .other:
      return "Other"
    case .unknown:
      return "Unknown"
    }
  }
  
  var statusImage: UIImage {
    
    switch self {
    case .home:
      return #imageLiteral(resourceName: "direc")
    case .work:
      return #imageLiteral(resourceName: "direc")
    case .other:
      return #imageLiteral(resourceName: "direc")
    case .unknown:
      return #imageLiteral(resourceName: "direc")
    }
  }
  
}

class AddressTitleButtonCell: UITableViewCell {
  
  // MARK: Outlet
    @IBOutlet weak var homeButton: UIButton! {
        didSet {
            homeButton.titleLabel?.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var workButton: UIButton! {
        didSet {
            workButton.titleLabel?.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var otherButton: UIButton! {
        didSet {
            otherButton.titleLabel?.font = AppFont.semiBold(size: 14)
        }
    }
  
  // MARK: Variables
  var buttonSelected: ButtonSelected = .home
  var buttonCallback: ((Int) -> Void)?
   
  override func awakeFromNib() {
        super.awakeFromNib()
     buttonUIChange()
    setLocalizationString()
  }
  
  
  // MARK: Set Localized String for AddressTitleButtonCell
  func setLocalizationString() {
    homeButton.setTitle(" "+"Home".localizedString, for: .normal)
    workButton.setTitle(" "+"Work".localizedString, for: .normal)
    otherButton.setTitle(" "+"Other".localizedString, for: .normal)
    
    let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    if isDarkMode == true {
        otherButton.setTitleColor(darkPinkColor, for: .selected)
        otherButton.setTitleColor(lightWhite, for: .normal)
        workButton.setTitleColor(darkPinkColor, for: .selected)
        workButton.setTitleColor(lightWhite, for: .normal)
        homeButton.setTitleColor(darkPinkColor, for: .selected)
        homeButton.setTitleColor(lightWhite, for: .normal)
    } else {
        otherButton.setTitleColor(darkPinkColor, for: .selected)
        otherButton.setTitleColor(UIColor.lightGray, for: .normal)
        workButton.setTitleColor(darkPinkColor, for: .selected)
        workButton.setTitleColor(UIColor.lightGray, for: .normal)
        homeButton.setTitleColor(darkPinkColor, for: .selected)
        homeButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    
    homeButton.setImage(#imageLiteral(resourceName: "ic_HomeUnselected"), for: .normal)
    homeButton.setImage(#imageLiteral(resourceName: "ic_Home"), for: .selected)
    workButton.setImage(#imageLiteral(resourceName: "ic_Work"), for: .normal)
    workButton.setImage(#imageLiteral(resourceName: "ic_workSelected"), for: .selected)
    otherButton.setImage(#imageLiteral(resourceName: "ic_Other"), for: .normal)
    otherButton.setImage(#imageLiteral(resourceName: "ic_OtherSelected"), for: .selected)
  }
  
  // MARK: Change Button State
    func buttonUIChange() {
        switch buttonSelected {
        case .home:
          homeButton.isSelected = true
          workButton.isSelected = false
          otherButton.isSelected = false
          let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
          if isDarkMode == true {
            homeButton.layer.borderColor = darkPinkColor.cgColor
            workButton.layer.borderColor = UIColor.white.cgColor
            otherButton.layer.borderColor = UIColor.white.cgColor
          } else {
            homeButton.layer.borderColor = darkPinkColor.cgColor
            workButton.layer.borderColor = UIColor.lightGray.cgColor
            otherButton.layer.borderColor = UIColor.lightGray.cgColor
          }
          

        case .work:
            homeButton.isSelected = false
            workButton.isSelected = true
            otherButton.isSelected = false
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            if isDarkMode == true {
                homeButton.layer.borderColor = UIColor.white.cgColor
                workButton.layer.borderColor = darkPinkColor.cgColor
                otherButton.layer.borderColor = UIColor.white.cgColor
            } else {
                homeButton.layer.borderColor = UIColor.lightGray.cgColor
                workButton.layer.borderColor = darkPinkColor.cgColor
                otherButton.layer.borderColor = UIColor.lightGray.cgColor
            }
           
            
        case .other:
            homeButton.isSelected = false
            workButton.isSelected = false
            otherButton.isSelected = true
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            if isDarkMode == true {
                homeButton.layer.borderColor = UIColor.white.cgColor
                workButton.layer.borderColor = UIColor.white.cgColor
                otherButton.layer.borderColor = darkPinkColor.cgColor
            } else {
                homeButton.layer.borderColor = UIColor.white.cgColor
                workButton.layer.borderColor = UIColor.white.cgColor
                otherButton.layer.borderColor = darkPinkColor.cgColor
            }
            
        default :
            homeButton.isSelected = false
            workButton.isSelected = false
            otherButton.isSelected = false
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            if isDarkMode == true {
                homeButton.layer.borderColor = UIColor.white.cgColor
                workButton.layer.borderColor = UIColor.white.cgColor
                otherButton.layer.borderColor = UIColor.white.cgColor
            } else {
                homeButton.layer.borderColor = UIColor.lightGray.cgColor
                workButton.layer.borderColor = UIColor.lightGray.cgColor
                otherButton.layer.borderColor = UIColor.lightGray.cgColor
            }
           
        }
    
    }
  
  
  @IBAction func homeAction(_ sender: UIButton) {
    buttonSelected = .home
    buttonUIChange()
    guard let call = buttonCallback else {
        return
    }
    call(buttonSelected.statusValue)
  }
  
  @IBAction func otherAction(_ sender: UIButton) {
    buttonSelected = .other
    buttonUIChange()
    guard let call = buttonCallback else {
        return
    }
    call(buttonSelected.statusValue)
  }
  
  @IBAction func workAction(_ sender: UIButton) {
    buttonSelected = .work
    buttonUIChange()
    guard let call = buttonCallback else {
        return
    }
    call(buttonSelected.statusValue)
  }
  
  
}
