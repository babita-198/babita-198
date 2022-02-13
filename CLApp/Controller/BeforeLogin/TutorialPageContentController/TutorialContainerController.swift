//
//  TutorialContainerController.swift
//  CLApp
//
//  Created by click Labs on 7/17/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class TutorialContainerController: UIViewController {

// MARK: - Variables
    fileprivate var pageViewController: UIPageViewController?
    fileprivate var pageViewModel: PageViewModel?
    fileprivate var tutorialList = [TutorialData]()
    fileprivate var tutorialDetails = [TutorialDataDetails]()
    
// MARK: - IBOutlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionTutorial: UICollectionView!
    @IBOutlet weak var bottomBGaddressaddAddressAdView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var btnStarted: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTutorials()
        defaultSettings()
        btnStarted.setTitle("GET STARTED".localizedString, for: .normal)
        pageControl.isHidden = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
  
  // MARK: Default Setting
    func defaultSettings() {
        tutorialList = [TutorialData(title: "Tutorial1".localizedString, image: #imageLiteral(resourceName: "ic_tutorial1")),
                        TutorialData(title: "Tutorial2".localizedString, image: #imageLiteral(resourceName: "ic_tutorial1")),
                        TutorialData(title: "Tutorial3".localizedString, image: #imageLiteral(resourceName: "ic_tutorial1")),
                        TutorialData(title: "Tutorial4".localizedString, image: #imageLiteral(resourceName: "ic_tutorial1")),
                        TutorialData(title: "Tutorial4".localizedString, image: #imageLiteral(resourceName: "ic_tutorial1"))]
    }
    
  // MARK: - Api of get tutorial
    func getTutorials() {
        var param: [String: Any] = [:]
        param["limit"] = 1
        param["skip"] = 0
        LoginManagerApi.share.getTutorials(parameters: param) {(response: Any?, error: Error?)in
            if let data = response as? TutorialDetails {
                self.tutorialDetails = data.tutorialData
                self.pageControl.numberOfPages = self.tutorialDetails.count
                self.collectionTutorial.reloadData()
            }
        }
    }

// MARK: - UIActions
    @IBAction func actionGetStarted(_ sender: Any) {
      if let rootViewControllerNav = R.storyboard.main.chooseDeliveryController() {
         self.navigationController?.pushViewController(rootViewControllerNav, animated: true)
      }
    }
}

// MARK: - CollectionView Delegate and Data Source
extension TutorialContainerController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tutorialDetails.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: TutorialCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionCell", for: indexPath) as? TutorialCollectionCell else {
            fatalError("Couldn't load TutorialCollectionCell")
        }
        cell.tutorialData = tutorialDetails[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 55.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        pageControl.select(indexPath.row)
        return true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionTutorial.visibleCells  as [UICollectionViewCell] {
            if  let indexPath = collectionTutorial.indexPath(for: cell as UICollectionViewCell) {
                pageControl.currentPage = indexPath.row
                
            }
        }
    }
}
