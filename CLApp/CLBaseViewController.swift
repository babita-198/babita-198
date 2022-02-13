//
//  CLBaseViewController.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/3/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class CLBaseViewController: UIViewController {
  
  // open var menuItem: MenuViewModel? = nil;
  // Automatically created lazily with the view controller's title if it's not set explicitly.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if self.revealViewController() != nil {
      self.revealViewController().delegate = self
//      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //
    //    self.title = self.menuItem.title
    //
    //    // Do any additional setup after loading the view.
    //    var imageName: String = "ic_back"
    //    if self.revealViewController() != nil && (self.navigationController?.viewControllers.count == 1) {
    //      imageName = "iconSideMenu"
    //    }
    //    let navBar = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: self, action: #selector(CLBaseViewController.leftButtonClicked))
    //    self.navigationItem.leftBarButtonItem = navBar
  }
  
  
  //  // MARK: -
  //  @objc func leftButtonClicked() {
  //    if self.revealViewController() != nil && (self.navigationController?.viewControllers.count == 1) {
  //      self.revealViewController().revealToggle(animated: true)
  //      return
  //    } else {
  //      _  = self.navigationController?.popViewController(animated: true)
  //    }
  //  }
  //
}

// MARK: RevealController Delegate methods..
extension UIViewController: SWRevealViewControllerDelegate {
  
  // The following delegate methods will be called before and after the front view moves to a position
  public func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
    addImageViewOverController(revealPosition: position)
  }
  
  func addImageViewOverController(revealPosition: FrontViewPosition) {
    var imgView: UIButton! = self.view.viewWithTag(9988001) as? UIButton
    if imgView == nil {
      imgView = UIButton()
      imgView?.frame = self.view.bounds
      imgView?.tag = 9988001
      self.view.addSubview(imgView)
    }
    switch revealPosition {
    case .left:
      imgView?.isHidden = true
    case .right:
      imgView?.isHidden = true
    default:
      imgView?.isHidden = true
    }
  }
}
