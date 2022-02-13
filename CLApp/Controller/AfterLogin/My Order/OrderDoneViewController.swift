//
//  OrderDoneViewController.swift
//  FoodFox
//
//  Created by clicklabs on 05/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
import CoreData
class OrderDoneViewController: UIViewController {
  
  // MARK: Outlets
    @IBOutlet weak var congratsLbl: UILabel! {
        didSet {
           congratsLbl.font = AppFont.bold(size: 35)
        }
    }
    @IBOutlet weak var successLbl: UILabel! {
        didSet {
            successLbl.font = AppFont.regular(size: 20)
        }
    }
    @IBOutlet weak var orderNumberLbl: UILabel! {
        didSet {
            orderNumberLbl.font = AppFont.regular(size: 20)
        }
    }
    @IBOutlet weak var trackButton: UIButton! {
        didSet {
            trackButton.titleLabel?.font = AppFont.semiBold(size: 20)
        }
    }
  
  // MARK: Variables
  var orderId = ""
  var bookingId = ""
  
   override func viewDidLoad() {
      super.viewDidLoad()
      localizedString()
      deleteAllRecords()
     trackButton.setTitle("TRACK ORDER".localizedString, for: .normal)
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

  //MARK: delete all records
  func deleteAllRecords() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    if #available(iOS 10.0, *) {
      let context = appDelegate.persistentContainer.viewContext
      
      let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
      do {
        try context.execute(deleteRequest)
        try context.save()
      } catch {
        print("Error")
      }
    }
  }

  
  //MARK: Localized String
  func localizedString() {
    congratsLbl.text = "Congratulations".localizedString
    successLbl.text = "Your order is placed successfully".localizedString
    let stringOrder = "Your order number is".localizedString
    let orderId = " \( self.orderId)"
    let myMutableString = NSMutableAttributedString(string: stringOrder, attributes: [NSAttributedString.Key.font: UIFont(name: fontNameRegular, size: 17) ?? UIFont.systemFontSize])
    let  orderIdString = NSMutableAttributedString(string: orderId, attributes: [NSAttributedString.Key.font: UIFont(name: fontStyleSemiBold, size: 17) ?? UIFont.systemFontSize])
    let combination = NSMutableAttributedString()
    combination.append(myMutableString)
    combination.append(orderIdString)
    orderNumberLbl.attributedText =  combination
  }

  // MARK: cross Button clicked
  @IBAction func crossClicked(_ sender: UIButton) {
    guard let controllers = self.navigationController?.viewControllers else {
        return
    }
    for controller in controllers {
        if controller.isKind(of: HomeViewController.self) {
         self.navigationController?.popToViewController(controller, animated: true)
        }
        if controller.isKind(of: ChooseDeliveryController.self) {
            let notificationName = Notification.Name("PaymentCancel")
            NotificationCenter.default.post(name: notificationName, object: nil)
            self.navigationController?.popToViewController(controller, animated: true)
        }
    }
  }
  // MARK: tackButtonClicked
  @IBAction func trackButtonClicked(_ sender: UIButton) {
    let storyBoard = UIStoryboard(name: Identifier.orderStoryBoard, bundle: nil)
    guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.trackOrderViewController) as? TrackOrderViewController else {
      return
    }
    vc.bookingId = self.bookingId
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
