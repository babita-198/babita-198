//
//  AddressListViewController.swift
//  FoodFox
//
//  Created by Nishant Raj on 28/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

enum AddressAddingType {
  case addNew
  case editAddres
}


class AddressListViewController: UIViewController {

  //MARK: Outlets
  @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newAddressBtn: UIButton! {
        didSet {
          newAddressBtn.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 15)
        }
    }
  @IBOutlet weak var backBtn: UIButton!
    
  //MARK: Variables
   var restaurantId = ""
   var branchId = ""
   var addressId = ""
   var extraInfo = ""
   var addressList: [AddressModel] = []
   var addressAddingType: AddressAddingType = .addNew
   var totalPrice = 0.0
   var selectedIndex = 0
  
  //MARK: View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
      nextButton.setTitle("PROCEED".localizedString, for: .normal)
      newAddressBtn.setTitle("+ " + "ADD MORE ADDRESS".localizedString, for: .normal)
        tableView.rowHeight = UITableView.automaticDimension
      tableView.registerCell(Identifier.addressListCell)
      navTitle.text = "Delivery Location".localizedString
      self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      backBtn.changeBackBlackButton()
     tableView.backgroundView = LoadingTaskView.loadingTaskView(view: tableView)
    }
  
  //MARK: View Will Appear
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    getAllAddress()
  }

  
  @IBAction func backButtonAction(_ sender: UIButton) {
     self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: Next View Controller
  @IBAction func nextViewController(_ sender: UIButton) {
    if addressId != "" {
      let storyBoard = UIStoryboard(name: Identifier.paymentStoryBoard, bundle: nil)
      guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.paymentOptionViewController) as? PaymentOptionViewController else {
        fatalError("Could not load Controller")
      }
      vc.branchId = self.branchId
      vc.restaurantId = self.restaurantId
      vc.addressId = self.addressId
      vc.extraInfo = self.extraInfo
      self.navigationController?.pushViewController(vc, animated: true)
    } else {
        let alert = UIAlertController(title: "", message: "Please Select Address".localizedString, preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  // MARK: Add New Address
  @IBAction func newAddressAction(_ sender: UIButton) {
    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.saveAddressViewController) as? SaveAddressViewController else {
      fatalError("Could not load addressListViewController")
    }
    vc.extraInfo = self.extraInfo
    vc.addressAddingType = .addNew
    vc.branchId = self.branchId
    vc.restaurantId = self.restaurantId
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: Edit Address
     func editAddress(sender: Int) {
      guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.saveAddressViewController) as? SaveAddressViewController else {
        fatalError("Could not load addressListViewController")
      }
      vc.addressAddingType = .editAddres
      vc.addressDetail = addressList[sender]
      vc.branchId = self.branchId
      vc.restaurantId = self.restaurantId
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Delete Address
    func deleteAddress(sender: Int) {
        UIAlertController.presentAlert(title: nil, message: "Are you sure want to delete?".localizedString, style: .actionSheet).action(title: "Ok".localizedString, style: .destructive, handler: { (actions: UIAlertAction) in
            
            var param: [String: Any] = [:]
            param["addressId"] = self.addressList[sender].addressId ?? ""
            
            AddressModel.deleteAddress(parameters: param, callBack: {(response: Any?, error: Error?)in
              if error == nil {
                    self.getAllAddress()
                }
            })
            
        }).action(title: "Cancel".localizedString, style: .cancel, handler: nil)
    }
  
  // MARK: Get All Address
  func getAllAddress() {
    AddressModel.getAllAddress(callBack: {(list: [AddressModel]?, error: Error?) in
      if error != nil {
        return
      }
      guard let list  = list else {
        return
      }
      self.addressList = list
      if self.addressList.count == 0 {
        TableViewHelper.emptyMessage(message: "No Addresses found".localizedString, viewController: self.tableView)
        self.newAddressBtn.setTitle("+ " + "ADD NEW ADDRESS".localizedString, for: .normal)
      } else {
        self.addressId = self.addressList.first?.addressId ?? ""
        TableViewHelper.emptyMessage(message: "".localizedString, viewController: self.tableView)
        }
        self.tableView.backgroundView = nil
      self.tableView.reloadData()
    })
  }
}

//MARK: UITableView Delegate and data source
extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       addressId = addressList[indexPath.row].addressId ?? ""
       selectedIndex = indexPath.row
       self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addressListCell) as? AddressListCell else {
         fatalError("Could not load nib AddressListCell")
        }
      let address = addressList[indexPath.row]
      cell.homeButton.tag = indexPath.row
      cell.updateCell(address: address)
      cell.selectedAddress = { sender in
        self.editAddress(sender: sender)
      }
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteAddress = { sender in
            self.deleteAddress(sender: sender)
        }
        
      if selectedIndex == indexPath.row {
        cell.blurView.alpha = 0.3
      } else {
        cell.blurView.alpha = 0
      }
      return cell
    }
}
