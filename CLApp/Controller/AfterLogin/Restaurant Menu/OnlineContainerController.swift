//
//  OnlineContainerController.swift
//  FoodFox
//
//  Created by clicklabs on 29/01/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit
import CoreData

class OnlineContainerController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var collectionViewList: UICollectionView!
    @IBOutlet weak var tableViewList: UITableView!

    // MARK: - Variables
    fileprivate var isGridSelected: Bool?
    fileprivate var isSelectedIndex: Int = 0
    fileprivate var price: Double = 0.0
    fileprivate var itemQuantity: String = "1"
    fileprivate var quantity: Int = 0
    fileprivate var vat: String = "0"
    fileprivate var addedItem = [MenuQuantityDetails]()
    var state: Int = 1
    var lat: Double = 0.0
    var long: Double = 0.0
    var restaurantId: String?
    var branchId: String?
    var branchName: String?
    var restaurantMenu = [RestaurantMenu]()
    var restaurantMenuItems = [MenuItem]()
    var cartItems = [CartItem]()
    var minCost = 0.0
    var openStatus: Int?
    var pickupservice: Int?
    var isList: Bool = false
    weak var delegate: UpdateProce?
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.registerTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.actiongrid()
        self.getCart()
        self.setUI()
        checkStatusForDarkMode()
    }
    
    
    func checkStatusForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            
            collectionViewList.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            tableViewList.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
           
        } else {
            collectionViewList.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            tableViewList.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }
    
    func setUI() {
      if getStatusType(status: self.openStatus ?? -1) {
      self.deleteAllRecords()
      }
    }
    
    func actiongrid() {
        
        if self.state == 0 {
            self.collectionViewList.isHidden = true
            self.tableViewList.isHidden = false
            self.tableViewList.delegate = self
            self.tableViewList.dataSource = self
            self.tableViewList.reloadData()
        } else {
            self.collectionViewList.isHidden = false
            self.collectionViewList.delegate = self
            self.collectionViewList.dataSource = self
            self.tableViewList.isHidden = true
            self.collectionViewList.reloadData()
        }
    }
    
    
    //MARK: SetUp The Controller UI
    func setUpUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(cancelPop), name: NSNotification.Name(rawValue: "cancelPop"), object: nil)
    }
    
    
    //MARK:- Register TableView Cell
    /// -register tableView Cell and assign delegate and data Source
    /// -to the UITableView to load the Cell
    func registerTable() {
        tableViewList.registerCell(Identifier.menuCell)
        self.tableViewList.estimatedRowHeight = 120
        self.collectionViewList.register(UINib(nibName: Identifier.gridMenu, bundle: nil), forCellWithReuseIdentifier: Identifier.gridMenu)
    }
    
    // MARK: Cancel Addons Popup Notificaition
    @objc func cancelPop() {
        tableViewList.reloadData()
        collectionViewList.reloadData()
    }
}


//MARK :- collectionView Delegates and DataSource
extension OnlineContainerController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return restaurantMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        guard let cell: GridMenuCollectioncell  = self.collectionViewList.dequeueReusableCell(withReuseIdentifier: Identifier.gridMenu, for: indexPath) as? GridMenuCollectioncell else {
                fatalError("Couldn't load GridMenuCollectioncell")
            }
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            cell.backgroundContentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.restaurantItemName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.addButton.setImage(UIImage(named: "subW"), for: .normal)
            cell.substractBtn.setImage(UIImage(named: "addW"), for: .normal)
            cell.lblPrice.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.quantityLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.addBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            
        } else {
           cell.backgroundContentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.restaurantItemName.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.addButton.setImage(UIImage(named: "sub"), for: .normal)
            cell.substractBtn.setImage(UIImage(named: "add"), for: .normal)
            cell.quantityLabel.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.lblPrice.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.addBtn.setTitleColor(#colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1), for: .normal)
            
        }
            let restaurantItem = self.restaurantMenuItems[indexPath.row]
            cell.restaurantItemName.text = restaurantItem.itemName
            if let imageUrl = restaurantItem.menuImage {
                cell.itemImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
            }
            //cell.descriptionLabel.text = restaurantItem.description
            cell.descriptionLabel.isHidden = true
        if restaurantItem.addOns.count != 0 {
            print("addOns have")
            cell.customizeHeight.constant = 15
            
            cell.customizationLabel.isHidden = false
            cell.customizationLabel.text = "Customizations available".localizedString
        } else {
            cell.customizationLabel.isHidden = true
            cell.customizeHeight.constant = 0
            cell.priseTopConstraint.constant = 10
            
            print("addOns dont have")
        }
            cell.descriptionHeight.constant = 0
            cell.delegatePass = self
            cell.delegate = self
        
        
            cell.substractBtn.tag = indexPath.row
            cell.addButton.tag = indexPath.row
            cell.addBtn.tag = indexPath.row
            let  quantity = fetchSpecificCart(index: indexPath.row)
            if quantity != 0 {
                cell.addItemView.isHidden = false
                cell.addBtn.isHidden = true
                cell.addItemView.isHidden = getStatusType(status: openStatus ?? -1)
                cell.quantityLabel.text = "\(String(describing: quantity))"
            } else {
                cell.addItemView.isHidden = true
                cell.addBtn.isHidden = false
                //cell.addBtn.isHidden = getStatusType(status: openStatus ?? -1)
                
                if openStatus == 1 && pickupservice == 1 {
                    cell.addBtn.isHidden = false
                } else {
                    cell.addBtn.isHidden = true
                }
            }
             let sar = "Rs.".localizedString
            if let price = restaurantItem.price {
                cell.lblPrice.text = "\(sar) \(price)"
            }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


// MARK: - TableView Delegates
extension OnlineContainerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK :- TableView DataSource
extension OnlineContainerController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.contenSizeList(size: tableView.contentSize.height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MenuTableViewCell = self.tableViewList.dequeueReusableCell(withIdentifier: Identifier.menuCell) as? MenuTableViewCell else {
            fatalError("Couldn't load MenuTableViewCell")
        }
        
        let value = self.restaurantMenuItems[indexPath.row]
        if let itemName = value.itemName {
            cell.restaurantItemLabel.text = "\(itemName)"
        }
        cell.delegatePass = self
        cell.delegate = self
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            
            cell.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            cell.restaurantItemLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.addBtn.setImage(UIImage(named: "addW"), for: .normal)
            cell.substratBtn.setImage(UIImage(named: "subW"), for: .normal)
            cell.lblItemPrice.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.quantityLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.addButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            
        } else {
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.restaurantItemLabel.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.addBtn.setImage(UIImage(named: "add"), for: .normal)
            cell.substratBtn.setImage(UIImage(named: "sub"), for: .normal)
            cell.quantityLabel.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.lblItemPrice.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            cell.addButton.setTitleColor(#colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1), for: .normal)
            
        }
        if value.addOns.count != 0 {
            print("addOns have")
            
            cell.customizationLabel.isHidden = false
            cell.customizationLabel.text = "Customizations available".localizedString
        } else {
            cell.customizationLabel.isHidden = true
            cell.customizationHeight.constant = 0
            cell.priseTopConstarint.constant = 5
            
            print("addOns dont have")
        }
        
    
        cell.descriptionLabel.text = value.description
        cell.descriptionLabel.isHidden = true
        cell.descriptionHeight.constant = 0
        cell.substratBtn.tag = indexPath.row
        cell.addBtn.tag = indexPath.row
        cell.addButton.tag = indexPath.row
        let  quantity = fetchSpecificCart(index: indexPath.row)
        
        if quantity != 0 {
            cell.addItemView.isHidden = false
            cell.addButton.isHidden = true
            cell.addItemView.isHidden = getStatusType(status: openStatus ?? -1)
            cell.quantityLabel.text = "\(String(describing: quantity))"
        } else {
            cell.addItemView.isHidden = true
            cell.addButton.isHidden = false
            cell.addButton.isHidden = getStatusType(status: openStatus ?? -1)
        }
        
        if let imageUrl = value.menuImage {
            cell.itemImage.imageUrl(imageUrl: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        }
        cell.itemImage.isHidden = true
        
        if let price = value.price {
            let sar = "Rs.".localizedString
            cell.lblItemPrice.text = "\(sar) \(price)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantMenuItems.count
    }
}


extension OnlineContainerController: AddonDelegate {
    
    
    //MARK: Add Addons
    /// -call Addon Delegate tp add Addons with Items
    func addAddon(data: [String: Any]) {
        guard let menuDetails = data["items"] as? [PerItem], let index = data["index"] as? Int else {
            return
        }
        
        saveItemAndAddons(itemIndex: index, menuDetails: menuDetails)
    }
    
    // MARK: Save Cart to Core Data
    /// - add Item to cart
    /// - Check item already added or not
    /// -check item has addons or not'
    func saveItemAndAddons(itemIndex: Int, menuDetails: [PerItem]? ) {
        var isMatched: Bool = false
        if let items = fetchSpecificCartArray(index: itemIndex), items.count > 0 {
            for item in items {
                if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn] {
                    if let itemMenu = menuDetails, addons.count == itemMenu.count {
                        let addonArray = addons.filter { addonItem in
                            return itemMenu.contains { item in
                                item.addOnItemId == addonItem.adonId
                                
                            }
                        }
                        if addonArray.count == itemMenu.count {
                            isMatched = true
                            let quantity = item.itemQuantity + 1
                            for addon in addonArray {
                                let price = (addon.adonsPrice * Double(quantity))
                                addon.setValue(price, forKey: "adonsPrice")
                            }
                            item.setValue(quantity, forKey: "itemQuantity")
                            do {
                                try item.managedObjectContext?.save()
                            } catch {
                                
                            }
                            break
                        }
                    }
                }
            }
        }
        // when cart item is not exist in database
        /// -create in item Object in local Database
        if !isMatched {
            createNewObject(itemIndex: itemIndex, menuDetails: menuDetails)
        }
        getCart()
    }
    
    // MARK: Create new Object in CoreData
    ///if added item not matched local database stored item then add new item
    /// - create new item Object in existing database if item not found
    func createNewObject(itemIndex: Int, menuDetails: [PerItem]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "CartItem", in: managedContext) else {
                return
            }
            guard let managedObject = NSManagedObject(entity: entity, insertInto: managedContext) as? CartItem else {
                return
            }
            managedObject.itemName = restaurantMenuItems[itemIndex].itemName
            managedObject.itemPrice = restaurantMenuItems[itemIndex].price ?? 0.0
            managedObject.cartItemId = restaurantMenuItems[itemIndex].menuId
            managedObject.branchId = restaurantMenuItems[itemIndex].branchId
            managedObject.resturentId = restaurantId
            managedObject.itemQuantity = 1
            if let addons = menuDetails {
                for adon in addons {
                    guard let entityAddon = NSEntityDescription.entity(forEntityName: "CartItemAddOn", in: managedContext) else {
                        return
                    }
                    guard let object = NSManagedObject(entity: entityAddon, insertInto: managedContext) as? CartItemAddOn else {
                        return
                    }
                    object.adonId = adon.addOnItemId
                    object.adonName = adon.addOnItemName
                    object.adonsPrice = adon.price
                    managedObject.addToCartItemAddOns(object)
                }
            }
            do {
                try managedContext.save()
            } catch {
                
            }
        }
    }
    
    
    // MARK: delete Cart From Core Data
    /// delete the item from local database
    /// if data quantity has 1
    func deleteCart(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
            let result = try? managedContext.fetch(fetchRequest)
            guard let resultdata = result as? [CartItem] else {
                return
            }
            let menuId = restaurantMenuItems[index].menuId
            for object in resultdata {
                if object.cartItemId == menuId {
                    if object.itemQuantity == 1 {
                        managedContext.delete(object)
                    } else {
                        object.itemQuantity -= 1
                    }
                }
            }
            do {
                try managedContext.save()
            } catch {
                
            }
        }
        getCart()
    }
    
    // MARK: get all cart from Core Data
    ///- get all cart details from stored locally
    func getCart() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartItem")
            let result = try? managedContext.fetch(fetchRequest)
            guard let resultdata = result as? [CartItem] else {
                return
            }
            calculatePrice(cartList: resultdata)
        }
    }
    
    //MARK: Calculate Price
    ////- get Item from local database and Calculate the Price
    //// -Update the Cart Price List
    func calculatePrice(cartList: [CartItem]) {
        var totalQuantity = 0
        price = 0.0
        cartItems = cartList
        for item in cartList {
            if let addons = item.cartItemAddOns?.allObjects as? [CartItemAddOn] {
                let addonPrice = addons.reduce(0, {$0 + ($1.adonsPrice )})
                self.price += addonPrice
            }
            totalQuantity += Int(item.itemQuantity)
            self.price += (item.itemPrice * Double(item.itemQuantity))
        }
        delegate?.priceupdate(price: price, count: totalQuantity)
        tableViewList.reloadData()
        collectionViewList.reloadData()
        LoginManagerApi.share.promoAmount = 0.0
    }
    
    // MARK: Fetch Cart with Specific id for Core Data
    func fetchSpecificCartArray(index: Int) -> [CartItem]? {
        let menuId = restaurantMenuItems[index].menuId ?? ""
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let formatRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
            formatRequest.predicate = NSPredicate(format: "cartItemId == %@", menuId)
            let fetchedResults = try? managedContext.fetch(formatRequest)
            if let cartItem = fetchedResults {
                return cartItem
            }
        }
        return nil
    }
    
    
    // MARK: Fetch Specific Cart for Core Data
    func fetchSpecificCart(index: Int) -> Int {
        let menuId = restaurantMenuItems[index].menuId ?? ""
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let formatRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
            formatRequest.predicate = NSPredicate(format: "cartItemId == %@", menuId)
            let fetchedResults = try? managedContext.fetch(formatRequest)
            if let cartItem = fetchedResults {
                let addonPrice = cartItem.reduce(0, {$0 + ($1.itemQuantity )})
                return Int(addonPrice)
            }
        }
        return 0
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
                self.getCart()
            } catch {
                print("Error")
            }
        }
    }
}


extension OnlineContainerController: ViewAdd {
    
    //MARK:- CUSTOMIZE ADDONS FUNCTION
    func viewAddPopUp(_ tag: Int?) {
        
        print("addon have screen came")
        if let index = tag, restaurantMenuItems[index].addOns.count != 0 {
            if let nextVC = R.storyboard.home.addOnItemController() {
                
                nextVC.menu = restaurantMenuItems[index].addOns
                nextVC.itemName = restaurantMenuItems[index].itemName
                nextVC.itemDescription = restaurantMenuItems[index].description
                nextVC.menuId = restaurantMenuItems[index].menuId ?? ""
                nextVC.index = index
                nextVC.delegate = self
                if let price = restaurantMenuItems[index].price {
                    nextVC.price = price
                }
                nextVC.modalPresentationStyle = .overCurrentContext
                self.present(nextVC, animated: true, completion: nil)
                
            }
        }
    }
}


// MARK: - CollectionViewDelegateFlowLayout
extension OnlineContainerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionViewList.frame.size.width)/2) - 5, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.contenSizeList(size: collectionView.contentSize.height)
    }
}


extension OnlineContainerController: AddMenuItemDelegate {
    // MARK: Delete Delegate
    func deleteMenuItem(cellIndex: Int) {
        if let array = fetchSpecificCartArray(index: cellIndex), array.count > 1 {
            let alert = UIAlertController(title: "", message: "You have added different variations of this item. Please view cart to remove specific item.".localizedString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { action in
                
            }))
            alert.addAction(UIAlertAction(title: "View Cart".localizedString, style: .default, handler: { action in
                //self.nextController()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToViewCartVC"), object: nil, userInfo: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            deleteCart(index: cellIndex)
        }
    }
    
    // MARK: Add Delegate
    func addMenuItem(cellIndex: Int) {
        
        
        let isAddon = (restaurantMenu[isSelectedIndex].menuItem[cellIndex].addOns.count == 0)
        let firstItem = cartItems.first
        if ((firstItem?.resturentId != restaurantId) || (firstItem?.branchId != branchId)) && (cartItems.count != 0) {
            let alert = UIAlertController(title: "", message: "You had added items of different restaurant in cart. Are you sure you want to clear Cart ?".localizedString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { action in
                self.tableViewList.reloadData()
                self.collectionViewList.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .default, handler: { action in
                self.deleteAllRecords()
                if isAddon {
                    self.saveItemAndAddons(itemIndex: cellIndex, menuDetails: [])
                } else {
                    self.viewAddPopUp(cellIndex)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            if isAddon {
                self.saveItemAndAddons(itemIndex: cellIndex, menuDetails: [])
            } else {
                self.viewAddPopUp(cellIndex)
            }
        }
    }
    
    // MARK: Update Delegate
    func updateQuantity(quantity: String) {
        self.itemQuantity = quantity
    }
}
