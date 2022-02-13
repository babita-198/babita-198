      //
      //  ContactSupportViewController.swift
      //  FoodFox
      //
      //  Created by clicklabs on 03/01/18.
      //  Copyright © 2018 Click-Labs. All rights reserved.
      //

      import UIKit
      import WebKit

      class ContactSupportViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
        
        //MARK: Outlet
        @IBOutlet weak var navTitle: UILabel!
        @IBOutlet weak var webKitView: WKWebView!
        @IBOutlet weak var backBtn: UIButton!
        @IBOutlet weak var customView: UIView!

        //MARK: Variables
        var urlString: String = ""
        var navString: String = ""
        
        //MARK: View Did load
        override func viewDidLoad() {
            super.viewDidLoad()
              
            self.loadWeb()
            webKitView.scrollView.bounces = false
            customView.addSubview(LoadingTaskView.loadingTaskView(view: customView))
            customView.isHidden = true
            backBtn.changeBackBlackButton()
          }
        
        //MARK: Func Load Web
        func loadWeb() {
          guard let url = URL(string: self.urlString) else {
            print("Error - > Not valid URL")
            return
          }
            let requestObj = URLRequest(url: url)
            webKitView.load(requestObj)
        }
        
        //MARK: ViewWill Appear
        override func viewWillAppear(_ animated: Bool) {
          navTitle.text = navString
        }
        
        //MARK: Back Button Action
        @IBAction func backAction(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
        }
        
      }
