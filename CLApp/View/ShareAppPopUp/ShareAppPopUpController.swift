//
//  ShareAppPopUpController.swift
//  FoodFox
//
//  Created by Anand Verma on 19/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

//MARK: Share App Enum
enum AppsIcon: Int, CaseCountable {
  case facebook
  case whatsApp
  case google
  case twitter
  
  var image: UIImage {
    switch self {
    case .facebook:
      return #imageLiteral(resourceName: "facebookIcon")
    case .whatsApp:
      return #imageLiteral(resourceName: "greenCall")
    case .google:
      return #imageLiteral(resourceName: "GoogleIcon")
    case .twitter:
     return #imageLiteral(resourceName: "ic_google")
    }
  }
}


class ShareAppPopUpController: UIViewController {

  //MARK: Outlet
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tapView: UIView!
  var tapGesture = UITapGestureRecognizer()

  override func viewDidLoad() {
        super.viewDidLoad()
     self.setUpCollectionView()
    }
  
  //MARK: SetUpCollectionView
  func setUpCollectionView() {
    collectionView.register(UINib(nibName: Identifier.shareAppCellCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifier.shareAppCellCollectionViewCell)
    collectionView.backgroundColor = UIColor.clear
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.reloadData()
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped))
    self.tapView.addGestureRecognizer(tapGesture)
  }
  
  // MARK: - View Canceled Notification
  @objc func viewTaped() {
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: Delegate and DataSource
extension ShareAppPopUpController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return AppsIcon.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 5, bottom: 8, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.shareAppCellCollectionViewCell, for: indexPath) as? ShareAppCellCollectionViewCell else {
      fatalError("Could not load ShareAppCellCollectionViewCell nib")
    }
    
    guard let selectionType = AppsIcon(rawValue: indexPath.section) else {
      fatalError()
    }
    
    cell.image.image = selectionType.image
    cell.backgroundColor = .clear
    return cell
  }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ShareAppPopUpController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 30, height: 30)
  }
}
