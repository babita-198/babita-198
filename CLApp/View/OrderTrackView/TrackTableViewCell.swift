//
//  TrackTableViewCell.swift
//  FoodFox
//
//  Created by clicklabs on 13/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
  
  @IBOutlet weak var trackImage: UIImageView!
  @IBOutlet weak var statusName: UILabel!
  @IBOutlet weak var statusDescription: UILabel!
  @IBOutlet weak var statusTime: UILabel!
  @IBOutlet weak var circleView: UIView!
  @IBOutlet weak var lineView: UIView!
  @IBOutlet weak var blurView: UIView!
  
}


//MARK: Special Status
enum Driver: Int, CaseCountable {
  case driverFailed = 16
}

// MARK: Track Order Enum
enum OrderStatus: Int, CaseCountable {
  case unknown
  case orderPlaced
  case orderConfirmed
  case orderProcessed
  case orderReady
  
  var selectedImage: UIImage {
    switch self {
    case .unknown:
      return UIImage()
    case .orderPlaced:
      return #imageLiteral(resourceName: "orderPlcaedOn")
    case .orderConfirmed:
      return #imageLiteral(resourceName: "orderConfirmOn")
    case .orderProcessed:
      return #imageLiteral(resourceName: "orderProcessedOn")
    case .orderReady:
      return #imageLiteral(resourceName: "pickUpOn")
    }
  }
  
  var unSelectedImage: UIImage {
    switch self {
    case .unknown:
      return UIImage()
    case .orderPlaced:
      return #imageLiteral(resourceName: "orderPlcaedOn")
    case .orderConfirmed:
      return #imageLiteral(resourceName: "orderConfirmOn")
    case .orderProcessed:
      return #imageLiteral(resourceName: "orderProcessedOff")
    case .orderReady:
      return #imageLiteral(resourceName: "pickupOff")
    }
  }
  
  var statusName: String {
    switch self {
    case .unknown:
      return ""
    case .orderPlaced:
      return "Order Placed"
    case .orderConfirmed:
      return "Order Confirmed"
    case .orderProcessed:
      return "Ready for Pickup"
    case .orderReady:
      if bookingFlow == .pickup {
      return "Order Picked Up"
      } else {
        return "Ready for Delivery"
      }
    }
  }
  
  var statusDescription: String {
    switch self {
    case .unknown:
      return ""
    case .orderPlaced:
      return "We have received your order"
    case .orderConfirmed:
      return "Your order has been confirmed"
    case .orderProcessed:
      return "Please Approach the Counter"
    case .orderReady:
      if bookingFlow == .pickup {
      return "Please give food rating"
      } else {
      return "Your order is ready for delivery"
      }
    }
  }
}

// MARK: Status Enum
enum Status: Int, CaseCountable {
  case assigned = 0
  case stared = 1
  case completed = 2
  case failed = 3
  case inprogress = 4
  case unAssigned = 6
  case accepted = 7
  case decline = 8
  case cancel = 9
  case other = 5
  
  var value: Int {
    switch self {
    case .unAssigned:
      return 2
    case .accepted:
      return 4
    case .inprogress:
      return 5
    case .completed:
      return 5
    default:
      return 0
    }
  }
  
  var backendStatus: Int {
    switch self {
    case .unAssigned:
      return 17
    case .accepted:
      return 1
    case .inprogress:
      return 4
    case .completed:
      return 2
    default:
      return 0
    }
  }
  
}
