  //
  //  InfoController.swift
  //  FoodFox
  //
  //  Created by soc-macmini-30 on 26/09/17.
  //  Copyright © 2017 Click-Labs. All rights reserved.
  //

  import UIKit

  class InfoController: CLBaseViewController {

    //MARK: Outlets
    @IBOutlet weak var navTitle: UILabel! {
        didSet {
            navTitle.font = AppFont.semiBold(size: 14)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!

    override func viewDidLoad() {
          super.viewDidLoad()
     changeConstraint(controller: self, view: topView)
        tableView.registerCell(Identifier.infoCell)
        self.navigationController?.navigationBar.isHidden = true
        tableView.reloadData()
       navTitle.text = "Info".localizedString
       self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       }
    
    //MARK: Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
      let language = Localize.currentLang()
      if language == .arabic {
        self.revealViewController().rightRevealToggle(animated: true)
        return
      }
      self.revealViewController().revealToggle(animated: true)
    }
    
    //MARK: View Detail Controller
    func viewDetail(selected: Info) {
      
      if selected == .contactUs {
        let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.contact) as? ContactSupportController else {
          return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        return
      }
      
      let storyBoard = UIStoryboard(name: Identifier.addresFlowStoryBoard, bundle: nil)
      guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifier.contactSupport) as? ContactSupportViewController else {
      return
      }
      vc.navString = selected.infoName.localizedString
      vc.urlString = selected.infoUrl
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  //MARK: UITableView Delegate and Data Source
  extension InfoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return Info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.infoCell) as? InfoCell else {
       fatalError("Could not load InfoCell")
      }
      guard let infoType = Info(rawValue: indexPath.row) else {
        fatalError("not found enum")
      }
      cell.infoName.text = infoType.infoName.localizedString
      cell.infoImage.image = infoType.infoImage
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let infoType = Info(rawValue: indexPath.row) else {
        fatalError("not found enum")
      }
       viewDetail(selected: infoType)
    }
  }

  //MARK: Enum for Info Controller
  enum Info: Int, CaseCountable {
    case faq
    case tc
    case contactUs
    case about
    
    var infoName: String {
      switch self {
      case .faq:
        return "FAQ’s"
      case .tc:
        return "Terms & Conditions"
      case .contactUs:
        return "Contact Us"
      case .about:
        return "About Us"
      }
    }
    
    var infoUrl: String {
      switch self {
      case .faq:
        return "https://admin.foodfox.in/#/page/contentFAQs"
      case .tc:
        return "https://admin.foodfox.in/#/page/contentTermsAndConditions"
      case .contactUs:
        return "https://admin.foodfox.in/#/page/contentPrivacyPolicy"
      case .about:
        return "https://admin.foodfox.in/#/page/contentAboutUs"
      }
    }
    
    var infoImage: UIImage {
      switch self {
      case .faq:
        return #imageLiteral(resourceName: "faq")
      case .tc:
        return #imageLiteral(resourceName: "termcondition")
      case .contactUs:
        return #imageLiteral(resourceName: "infoContact")
      case .about:
        return #imageLiteral(resourceName: "aboutUs")
      }
    }
  }
