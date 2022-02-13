//
//  OnlineMenuController.swift
//  FoodFox
//
//  Created by socomo on 04/11/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class OnlineMenuDetails: UIViewController, UpdateProce {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewList: UICollectionView!
    @IBOutlet weak var resaurantImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel! {
        didSet {
            headerTitle.font = AppFont.semiBold(size: 18)
        }
    }
    
    @IBOutlet var restaurantNameLbl: UILabel! {
        didSet {
            headerTitle.font = AppFont.semiBold(size: 16)
        }
    }
    
    @IBOutlet weak var gridBtn: UIButton!
    
    @IBOutlet weak var menuViews: UIView!
    @IBOutlet weak var resaurantLogoImage: UIImageView!
    @IBOutlet weak var resaurantCollectionMenu: UICollectionView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var numberOfItemsLabel: UILabel! {
        didSet {
            numberOfItemsLabel.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = AppFont.regular(size: 12)
        }
    }
    @IBOutlet weak var reviewLabel: UILabel! {
        didSet {
            reviewLabel.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartCheckOutView: UIView!
    @IBOutlet weak var viewCart: UIButton! {
        didSet {
            viewCart.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var statusName: UILabel! {
        didSet {
            statusName.font = AppFont.regular(size: 14)
        }
    }
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var subCategoryProductsContainer: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var blurViewTemper: UIView!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    fileprivate var isGridSelected: Bool?
    fileprivate var isSelectedIndex: Int = 0
    fileprivate var state: Int = 1
    fileprivate var price: Double = 0.0
    fileprivate var itemQuantity: String = "1"
    fileprivate var quantity: Int = 0
    fileprivate var vat: String = "0"
    fileprivate var addedItem = [MenuQuantityDetails]()
    var lat: Double = 0.0
    var long: Double = 0.0
    var restaurantId: String?
    var branchId: String?
    var branchName: String?
    var restaurantMenu = [RestaurantMenu]()
    var restaurantMenuItems = [MenuItem]()
    var minCost = 0.0
    var openStatus: Int?
    var pickupservice: Int?
    var reviewCount = 0
    var imageLogo: String = ""
    var restaurantDesc: String?
    var estimatedPreparationTime = 0.0
    var cartItems = [CartItem]()
    var comeFrom = String()
    weak var delegate: UpdateProce?
    
    var timer = Timer()
    
    // MARK: Variables
    var selectedCategoryCell = 0
    var previousSelectedCategoryCell = 0
    var pageViewController: UIPageViewController?
    var pageViewModel: PageViewModel?
    var viewControllers: [UIViewController] = []
    var actulPrice = Double()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // align()
        self.setUpUI()
        self.registerTable()
        stackHeight.constant = 0
        self.getMenuDetails()
        backBtn.changeBackWhiteButton()
        handleNotifications()
        menuViews.shadowPathCustom(cornerRadius: 0)
        
        listButton.isHidden = true
        gridBtn.isHidden = true
    }
    
    func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(pushToViewCart), name: NSNotification.Name(rawValue: "goToViewCartVC"), object: nil)
    }
    
    // MARK: Cancel Addons Popup Notificaition
    @objc func pushToViewCart() {
        self.nextController()
    }
    
    //MARK: Alignment of collectionview
    /// -
    func align() {
        resaurantCollectionMenu.semanticContentAttribute = .forceLeftToRight
    }
    
    // MARK: View Will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionViewList.reloadData()
        checkStatusForDarkMode()
        getCart()
    }
    
    //MARK:- CHECK STATUS FOR DARK Mode
    func checkStatusForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: statusBarHeight))
            statusbarView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            view.addSubview(statusbarView)
            subCategoryProductsContainer.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            menuViews.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.1960583925, green: 0.1960916221, blue: 0.1960479617, alpha: 1)
            self.headerTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.gridBtn.setImage(UIImage(named: "grid"), for: .normal)
            self.listButton.setImage(UIImage(named: "menu-1"), for: .normal)
            
            collectionViewList.backgroundColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
            
        } else {
            
            subCategoryProductsContainer.backgroundColor = #colorLiteral(red: 0.9913015962, green: 0.6188052893, blue: 0, alpha: 1)
            menuViews.backgroundColor = #colorLiteral(red: 0.9913015962, green: 0.6188052893, blue: 0, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            self.headerTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.gridBtn.setImage(UIImage(named: "ic_grid"), for: .normal)
            self.listButton.setImage(UIImage(named: "selectedgrid"), for: .normal)
            
            collectionViewList.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }
    
    //MARK: SetUp The Controller UI
    func setUpUI() {
        
        
        //cartView.roundCorners(view: cartView, corners:[.topLeft,.bottomLeft], radius: 15)
        //cartCheckOutView.roundCorners(view: cartCheckOutView, corners:[.topRight,.bottomRight], radius: 15)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.collectionViewList.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.collectionViewList.addGestureRecognizer(swipeLeft)
        
        restaurantMenuItems.removeAll()
        viewCart.setTitle("VIEW CART".localizedString, for: .normal)
        //viewCart.setTitle("VIEW CART".localizedString + " >", for: .normal)
        priceLabel.text = String(totalprice)
        numberOfItemsLabel.text = "\(quantity)" + totalNumberOfItems.localizedString
        if #available(iOS 10.0, *) {
            resaurantCollectionMenu.isPrefetchingEnabled = false
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                if self.isSelectedIndex != 0 {
                    self.isSelectedIndex = isSelectedIndex - 1
                    headerTitle.text = self.restaurantMenu[self.isSelectedIndex].menuCategoryName?.uppercased()
                    resaurantCollectionMenu.layoutIfNeeded()
                    resaurantCollectionMenu.scrollToItem(at: IndexPath(row: self.isSelectedIndex, section: 0), at: .centeredHorizontally, animated: true)
                    collectionViewList.layoutIfNeeded()
                    collectionViewList.scrollToItem(at: IndexPath(row: 0, section: self.isSelectedIndex), at: .top, animated: false)
                }
            case .left:
                if self.isSelectedIndex != self.restaurantMenu.count - 1 {
                    self.isSelectedIndex = isSelectedIndex + 1
                    headerTitle.text = self.restaurantMenu[self.isSelectedIndex].menuCategoryName?.uppercased()
                    
                    resaurantCollectionMenu.layoutIfNeeded()
                    resaurantCollectionMenu.scrollToItem(at: IndexPath(row: self.isSelectedIndex, section: 0), at: .centeredHorizontally, animated: true)
                    
                    collectionViewList.layoutIfNeeded()
                    collectionViewList.scrollToItem(at: IndexPath(row: 0, section: self.isSelectedIndex), at: .top, animated: false)
                }
            default:
                break
            }
        }
    }
    
    // MARK: Content Size
    func contenSizeList(size: CGFloat) {
        //viewHeight.constant = size
    }
    
    
    //MARK:- Update Price
    func priceupdate(price: Double?, count: Int?) {
        guard let countItem = count else {
            stackHeight.constant = 0
            return
        }
        if let priceItem = price {
            let sar = "Rs.".localizedString
            
            priceLabel.text = "\(sar) \(priceItem.roundTo2Decimal())"
            numberOfItemsLabel.text = "\(countItem) " + totalNumberOfItems.localizedString
            
        }
        if countItem > 0 {
            stackHeight.constant = 55
        } else {
            stackHeight.constant = 0
        }
    }
    
    //MARK:- Register TableView Cell
    /// -register tableView Cell and assign delegate and data Source
    /// -to the UITableView to load the Cell
    func registerTable() {
        resaurantCollectionMenu.delegate = self
        resaurantCollectionMenu.dataSource = self
        
        self.collectionViewList.delegate = self
        self.collectionViewList.dataSource = self
        
        self.collectionViewList.register(UINib(nibName: Identifier.gridMenu, bundle: nil), forCellWithReuseIdentifier: Identifier.gridMenu)
        self.collectionViewList.register(UINib(nibName: Identifier.listMenu, bundle: nil), forCellWithReuseIdentifier: Identifier.listMenu)
        self.resaurantCollectionMenu.register(UINib(nibName: Identifier.restaurantItemCell, bundle: nil), forCellWithReuseIdentifier: Identifier.restaurantItemCell)
    }
    
    //MARK: Open Review Controller
    @IBAction func reviewController(_ sender: UIButton) {
        if reviewCount == 0 {
            return
        }
        let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.reviewController) as? ReviewViewController else {
            fatalError()
        }
        vc.restaurantId = self.restaurantId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Refer to friend
    @IBAction func referToFriend(_ sender: UIButton) {
        self.shareLink()
    }
    
    //MARK: Share the link
    /// - create a restaurant link to share with friends
    /// - with location and direction on map
    func shareLink() {
        var bookingType = Booking.home.rawValue
        if bookingFlow == .pickup {
            bookingType = Booking.pickUp.rawValue
        }
        guard let id = restaurantId else {
            return
        }
        let text = "https://api.foodfox.in/restaurant-detail/" + "\(id)/" + "\(lat)/" + "\(long)/\(bookingType)"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Api of getMenu details
    /// -server call to get the menu datails and update the UI according to server data
    func getMenuDetails() {
        var param: [String: Any] = [:]
        param["restaurantId"] = self.restaurantId
        param["branchId"] = self.branchId
        param["skip"] = skipValue
        param["limit"] = numberOfLimit
        param["latitude"] = self.lat
        param["longitude"] = self.long
        print("params of get Menu = \(param)")
        restaurantMenu.removeAll()
        restaurantMenuItems.removeAll()
        RestaurantManager.share.getMenu(parameters: param) {(response: Any?, error: Error?)in
            if let data = response as? MenuOFRestaurant {
                self.updateUI(data: data)
                //                self.instantiateViewControllers()
            }
        }
    }
    
    
    // MARK: Setting VC In Page View Controller
    //    func instantiateViewControllers() {
    //        viewControllers.removeAll()
    //        for iVar in 0..<restaurantMenu.count {
    //            viewControllers.append(initViewController(index: iVar))
    //        }
    //        pageViewModel = PageViewModel(viewControllers: viewControllers)
    //        pageViewModel?.pageNumberChanged(callBack: { (index: Int) in
    //            self.pageNumberChanged(index: index)
    //        })
    //        pageViewModel?.scrollToNextPage(callBack: { (index: Int) in
    //            self.setNextPage(index: index, direction: .forward)
    //        })
    //        self.setupPageViewController()
    //    }
    
    //    func initViewController(index: Int) -> UIViewController {
    //        guard let itemsViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnlineContainerController") as? OnlineContainerController else {
    //            fatalError("Items View Controller Not Found")
    //        }
    //        itemsViewController.restaurantMenuItems = restaurantMenu[index].menuItem
    //        itemsViewController.openStatus = self.openStatus ?? -1
    //        itemsViewController.pickupservice = self.pickupservice ?? -1
    //        itemsViewController.restaurantId = self.restaurantId
    //        itemsViewController.branchId = self.branchId
    //
    //        let menuName = self.restaurantMenu[index].menuCategoryName
    //        if (menuName?.uppercased().contains("FEATURED ITEMS"))! {
    //            itemsViewController.state = 1
    //        } else {
    //            itemsViewController.state = 0
    //        }
    //
    //        itemsViewController.delegate = self
    //        return itemsViewController
    //    }
    
    // set current page to the page controller
    func setNextPageForGrid(index: Int, direction: UIPageViewController.NavigationDirection) {
        if let firstViewController = pageViewModel?.viewControllers[index] {
            firstViewController.viewWillAppear(true)
        }
    }
    
    // set current page to the page controller
    func setNextPage(index: Int, direction: UIPageViewController.NavigationDirection) {
        if let firstViewController = pageViewModel?.viewControllers[index] {
            print("Selected Grid --------------")
            pageViewController?.setViewControllers([firstViewController],
                                                   direction: direction,
                                                   animated: false,
                                                   completion: nil)
        }
    }
    
    // set the selected page and accordingly set the above collection view ( that is treatment option's collection view)
    func pageNumberChanged(index: Int) {
        previousSelectedCategoryCell = selectedCategoryCell
        self.selectedCategoryCell = index
        self.isSelectedIndex = index
        let menuName = self.restaurantMenu[index].menuCategoryName
        headerTitle.text = menuName?.uppercased()
        resaurantCollectionMenu.reloadData()
    }
    
    // MARK: - SET PAGE CONTROLLER's VIEW's
    private func setupPageViewController() {
        let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageViewController.dataSource = pageViewModel
        pageViewController.delegate = pageViewModel
        if let firstViewController = pageViewModel?.viewControllers[selectedCategoryCell] {
            pageViewController.setViewControllers([firstViewController],
                                                  direction: .reverse,
                                                  animated: true,
                                                  completion: nil)
        }
        self.addChild(pageViewController)
        //self.subCategoryProductsContainer.addSubview(pageViewController.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.subCategoryProductsContainer.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        pageViewController.view.frame = pageViewRect
        pageViewController.didMove(toParent: self)
        self.pageViewController = pageViewController
    }
    
    
    //MARK: Update UI
    /// -Update UI on the basis of Server Data
    /// -get all data from server parsed Data
    func updateUI(data: MenuOFRestaurant) {
        
        if let vatValue = data.vat {
            self.vat = vatValue
        }
        self.resaurantImage.imageUrl(imageUrl: data.restaurantImage ?? "", placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        self.resaurantLogoImage.imageUrl(imageUrl: data.logoImage  ?? "", placeholderImage: #imageLiteral(resourceName: "ic_placeholderBg"))
        self.imageLogo = data.logoImage ?? ""
        self.resaurantLogoImage.clipsToBounds = true
        self.reviewLabel.text = "\(data.review ?? 0) " + "Reviews".localizedString
        self.reviewLabel.textColor = lightWhite
        self.restaurantMenu = data.restaurantMenu
        
        //self.restaurantNameLbl.text = data.restaurantName
        self.restaurantNameLbl.text = branchName
        reviewCount = data.review ?? 0
        if let menu = self.restaurantMenu.first?.menuItem {
            self.restaurantMenuItems = menu
        }
        if let cost = data.miniMumOrder {
            self.minCost = cost
        }
        if let openingStatus = data.openingStatus {
            self.openStatus = openingStatus
        }
        if let pickupservice = data.pickupservice {
            self.pickupservice = pickupservice
        }
        let statusString = getStatusName(status: self.openStatus ?? -1)
        self.statusName.text = statusString.localizedString
        if getStatusType(status: self.openStatus ?? -1) {
            self.blurViewTemper.isHidden = false
            self.blurViewTemper.backgroundColor = .black
        } else {
            self.blurViewTemper.isHidden = false
            self.blurViewTemper.backgroundColor = .black
            //            self.blurViewTemper.backgroundColor = .white
            //            self.blurViewTemper.isHidden = true
        }
        if self.restaurantMenu.count > 0 {
            let menuName = self.restaurantMenu[self.isSelectedIndex].menuCategoryName
            self.headerTitle.text = menuName?.uppercased()
        }
        self.resaurantCollectionMenu.reloadData()
        self.collectionViewList.reloadData()
    }
    
    //MARK:- GRID BTN ACTION
    @IBAction func gridBtnAction(_ sender: Any) {
        //        self.state = 1
        //
        //        guard let page = pageViewModel else {
        //            return
        //        }
        //        for controller in page.viewControllers {
        //            if let control = controller as? OnlineContainerController {
        //                control.state = self.state
        //            }
        //        }
        //        self.setNextPageForGrid(index: selectedCategoryCell, direction: .reverse)
        //gr.setImage(#imageLiteral(resourceName: "selectedgrid"), for: .normal)
    }
    
    
    // MARK: - UIActions
    @IBAction func actiongrid(_ sender: UIButton) {
        //        if self.state == 0 {
        //
        //        } else {
        //        listButton.setImage(#imageLiteral(resourceName: "selectedgrid"), for: .normal)
        //            self.state = 0
        //        //}
        //        print("state ", self.state)
        //
        //        guard let page = pageViewModel else {
        //            return
        //        }
        //        for controller in page.viewControllers {
        //            if let control = controller as? OnlineContainerController {
        //                control.state = self.state
        //            }
        //        }
        //        self.setNextPageForGrid(index: selectedCategoryCell, direction: .reverse)
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionViewCart(_ sender: Any) {
        nextController()
    }
    
    // MARK: Next Cart View Controller
    func nextController() {
      // let isAddon = (restaurantMenu[cellSection].menuItem[cellIndex].addOns.count == 0)
        let isAddon = (restaurantMenu[0].menuItem[isSelectedIndex].addOns.count == 0)
        let firstItem = cartItems.first
        if ((firstItem?.resturentId != restaurantId) || (firstItem?.branchId != branchId)) && (cartItems.count != 0) {
            let alert = UIAlertController(title: "", message: "You had added items of different restaurant in cart. Are you sure you want to clear Cart ?".localizedString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { action in
                self.collectionViewList.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .default, handler: { action in
                self.deleteAllRecords()
                if isAddon {
                   // self.saveItemAndAddons(itemIndex: indexPath.section, menuDetails: [])
                } else {
                   // self.viewAddPopUp(indexPath.row, section: 0)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
        if let viewController = R.storyboard.home.viewCartController() {
            viewController.resturentId = restaurantId ?? ""
            //viewController.miniCost = self.minCost
            viewController.branchId = branchId ?? ""
            viewController.restaurantDetails = LoginManagerApi.share.selectedRestaurantDetail
            viewController.vat = self.vat
            viewController.branchName = branchName
            self.navigationController?.pushViewController(viewController, animated: true)
        
        }
        }
    }
}

//MARK :- collectionView Delegates and DataSource
extension OnlineMenuDetails: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionViewList {
            return restaurantMenu.count
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewList {
            if self.restaurantMenu.count > 0 {
                return self.restaurantMenu[section].menuItem.count
            } else {
                return 0
            }
        } else {
            return restaurantMenu.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewList {
            let menuName = self.restaurantMenu[indexPath.section].menuCategoryName
            if (menuName?.uppercased().contains("FEATURED ITEMS"))! {
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
                    cell.addBtn.clipsToBounds = true
                    cell.addBtn.layer.shadowColor = UIColor.gray.cgColor
                    cell.addBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
                    cell.addBtn.layer.shadowOpacity = 1.0
                    cell.addBtn.layer.shadowRadius = 10
                    cell.addBtn.layer.masksToBounds = false
                   // cell.addButton.layer.borderWidth = 1
                    cell.addBtn.layer.cornerRadius = 10
                    //cell.addButton.layer.borderColor = UIColor.gray.cgColor
                    
                } else {
                    cell.backgroundContentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.restaurantItemName.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
                    cell.addButton.setImage(UIImage(named: "sub"), for: .normal)
                    cell.substractBtn.setImage(UIImage(named: "add"), for: .normal)
                    cell.quantityLabel.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
                    cell.lblPrice.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
                    cell.addBtn.setTitleColor(#colorLiteral(red: 0.3755612373, green: 0.6984048486, blue: 0.2751020193, alpha: 1), for: .normal)
                    cell.addBtn.clipsToBounds = true
                    cell.addBtn.layer.shadowColor = UIColor.gray.cgColor
                    cell.addBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
                    cell.addBtn.layer.shadowOpacity = 1.0
                    cell.addBtn.layer.shadowRadius = 10
                    cell.addBtn.layer.masksToBounds = false
                   // cell.addButton.layer.borderWidth = 1
                    cell.addBtn.layer.cornerRadius = 10
                    //cell.addButton.layer.borderColor = UIColor.gray.cgColor
                    
                }
                
                let restaurantItem = restaurantMenu[indexPath.section].menuItem[indexPath.row]
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
                let  quantity = fetchSpecificCart(section: indexPath.section, index: indexPath.row)
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
            } else {
                guard let cell: ListMenuCollectioncell  = self.collectionViewList.dequeueReusableCell(withReuseIdentifier: Identifier.listMenu, for: indexPath) as? ListMenuCollectioncell else {
                    fatalError("Couldn't load GridMenuCollectioncell")
                }
                
                let value = restaurantMenu[indexPath.section].menuItem[indexPath.row]
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
                    cell.addButton.clipsToBounds = true
                    cell.addButton.layer.shadowColor = UIColor.gray.cgColor
                    cell.addButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                    cell.addButton.layer.shadowOpacity = 1.0
                    cell.addButton.layer.shadowRadius = 10
                    cell.addButton.layer.masksToBounds = false
                   // cell.addButton.layer.borderWidth = 1
                    cell.addButton.layer.cornerRadius = 10
                    //cell.addButton.layer.borderColor = UIColor.gray.cgColor
                    
                } else {
                    cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.restaurantItemLabel.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
                    cell.addBtn.setImage(UIImage(named: "add"), for: .normal)
                    cell.substratBtn.setImage(UIImage(named: "sub"), for: .normal)
                    cell.quantityLabel.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
                    cell.lblItemPrice.textColor = #colorLiteral(red: 0.1293970644, green: 0.1294215024, blue: 0.1293893754, alpha: 1)
                    cell.addButton.setTitleColor(#colorLiteral(red: 0.3755612373, green: 0.6984048486, blue: 0.2751020193, alpha: 1), for: .normal)
                    cell.addButton.clipsToBounds = true
                    cell.addButton.layer.shadowColor = UIColor.gray.cgColor
                    cell.addButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                    cell.addButton.layer.shadowOpacity = 1.0
                    cell.addButton.layer.shadowRadius = 10
                    cell.addButton.layer.masksToBounds = false
                   // cell.addButton.layer.borderWidth = 1
                    cell.addButton.layer.cornerRadius = 10
                   // cell.addButton.layer.borderColor = UIColor.gray.cgColor
                    
                }
                if value.addOns.count != 0 {
                    print("addOns have")
                    cell.customizationHeight.constant = 25
                    cell.priseTopConstarint.constant = 2
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
                
                cell.addBAction = { (isClicked) in
                    self.onAddCellItem(indexPath: indexPath)
                }
                
                cell.substractCartQuantityAction = { (isClicked) in
                    self.onsubstractCartQuantity(indexPath: indexPath)
                }
                
                cell.addCartQuantityAction = { (isClicked) in
                    self.onAddCellItem(indexPath: indexPath)
                }
                
                let  quantity = fetchSpecificCart(section: indexPath.section, index: indexPath.row)
                
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
        } else {
            guard let cell: RestaurantItemCollectionViewCell  = self.resaurantCollectionMenu.dequeueReusableCell(withReuseIdentifier: "RestaurantItemCollectionViewCell", for: indexPath) as? RestaurantItemCollectionViewCell else {
                fatalError("Couldn't load RestaurantItemCollectionViewCell")
            }
            cell.nameOfItem.text = self.restaurantMenu[indexPath.row].menuCategoryName?.uppercased()
            //print(self.restaurantMenu[indexPath.row].menuCategoryName?.uppercased() ?? "")
            if isSelectedIndex == indexPath.row {
                cell.nameOfItem.textColor = whiteColor
                cell.scrollView.backgroundColor = whiteColor
            } else {
                cell.nameOfItem.textColor = lightWhite
                cell.scrollView.backgroundColor = UIColor.black
            }
            // cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
            return cell
        }
    }
    
    func onAddCellItem(indexPath: IndexPath)
    {
        let isAddon = (self.restaurantMenu[indexPath.section].menuItem[indexPath.row].addOns.count == 0)
        let firstItem = self.cartItems.first
        if ((firstItem?.resturentId != self.restaurantId) || (firstItem?.branchId != self.branchId)) && (self.cartItems.count != 0) {
            let alert = UIAlertController(title: "", message: "You had added items of different restaurant in cart. Are you sure you want to clear Cart ?".localizedString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { action in
                self.collectionViewList.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .default, handler: { action in
                self.deleteAllRecords()
                if isAddon {
                    self.saveItemAndAddons(itemSection: indexPath.section, itemIndex: indexPath.row, menuDetails: [])
                } else {
                    self.viewAddPopUp(indexPath.row, section: indexPath.section)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            if isAddon {
                self.saveItemAndAddons(itemSection: indexPath.section, itemIndex: indexPath.row, menuDetails: [])
            } else {
                self.viewAddPopUp(indexPath.row, section: indexPath.section)
            }
        }
        getCart()
    }
    
    func onsubstractCartQuantity(indexPath: IndexPath)
    {
        if let array = fetchSpecificCartArray(section: indexPath.section, index: indexPath.row), array.count > 1 {
            let alert = UIAlertController(title: "", message: "You have added different variations of this item. Please view cart to remove specific item.".localizedString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { action in
                
            }))
            alert.addAction(UIAlertAction(title: "View Cart".localizedString, style: .default, handler: { action in
                //self.nextController()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToViewCartVC"), object: nil, userInfo: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            deleteCart(section: indexPath.section, index: indexPath.row)
        }
        getCart()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != collectionViewList {
            //previousSelectedCategoryCell  = selectedCategoryCell
            selectedCategoryCell = indexPath.row
            headerTitle.text = self.restaurantMenu[indexPath.row].menuCategoryName?.uppercased()
            self.isSelectedIndex = indexPath.row
            //resaurantCollectionMenu.reloadData()
            resaurantCollectionMenu.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionViewList.layoutIfNeeded()
            collectionViewList.scrollToItem(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.contenSizeList(size: collectionView.contentSize.height)
        if collectionView == collectionViewList {
            let menuName = self.restaurantMenu[indexPath.section].menuCategoryName
            headerTitle.text = menuName?.uppercased()
            self.resaurantCollectionMenu.layoutIfNeeded()
            resaurantCollectionMenu.scrollToItem(at: IndexPath(row: indexPath.section, section: 0), at: .centeredHorizontally, animated: true)
            //self.resaurantCollectionMenu.scrollToItem(at: IndexPath(item: self.isSelectedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}


// MARK: - CollectionViewDelegateFlowLayout
extension OnlineMenuDetails: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewList {
            let menuName = self.restaurantMenu[indexPath.section].menuCategoryName
            if (menuName?.uppercased().contains("FEATURED ITEMS"))! {
                return CGSize(width: ((collectionViewList.frame.size.width)/2) - 5, height: 270)
            } else {
                return CGSize(width: collectionViewList.frame.size.width, height: 110)
            }
        } else {
            return CGSize(width: ((collectionView.frame.size.width)/3) - 5, height: collectionView.bounds.height)
        }
    }
}


extension OnlineMenuDetails: ViewAdd {
    
    //MARK:- CUSTOMIZE ADDONS FUNCTION
    func viewAddPopUp(_ tag: Int?) {
        print("addon have screen came")
        if let index = tag, restaurantMenu[0].menuItem[index].addOns.count != 0 {
            if let nextVC = R.storyboard.home.addOnItemController() {
                
                nextVC.menu = restaurantMenu[0].menuItem[index].addOns
                nextVC.itemName = restaurantMenu[0].menuItem[index].itemName
                nextVC.itemDescription = restaurantMenu[0].menuItem[index].description
                nextVC.menuId = restaurantMenu[0].menuItem[index].menuId ?? ""
                nextVC.index = index
                nextVC.section = 0
                nextVC.delegate = self
                if let price = restaurantMenu[0].menuItem[index].price {
                    nextVC.price = price
                }
                nextVC.modalPresentationStyle = .overCurrentContext
                self.present(nextVC, animated: true, completion: nil)
                
            }
        }
    }
    
    func viewAddPopUp(_ tag: Int?, section: Int?) {
        if let index = tag, restaurantMenu[section!].menuItem[index].addOns.count != 0 {
            if let nextVC = R.storyboard.home.addOnItemController() {
                nextVC.menu = restaurantMenu[section!].menuItem[index].addOns
                nextVC.itemName = restaurantMenu[section!].menuItem[index].itemName
                nextVC.itemDescription = restaurantMenu[section!].menuItem[index].description
                nextVC.menuId = restaurantMenu[section!].menuItem[index].menuId ?? ""
                nextVC.index = index
                nextVC.section = section ?? 0
                nextVC.delegate = self
                if let price = restaurantMenu[section!].menuItem[index].price {
                    nextVC.price = price
                }
                nextVC.modalPresentationStyle = .overCurrentContext
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }
}

extension OnlineMenuDetails: AddMenuItemDelegate {
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
            deleteCart(section: 0, index: cellIndex)
        }
        getCart()
    }
    
    // MARK: Add Delegate
    func addMenuItem(cellSection: Int, cellIndex: Int) {
        let isAddon = (restaurantMenu[cellSection].menuItem[cellIndex].addOns.count == 0)
        let firstItem = cartItems.first
        if ((firstItem?.resturentId != restaurantId) || (firstItem?.branchId != branchId)) && (cartItems.count != 0) {
            let alert = UIAlertController(title: "", message: "You had added items of different restaurant in cart. Are you sure you want to clear Cart ?".localizedString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { action in
                self.collectionViewList.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .default, handler: { action in
                self.deleteAllRecords()
                if isAddon {
                    self.saveItemAndAddons(itemIndex: cellIndex, menuDetails: [])
                } else {
                    self.viewAddPopUp(cellIndex, section: cellSection)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            if isAddon {
                self.saveItemAndAddons(itemIndex: cellIndex, menuDetails: [])
            } else {
                self.viewAddPopUp(cellIndex, section: cellSection)
            }
        }
        getCart()
    }
    
    func addMenuItem(cellIndex: Int) {
        let isAddon = (restaurantMenu[0].menuItem[cellIndex].addOns.count == 0)
        let firstItem = cartItems.first
        if ((firstItem?.resturentId != restaurantId) || (firstItem?.branchId != branchId)) && (cartItems.count != 0) {
            let alert = UIAlertController(title: "", message: "You had added items of different restaurant in cart. Are you sure you want to clear Cart ?".localizedString, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .default, handler: { action in
                self.collectionViewList.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Ok".localizedString, style: .default, handler: { action in
                self.deleteAllRecords()
                if isAddon {
                    self.saveItemAndAddons(itemIndex: cellIndex, menuDetails: [])
                } else {
                    self.viewAddPopUp(cellIndex, section: 0)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            if isAddon {
                self.saveItemAndAddons(itemIndex: cellIndex, menuDetails: [])
            } else {
                self.viewAddPopUp(cellIndex, section: 0)
            }
        }
        getCart()
    }
    
    // MARK: Update Delegate
    func updateQuantity(quantity: String) {
        self.itemQuantity = quantity
    }
}

extension OnlineMenuDetails: AddonDelegate {
    
    
    //MARK: Add Addons
    /// -call Addon Delegate tp add Addons with Items
    func addAddon(data: [String: Any]) {
        guard let menuDetails = data["items"] as? [PerItem], let index = data["index"] as? Int, let section = data["section"] as? Int else {
            
            return
        }
        saveItemAndAddons(itemSection: section, itemIndex: index, menuDetails: menuDetails)
        //saveItemAndAddons(itemIndex: index, menuDetails: menuDetails)
    }
    
    // MARK: Save Cart to Core Data
    /// - add Item to cart
    /// - Check item already added or not
    /// -check item has addons or not'
    func saveItemAndAddons(itemSection: Int = 0, itemIndex: Int, menuDetails: [PerItem]? ) {
        var isMatched: Bool = false
        
        actulPrice = UserDefaults.standard.value(forKey: "priceFetch") as? Double ?? 0.0
        comeFrom = "deleteActulPrice"
        if let items = fetchSpecificCartArray(section: itemSection, index: itemIndex), items.count > 0 {
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
                            print(quantity)
                            for addon in addonArray {
                              let price = (addon.adonsPrice + actulPrice)
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
            createNewObject(itemSection: itemSection, itemIndex: itemIndex, menuDetails: menuDetails)
        }
        getCart()
    }
    
    // MARK: Create new Object in CoreData
    ///if added item not matched local database stored item then add new item
    /// - create new item Object in existing database if item not found
    func createNewObject(itemSection: Int, itemIndex: Int, menuDetails: [PerItem]?) {
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
            managedObject.itemName = restaurantMenu[itemSection].menuItem[itemIndex].itemName
            managedObject.itemPrice = restaurantMenu[itemSection].menuItem[itemIndex].price ?? 0.0
            managedObject.cartItemId = restaurantMenu[itemSection].menuItem[itemIndex].menuId
            managedObject.branchId = restaurantMenu[itemSection].menuItem[itemIndex].branchId
            managedObject.resturentId = restaurantId
            managedObject.branchName = branchName
            managedObject.image = imageLogo
            managedObject.resturentDesc = restaurantDesc
            managedObject.estimateTime = estimatedPreparationTime
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
        getCart()
    }
    
    
    // MARK: delete Cart From Core Data
    /// delete the item from local database
    /// if data quantity has 1
    func deleteCart(section: Int , index: Int) {
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
            let menuId = restaurantMenu[section].menuItem[index].menuId
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
            priceupdate(price: self.price, count: totalQuantity)
        }
        priceupdate(price: self.price, count: totalQuantity)
        delegate?.priceupdate(price: price, count: totalQuantity)
        collectionViewList.reloadData()
        LoginManagerApi.share.promoAmount = 0.0
    }
    
    // MARK: Fetch Cart with Specific id for Core Data
    func fetchSpecificCartArray(section: Int = 0, index: Int) -> [CartItem]? {
        let menuId = restaurantMenu[section].menuItem[index].menuId ?? ""
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
    func fetchSpecificCart(section: Int, index: Int) -> Int {
        let menuId = restaurantMenu[section].menuItem[index].menuId ?? ""
        
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
