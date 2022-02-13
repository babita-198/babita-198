//
//  HelpCenterViewController.swift
//  CLApp
//
//  Created by cl-macmini-68 on 17/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class HelpCenterViewController: CLBaseViewController {
  @IBOutlet weak var tableView: UITableView!
  
}

extension HelpCenterViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "TEST")
    return cell
  }

}
