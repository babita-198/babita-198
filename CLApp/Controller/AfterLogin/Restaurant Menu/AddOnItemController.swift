//
//  AddOnItemController.swift
//  FoodFox
//
//  Created by socomo on 14/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit


//MARK: - AddonView Delegate to add Addons of Item
protocol AddonDelegate: class {
    func addAddon(data: [String: Any])
}

protocol UpdateProce: class {
    func priceupdate(price: Double?, count: Int?)
    func contenSizeList(size: CGFloat)
}

class AddOnItemController: UIViewController {
    
    // MARK: - Variables
    fileprivate var addOnItemPrice: Double = 0.0
    var index = 0
    var section = 0
    var menu = [AddOn]()
    var itemName: String?
    var itemDescription: String?
    var price: Double?
    var cartItem: CartItem?
    var addedItem: [PerItem] = []
    var addons: [CartItemAddOn] = []
    var  menuId = ""
    var selectedRow = [IndexPath]()
    var selectedIndex = -1
    var singleSelectionBoll: Bool = false
    var typeSelect = ""
    weak var delegate: AddonDelegate?
    var defaultType = "0"
    // MARK:- IBOutlets
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            itemNameLabel.font = AppFont.regular(size: 20)
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = AppFont.regular(size: 18)
            priceLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var extraItemsTable: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton! {
        didSet {
            cancelBtn.titleLabel?.font = AppFont.bold(size: 20)
        }
    }
    @IBOutlet weak var okBtn: UIButton! {
        didSet {
            okBtn.titleLabel?.font = AppFont.bold(size: 20)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        singleSelectionBoll = false
        extraItemsTable.registerCell(Identifier.addOnCell)
        self.extraItemsTable.delegate = self
        self.extraItemsTable.dataSource = self
        
        print("addon items", menu)
        if let name = itemName {
            self.itemNameLabel.text = "Customize".localizedString + " \(name)"
        }
        
        if let description = itemDescription {
            self.priceLabel.text = "\(description)"
        }
        //        let sar = "Rs.".localizedString
        //        if let itemPrice = price {
        //            self.priceLabel.text = "\(sar) \(itemPrice)"
        //        }
        cancelBtn.setTitle("CANCEL".localizedString, for: .normal)
        okBtn.setTitle("CUSTOMIZE".localizedString, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            bottomView.backgroundColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            self.extraItemsTable.backgroundColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            
        } else {
            bottomView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.extraItemsTable.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }
        
    }
    
    
    
    // MARK: Add addons
    func addOnItem(cellIndex: Int, cellSection: Int) {
        let value = menu[cellSection].addOnItem[cellIndex]
        var addOnQuantityDic = [String: Any]()
        addOnQuantityDic["addOnid"] = value.id
        addOnQuantityDic["itemName"] = value.addOnItemName
        addOnQuantityDic["addOnPrice"] = value.price
        if let itemprice = value.price {
            self.addOnItemPrice += itemprice
            var priceGet  = itemprice
                UserDefaults.standard.set(priceGet, forKey: "priceFetch")
            
        }
        addedItem.append(PerItem(params: addOnQuantityDic))
    }
    
    // MARK: Remove Addons
    func removeaddOnItem(cellIndex: Int, cellSection: Int) {
        let value = menu[cellSection].addOnItem[cellIndex]
        if let itemprice = value.price {
            self.addOnItemPrice -= itemprice
        }
        if let index = addedItem.index(where: {$0.addOnItemId == value.id}) {
            addedItem.remove(at: index)
        }
    }
    
    //MARK:- UIActions
    @IBAction func actionCancel(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelPop"), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Add Addons Action
    @IBAction func actionOk(_ sender: Any) {
        let dict: [String: Any] = ["price": self.addOnItemPrice, "items": addedItem, "index": index, "section": section]
        delegate?.addAddon(data: dict)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UITableViewDelegate
extension AddOnItemController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


//MARK:- UITableViewDataSource
extension AddOnItemController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 8, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = self.menu[section].addOnCategory
        label.font = AppFont.bold(size: 14) // my custom font
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            
            headerView.backgroundColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            headerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            label.textColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            
        }
        
        
        headerView.addSubview(label)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].addOnItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: AddOnCell = self.extraItemsTable.dequeueReusableCell(withIdentifier: Identifier.addOnCell) as? AddOnCell else {
            fatalError("Couldn't load AddOnCell")
        }
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            cell.lblitem.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.priceLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.lblitem.textColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            
            cell.priceLabel.textColor = #colorLiteral(red: 0.2078222036, green: 0.2078569531, blue: 0.2078112364, alpha: 1)
            
            
        }
        let menu = self.menu[indexPath.section].addOnItem[indexPath.row]
        cell.checkBoxButton.tag = indexPath.row
        cell.lblitem.text = menu.addOnItemName
        let sar = "Rs.".localizedString
        if let price = menu.price {
            cell.priceLabel.text = "\(sar) \(price)"
            
//           var priceGet  = price
//            UserDefaults.standard.set(priceGet, forKey: "priceFetch")
        }
       // print("type checking", self.menu[indexPath.section].type)
        
        if indexPath.row == 0 && defaultType == "0"{
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioRedOn"), for: .normal)
            cell.checkBoxButton.isSelected = true
            addOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
           // typeSelect = "red"
            defaultType = "0"

           // self.selectedIndex = 0
        }else{
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
            cell.checkBoxButton.isSelected = false
        }
       if typeSelect == "red"{
    if indexPath.row == self.selectedIndex {
        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioRedOn"), for: .normal)
            }else {
             cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
             removeaddOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)

           // removeaddOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
        }
        }else{
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
        }
        
//        let typeCheck = self.menu[indexPath.section].type
//        if typeCheck == "single"{
//            if selectedRow.contains(indexPath) {
//                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioRedOn"), for: .normal)
//            } else {
//                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
//            }
//        } else {
//            if selectedRow.contains(indexPath) {
//                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "checkboxOnRed"), for: .normal)
//            } else {
//                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
//            }
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as? AddOnCell {
            let typeCheck = self.menu[indexPath.section].type
            typeSelect = "red"
            defaultType = "1"
        
            //self.selectedIndex = indexPath.row
            if self.selectedIndex == indexPath.row {
               self.selectedIndex = -1
                removeaddOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
            }else{
                self.selectedIndex = indexPath.row
                addOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
               }
            tableView.reloadData()
            
        }


}

}
    //        print("type check", typeCheck!)
//            if typeCheck == "single"{
//
//                if singleSelectionBoll == false {
//                    addOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
//                    cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioRedOn"), for: .normal)
//                    selectedRow.append(IndexPath(row: indexPath.row, section: indexPath.section))
//                    singleSelectionBoll = true
//                } else {
//                    if selectedRow.contains(IndexPath(row: indexPath.row, section: indexPath.section)) {
//                        if let checkedItemIndex = selectedRow.index(of: IndexPath(row: indexPath.row, section: indexPath.section)) {
//                            singleSelectionBoll = false
//                            removeaddOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
//                            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "radioOff"), for: .normal)
//                            selectedRow.remove(at: checkedItemIndex)
//                        }
//                    }
//
//                }
//
//            } else {
//                if selectedRow.contains(IndexPath(row: indexPath.row, section: indexPath.section)) {
//                    if let checkedItemIndex = selectedRow.index(of: IndexPath(row: indexPath.row, section: indexPath.section)) {
//                        removeaddOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
//                        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
//                        selectedRow.remove(at: checkedItemIndex)
//                    }
//                } else {
//                    addOnItem(cellIndex: indexPath.row, cellSection: indexPath.section)
//                    cell.checkBoxButton.setImage(#imageLiteral(resourceName: "checkboxOnRed"), for: .normal)
//                    selectedRow.append(IndexPath(row: indexPath.row, section: indexPath.section))
//                }
//
//
//
//            }
//
//        }
//    }
//
//}
