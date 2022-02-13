//
//  ReviewViewController.swift
//  FoodFox
//
//  Created by Anand Verma on 08/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
  
  //MARK: Outlets
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 15)
        }
    }
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var backBtn: UIButton!
  @IBOutlet weak var topView: UIView!
     @IBOutlet weak var separatorView: UIView!
    //MARK: Variables
  var restaurantId = ""
  var skip = 0
  var limit = 10
  var reviewData: [ReviewModel] = []
  
  //MARK: View Did Load
    override func viewDidLoad() {
      super.viewDidLoad()
      self.setUpTableCell()
      self.getReview()
        navTitle.text = "All Reviews".localizedString
     backBtn.changeBackBlackButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    //MARK:- CHECK STATUS OF DARK MODE
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        
        if isDarkMode == true {
            topView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0, blue: 0.2352941176, alpha: 1)
            backBtn.setImage(UIImage(named: "newBack"), for: .normal)
            separatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            backBtn.setImage(UIImage(named: "ic_back"), for: .normal)
            tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            separatorView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            
        }
        
    }
    
    
    
    
  //MARK: SetUp TableView cell
  /// - register the Cell with Table View
  //

  func setUpTableCell() {
    tableView.backgroundView = LoadingTaskView.loadingTaskView(view: tableView)
    tableView.registerCell(Identifier.reviewCell)
    tableView.estimatedRowHeight = 100
  }
  
  //MARK: Back Button
  /// - Back Button Action to Pop the Controller
  @IBAction func backButtonAction(_ sender: UIButton) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: Message
  /// - Show Message when not data found
  //
  func showMessage(message: String) {
    TableViewHelper.emptyMessage(message: message, viewController: self.tableView)
  }
  
  //MARK: server call for Review
  /// - Get Review List For selected Restaurant
  func getReview() {
    ReviewModel.getReviewData(restaurantId: restaurantId, skip: skip, limit: limit, callBack: { (reviewList: [ReviewModel]?, error: Error?) in
      if error != nil {
        return
      }
      if let list = reviewList {
        self.reviewData = list
        self.tableView.backgroundView = nil
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
      }
      if self.reviewData.count == 0 {
        self.showMessage(message: "No review found".localizedString)
        self.tableView.backgroundView = nil
      } else {
        self.showMessage(message: "")
        self.tableView.backgroundView = nil
      }
    })
  }
}

//MARK: UITableView Delegate
/// - numberOfRowsInSection
/// - scrollViewDidEndDragging
extension ReviewViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviewData.count
  }
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if tableView.contentOffset.y >= tableView.contentSize.height {
       self.skip = reviewData.count
       self.getReview()
     }
  }
}

//MARK: UITableView DataSource
/// - dequeueReusableCell
extension ReviewViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.reviewCell) as? ReviewCell else {
      fatalError()
    }
    let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
    
    if isDarkMode == true {
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.reviewText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.restaurantName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.separatorView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.rateView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
    } else {
        cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.reviewText.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.restaurantName.textColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
        cell.separatorView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.rateView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    let review = reviewData[indexPath.row]
    cell.updateCell(reviewData: review)
    return cell
  }
}
