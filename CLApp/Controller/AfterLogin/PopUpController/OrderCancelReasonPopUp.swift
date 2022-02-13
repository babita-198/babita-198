//
//  OrderCancelReasonPopUp.swift
//  FoodFox
//
//  Created by clicklabs on 11/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class OrderCancelReasonPopUp: UIViewController, UIGestureRecognizerDelegate {

  //MARK: Outlet
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dontCancelButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cancelView: UIView!
  
    //MARK: Variable
  var orderId = 0
  var bookingId = ""
  var selectedIndex = 0
  var orderSuccess: (() -> Void)?
  var reasonList: [OrderModel] = []
  
  //MARK: view did load
  override func viewDidLoad() {
    super.viewDidLoad()
    localizedString()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerCell(Identifier.popUpCancellationCell)
    tableView.estimatedRowHeight = 30
    cancellationReason()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped))
    tapGesture.delegate = self
    self.view.addGestureRecognizer(tapGesture)
    }
  
  
  @objc func viewTaped() {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view?.isDescendant(of: cancelView) ?? false {
      return false
    }
    return true
  }
  
  // MARK: Localized String
  func localizedString() {
    dontCancelButton.setTitle("DON'T CANCEL".localizedString, for: .normal)
    cancelButton.setTitle("CANCEL ORDER".localizedString, for: .normal)
    titleLabel.text = "Cancellation Reason".localizedString
  }
  
  
  // MARK: Selected Reason Action
func cancellationReason() {
    OrderModel.getCancellationReason(callBack: { (list: [OrderModel]?, error: Error?) in
        if error == nil {
            if let list = list {
            self.reasonList = list
             self.tableView.reloadData()
            }
        }
    })
  }
  // MARK: Don't cancel the order
  @IBAction func dontCancelOrder(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: Cancel the Order
  @IBAction func cancelOrderAction(_ sender: UIButton) {
    var reason = ""
    if  reasonList.count > 0 {
    if let string = reasonList[selectedIndex].cancellation {
        reason = string
      }
    }
    OrderModel.orderCancel(bookingId: bookingId, reason: reason, callBack: { (response: [String: Any]?, error: Error?) in
      if error == nil {
        guard let call = self.orderSuccess else {
          return
        }
        self.dismiss(animated: true, completion: nil)
        call()
      }
    })
  }
}

//MARK: TableView Delegate and Data Source
extension OrderCancelReasonPopUp: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 35
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.popUpCancellationCell) as? PopUpCancellationCell else {
            fatalError()
        }
        if let reason = reasonList[indexPath.row].cancellation {
          cell.label.text = reason
        }
        if indexPath.row == selectedIndex {
         cell.circleImage.image = #imageLiteral(resourceName: "radioOn")
        } else {
            cell.circleImage.image = #imageLiteral(resourceName: "radioOff")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
