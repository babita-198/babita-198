//
//  AvailabilityView.swift
//  FoodFox
//
//  Created by socomo on 18/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit

class AvailabilityView: UIView {
  
    // MARK: - IBOutlet
    @IBOutlet weak var availabilityTableView: UITableView!

   override func awakeFromNib() {
        super.awakeFromNib()
        availabilityTableView.rowHeight = 24
        self.availabilityTableView.registerCell("AvailabilityTableViewCell")
        availabilityTableView.delegate = self
        availabilityTableView.dataSource = self
    }
}

// MARK: - TableView Delegate and Data Source
extension AvailabilityView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuDetails.availabilityArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AvailabilityTableViewCell = self.availabilityTableView.dequeueReusableCell(withIdentifier: "AvailabilityTableViewCell") as? AvailabilityTableViewCell else {
            fatalError("Couldn't load AvailabilityTableViewCell")
        }
      let time = MenuDetails.availabilityArray[indexPath.row]
      if let startTime = time.startTime, let endTime = time.endTime, let day = time.day {
        cell.dateLabel.text = "\(day)  \(startTime) to \(endTime)"
      } else {
        cell.dateLabel.text = "\(time.day ?? "")  Closed".localizedString
      }
        return cell
    }
}
