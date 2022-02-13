//
//  MyAddressController.swift
//  FoodFox
//
//  Created by soc-macmini-30 on 26/09/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class MyAddressController: CLBaseViewController {

  @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newAddressBtn: UIButton! {
        didSet {
            newAddressBtn.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var topView: UIView!
    
    //MARK: Variables
    var addressList: [AddressModel] = []
  
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var menuBtn: UIButton!
    override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
    changeConstraint(controller: self, view: topView)
    newAddressBtn.setTitle("+ " + "ADD MORE ADDRESS".localizedString, for: .normal)
        tableView.rowHeight = UITableView.automaticDimension
    tableView.registerCell(Identifier.addressListCell)
    navTitle.text = "My Addresses".localizedString
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    TableViewHelper.emptyMessage(message: "".localizedString, viewController: self.tableView)
    tableView.backgroundView = LoadingTaskView.loadingTaskView(view: tableView)
    getAllAddress()
    checkStatusForDarkMode()
    
  }
  
    
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            topView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.tableView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            self.navTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            menuBtn.setImage(UIImage(named: "menu-1"), for: UIControl.State.normal)
            bottomView.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            newAddressBtn.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
            newAddressBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            newAddressBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            topView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            menuBtn.setImage(UIImage(named: "menu"), for: UIControl.State.normal)
            self.tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             bottomView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            newAddressBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
             newAddressBtn.setTitleColor(#colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1), for: .normal)
             newAddressBtn.layer.borderColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
        }
        
    }
  @IBAction func backButtonAction(_ sender: UIButton) {
    let language = Localize.currentLang()
    if language == .arabic {
      self.revealViewController().rightRevealToggle(animated: true)
      return
    }
     self.revealViewController().revealToggle(animated: true)
  }
  
  
  // MARK: Add New Address
  @IBAction func addAddress(_ sender: Any) {
    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.saveAddressViewController) as? SaveAddressViewController else {
      fatalError("Could not load addressListViewController")
    }
    vc.isFromSideMenu = true
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: Edit Address
   func editAddress(sender: Int) {
    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: Identifier.saveAddressViewController) as? SaveAddressViewController else {
      fatalError("Could not load addressListViewController")
    }
    vc.addressDetail = addressList[sender]
    vc.addressAddingType = .editAddres
    vc.isFromSideMenu = true
    self.navigationController?.pushViewController(vc, animated: true)
  }
    
    //MARK: Delete Address
    func deleteAddress(sender: Int) {
        UIAlertController.presentAlert(title: nil, message: "Are you sure want to delete?".localizedString, style: .actionSheet).action(title: "Ok".localizedString, style: .destructive, handler: { (actions: UIAlertAction) in
            
            var param: [String: Any] = [:]
            param["addressId"] = self.addressList[sender].addressId ?? ""
            print(param)
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
        self.tableView.backgroundView = nil
      if error != nil {
        print("Something went wrong, Please try again")
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
        TableViewHelper.emptyMessage(message: "".localizedString, viewController: self.tableView)
        }
        self.tableView.backgroundView = nil
      self.tableView.reloadData()
    })
  }
}

extension MyAddressController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addressList.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addressListCell) as? AddressListCell else {
      fatalError("Could not load nib AddressListCell")
    }
    
    let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
    
    if isDarkMode == true {
        cell.homeName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
        cell.topAddressTitleView.backgroundColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
        cell.homeButton.setImage(#imageLiteral(resourceName: "ic_edit"), for: .normal)
       // cell.streetAddress.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
       
    } else {
        cell.homeName.textColor = #colorLiteral(red: 0.1926900744, green: 0.1959174871, blue: 0.2002623975, alpha: 1)
        cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.topAddressTitleView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
         cell.homeButton.setImage(#imageLiteral(resourceName: "gryedit"), for: .normal)
      
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
    
    return cell
  }
}
