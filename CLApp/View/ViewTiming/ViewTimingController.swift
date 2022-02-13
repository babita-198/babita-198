//
//  ViewTimingController.swift
//  FoodFox
//
//  Created by clicklabs on 16/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit

class ViewTimingController: UIViewController, UIGestureRecognizerDelegate {

  @IBOutlet weak var viewTimeTable: UITableView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var availabilityView: UIView!
  
  var availabilityArray: BranchAvailabilityData?
  var branchId: String?
  override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetUp()
       self.getTime()
    }
  
  
  //MARK:
  func getTime() {
    guard let id = branchId else {
      return
    }
    BranchAvailabilityData.getTime(bookingId: id, callBack: { (data: BranchAvailabilityData?, error: Error?) in
      if error == nil {
        if let data = data {
          self.availabilityArray = data
          self.viewTimeTable.reloadData()
            let statusString = getStatus(status: self.availabilityArray?.status ?? 0)
          self.statusLabel.text = statusString.localizedString
        }
      }
    })
  }
  
  //MARK: TableView SetUp
  func tableViewSetUp() {
    viewTimeTable.rowHeight = 30
    self.viewTimeTable.registerCell("AvailabilityTableViewCell")
    viewTimeTable.delegate = self
    viewTimeTable.dataSource = self
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped))
    tapGesture.delegate = self
    self.view.addGestureRecognizer(tapGesture)
  }
  
  //MARK: View Did Taped
  @objc func viewTaped() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view?.isDescendant(of: availabilityView) ?? false {
      return false
    }
    return true
  }
  
  //MARK: Cross Button
  @IBAction func crossBtn(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: UITableView Data Source and Delegate
extension ViewTimingController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return availabilityArray?.availabilityArray.count ?? 0
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: AvailabilityTableViewCell = self.viewTimeTable.dequeueReusableCell(withIdentifier: "AvailabilityTableViewCell") as? AvailabilityTableViewCell else {
      fatalError("Couldn't load AvailabilityTableViewCell")
    }
    let time = availabilityArray?.availabilityArray[indexPath.row]
    if let startTime = time?.startTime, let endTime = time?.endTime, let day = time?.day {
      cell.dateLabel.text = "\(day)  \(startTime) to \(endTime)"
    } else {
      cell.dateLabel.text = "\(time?.day ?? "")  Closed".localizedString
    }
    cell.backgroundColor = .clear
    cell.dateLabel.textColor = .white
    cell.dateLabel.backgroundColor = .clear
    return cell
  }
}
