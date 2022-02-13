//
//  CLCountryPickerController.swift
//  CountryCodeInSwift3
//
//  Created by cl-macmini-68 on 09/02/17.
//  Copyright © 2017 Suryakant. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CLCountryPickerController: UIViewController {
  
  @IBOutlet weak fileprivate var tableView: UITableView!
  
  // MARK: - Variables
  fileprivate var countries = [Country]()
  fileprivate var filterCountries = [Country]()
  fileprivate var applySearch = false
  fileprivate weak var _presentingViewController: UIViewController?
  fileprivate var callBack : (( _ chosenCountry: Country) -> Void)?
  fileprivate var searchController: UISearchController?
  
  var statusBarStyle: UIStatusBarStyle? = .default
  var isStatusBarVisible = true
  
  private func loadDefaultSettings() {
    if self.isViewLoaded {
      self.tableView.reloadData()
      
      self.navigationController?.navigationBar.tintColor = tintColor
      self.searchController?.navigationController?.navigationBar.tintColor = tintColor
      self.searchController?.searchBar.tintColor = tintColor
      
    }
  }
  var labelFont = UIFont.systemFont(ofSize: 14.0) {
    didSet {
      if self.isViewLoaded {
        self.loadDefaultSettings()
      }
    }
  }
  var labelColor = UIColor.black {
    didSet {
      if self.isViewLoaded {
        self.loadDefaultSettings()
      }
    }
  }
  
  var detailFont = UIFont.systemFont(ofSize: 11.0) {
    didSet {
      if self.isViewLoaded {
        self.loadDefaultSettings()
      }
    }
  }
  
  var detailColor = UIColor.lightGray {
    didSet {
      if self.isViewLoaded {
        self.loadDefaultSettings()
      }
    }
  }
  
  var separatorLineColor = UIColor.lightGray {
    didSet {
      if self.isViewLoaded {
        self.loadDefaultSettings()
      }
    }
  }
  
  var tintColor: UIColor? = nil {
    didSet {
      if tintColor != nil {
        if self.isViewLoaded {
          self.loadDefaultSettings()
        }
      }
      
    }
  }
  
  var isHideFlagImage: Bool = false {
    didSet {
      if self.isViewLoaded {
        self.loadDefaultSettings()
      }
    }
  }
  
  var isHideDiallingCode: Bool = false {
    didSet {
      if self.isViewLoaded {
        self.loadDefaultSettings()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.isTranslucent = false
    
    self.view.backgroundColor = UIColor.white
    self.tableView.backgroundColor = UIColor.white
    
    let uiBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(CLCountryPickerController.crossButtonClicked(_:)))
    self.navigationItem.leftBarButtonItem = uiBarButtonItem
    let nib = UINib(nibName: "CLCountryCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "CLCountryCell")
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    
    searchController = UISearchController(searchResultsController: nil)
    searchController?.hidesNavigationBarDuringPresentation = true
    searchController?.dimsBackgroundDuringPresentation = false
    searchController?.searchBar.barStyle = .default
    searchController?.searchBar.delegate = self
    searchController?.delegate = self
    searchController?.searchResultsUpdater = self
    searchController?.searchBar.placeholder = "search country name here.."
    searchController?.searchBar.sizeToFit()
    tableView.tableHeaderView = searchController?.searchBar
    searchController?.searchBar.tintColor = self.tintColor
    
    NotificationCenter.default.addObserver(self, selector: #selector(CLCountryPickerController.reloadView), name: NSNotification.Name(rawValue: "notificationImagesUploadSuccessfully"), object: nil)
    
    definesPresentationContext = true
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    IQKeyboardManager.shared.enable = false
    self.loadDefaultSettings()
    loadCountries()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    IQKeyboardManager.shared.enable = true
  }
  
  @discardableResult
  class func presentController(on viewController: UIViewController, callBack:@escaping (_ chosenCountry: Country) -> Void) -> CLCountryPickerController {
    _ = CountryManager.shared
    let controller = CLCountryPickerController()
    controller._presentingViewController = viewController
    controller.callBack = callBack
    let navigationController = UINavigationController(rootViewController: controller)
    controller._presentingViewController?.present(navigationController, animated: true, completion: nil)
    return controller
  }
  
  // MARK: - Cross Button Action
  @objc func crossButtonClicked(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func loadCountries() {
    countries = CountryManager.shared.allCountries()
    tableView.reloadData()
  }
  
  @objc func reloadView() {
    DispatchQueue.main.async {
      self.loadCountries()
    }
  }
  
}

// MARK: - TableView DataSource
extension CLCountryPickerController: UITableViewDelegate {
  // MARK: - TableView Delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
    switch applySearch {
    case true:
      
      self.searchController?.searchBar.resignFirstResponder()
      self.searchController?.searchBar.text = ""
      applySearch = false
      
      let country = filterCountries[indexPath.row]
      self.callBack?(country)
      CountryManager.shared.lastCountrySelected = country
      
      //tableView.deselectRow(at: indexPath, animated: true)
      tableView.reloadData()
      self.parent?.dismiss(animated: true, completion: nil)
      
    case false:
      let country = countries[indexPath.row]
      self.callBack?(country)
      CountryManager.shared.lastCountrySelected = country
      
      tableView.deselectRow(at: indexPath, animated: true)
      tableView.reloadData()
      self.dismiss(animated: true, completion: nil)
      
    }
    
  }
  
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    return 50.0
  //  }
  
}
extension CLCountryPickerController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch applySearch {
    case false:
      return countries.count
    case true:
      return filterCountries.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "CLCountryCell") as? CLCountryCell {
      cell.accessoryType = .none
      cell.checkmarkImageView.isHidden = true
      
      if let image = UIImage(named: "tickMark") {
        image.withRenderingMode(.alwaysTemplate)
        cell.checkmarkImageView.image = image
      }
      cell.checkmarkImageView.tintColor = self.tintColor
      
      var country: Country
      if applySearch {
        country = filterCountries[indexPath.row]
      } else {
        country = countries[indexPath.row]
      }
      
      if let country = CountryManager.shared.lastCountrySelected {
        let isEqual = (country.countryCode == country.countryCode)
        if isEqual {
          // cell.accessoryType = .checkmark
          cell.checkmarkImageView.isHidden = false
        }
      }
      cell.nameLabel?.text = country.countryName()
      cell.diallingCodeLabel?.text = country.dialingCode()
      
      let imagePath = country.imagePath
      if let image = UIImage(named: imagePath, in: nil, compatibleWith: nil) {
        cell.flagImageView?.image = image
      }
      
      cell.nameLabel.font = self.labelFont
      cell.nameLabel.textColor = self.labelColor
      cell.diallingCodeLabel.font = self.detailFont
      cell.diallingCodeLabel.textColor = self.detailColor
      cell.flagImageView.isHidden = self.isHideFlagImage
      cell.diallingCodeLabel.isHidden = self.isHideDiallingCode
      cell.separatorLine.backgroundColor = self.separatorLineColor
      return cell
    }
    return UITableViewCell()
  }
  
}

// MARK: - UISearchResultsUpdating
extension CLCountryPickerController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
  }
}

// MARK: - UISearchControllerDelegate
extension CLCountryPickerController: UISearchControllerDelegate {
  
  func didPresentSearchController(_ searchController: UISearchController) {
  }
  
  func willPresentSearchController(_ searchController: UISearchController) {
    searchController.edgesForExtendedLayout = []
  }
  
}

// MARK: - UISearchBarDelegate
extension CLCountryPickerController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    //code for filter
    if searchBar.text != "" {
      
      applySearch = true
      filterCountries = []
      if let searchString = searchBar.text {
        for country in countries {
          if ((country.countryName().uppercased()) as NSString).hasPrefix((searchString.uppercased())) {
            self.filterCountries.append(country)
          }
        }
      }
      
    } else {
      applySearch = false
    }
    // Reload the tableview.
    tableView.reloadData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.text = ""
    applySearch = false
    tableView.reloadData()
    
    // self.searchController?.dimsBackgroundDuringPresentation = true
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
    // self.searchController?.dimsBackgroundDuringPresentation = true
  }
  
}
