//
//  LiveZillaChatVc.swift
//  FoodFox
//
//  Created by komal on 15/05/18.
//  Copyright © 2018 Click-Labs. All rights reserved.
//

import UIKit
import WebKit

class LiveZillaChatVc: UIViewController, WKUIDelegate {
    
    /// Outlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebView()
        // Do any additional setup after loading the view.
    }

    /// Setting Up Web View UI
    func setUpWebView() {
        let language = Localize.currentLang()
        if language == .arabic {
            self.outerView.semanticContentAttribute = .forceRightToLeft
        } else {
        self.outerView.semanticContentAttribute = .forceLeftToRight
        }
        titleLabel.text = "ChatSupport".localizedString
        backBtn.changeBackBlackButton()
        webKitView.scrollView.showsVerticalScrollIndicator = false
        webKitView.scrollView.showsHorizontalScrollIndicator = false
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        checkStatusForDarkMode()
    }
    
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    func checkStatusForDarkMode( ) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            self.outerView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
            self.titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.backBtn.setImage(#imageLiteral(resourceName: "newBack"), for: .normal)
            
        } else {
            self.outerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.titleLabel.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
             self.backBtn.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
             
        }
    }
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// loading webview in uiview
    func loadWebView() {
        guard let url = URL(string: "https://livezilla.foodfox.in/chat.php?s=1") else {
            return
        }
        let paymentURl = NSURLRequest(url: url) as URLRequest
        webKitView.load(paymentURl)
    }
    
    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
        let language = Localize.currentLang()
        if language == .arabic {
            self.revealViewController().rightRevealToggle(animated: true)
            return
        }
        self.revealViewController().revealToggle(animated: true)
        }
    }
}
