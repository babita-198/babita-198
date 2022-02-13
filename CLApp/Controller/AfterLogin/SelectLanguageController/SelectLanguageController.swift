//
//  SelectLanguageController.swift
//  FoodFox
//
//  Created by clicklabs on 29/12/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit
//import SDKDemo1
//import MZFayeClient
//import Hippo
//MARK: Selected Language Enum
enum SelectedLanguage {
  case english
  case arabic
}

class SelectLanguageController: UIViewController, UIGestureRecognizerDelegate {
  
  //MARK: Outlets
  @IBOutlet weak var arabicImage: UIImageView!
  @IBOutlet weak var englishImage: UIImageView!
  @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var arabicBtn: UIButton! {
        didSet {
            arabicBtn.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var englishBtn: UIButton! {
        didSet {
            englishBtn.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
    @IBOutlet weak var languageTitle: UILabel! {
        didSet {
            languageTitle.font = AppFont.semiBold(size: 18)
        }
    }
    @IBOutlet weak var selectedBtn: UIButton! {
        didSet {
            selectedBtn.titleLabel?.font = AppFont.semiBold(size: 15)
        }
    }
  
  //MARK: Variables
  var selectedLangaue: SelectedLanguage = .english
  var yesCancelCallback: (() -> Void)?

  //MARK: View Did load
  override func viewDidLoad() {
       super.viewDidLoad()
       self.setUpLangauge()
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTaped))
       tapGesture.delegate = self
       self.view.addGestureRecognizer(tapGesture)
      localizedString()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        checkStatusForDarkMode()
    }
    
    
    //MARK:- CHECK STATUS FOR NIGHT MODE
    
    func checkStatusForDarkMode( ) {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")  // Retrieve the state
        if isDarkMode == true {
            languageView.backgroundColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            languageTitle.textColor = lightWhite
            arabicBtn.setTitleColor(lightWhite, for: .normal)
            englishBtn.setTitleColor(lightWhite, for: .normal)
        } else {
            languageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            languageTitle.textColor = #colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1)
            arabicBtn.setTitleColor(#colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1), for: .normal)
            englishBtn.setTitleColor(#colorLiteral(red: 0.1260324419, green: 0.1292469203, blue: 0.1336024106, alpha: 1), for: .normal)
        }
    }
  //MARK: Localized String
  func localizedString() {
    languageTitle.text = "Select Language".localizedString
    selectedBtn.setTitle("SELECT".localizedString, for: .normal)
  }
  
  //MARK: View Did Taped
  @objc func viewTaped() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view?.isDescendant(of: languageView) ?? false {
      return false
    }
    return true
  }
  
  
  //MARK: SetUp Selected Language
  func setUpLangauge() {
    let language = Localize.currentLang()
    if language == .english {
      arabicImage.image = #imageLiteral(resourceName: "radioOff")
      englishImage.image = #imageLiteral(resourceName: "radioOn")
      selectedLangaue = .english
    } else {
      arabicImage.image = #imageLiteral(resourceName: "radioOn")
      englishImage.image = #imageLiteral(resourceName: "radioOff")
     selectedLangaue = .arabic
    }
  }
  
  //MARK: English language selected
  @IBAction func englishLanguage(_ sender: UIButton) {
   arabicImage.image = #imageLiteral(resourceName: "radioOff")
   englishImage.image = #imageLiteral(resourceName: "radioOn")
    selectedLangaue = .english
  }
  
  //Mark: arabic language selected
  @IBAction func arabicLanguage(_ sender: UIButton) {
    arabicImage.image = #imageLiteral(resourceName: "radioOn")
    englishImage.image = #imageLiteral(resourceName: "radioOff")
    selectedLangaue = .arabic
  }
  
    func langaugeUpdate() {
        
        NotificationModel.updateNotificationSettingLanguage(callBack: {(data: [String: Any]?, error: Error?) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
                if let call = self.yesCancelCallback {
                    call()
                }
            }
        })
    }
    
  //MARK: Select A Language
  /// - check selected language and match with default selected langauge
  @IBAction func selectLanguageAction(_ sender: UIButton) {
    
    let language = Localize.currentLang()
    if language == .english && selectedLangaue == .english {
    self.dismiss(animated: true, completion: nil)
      return
    } else if language == .arabic && selectedLangaue == .arabic {
      self.dismiss(animated: true, completion: nil)
      return
    }
    
    if selectedLangaue == .english {
      Localize.setCurrentLanguage(.english)
    } else {
      Localize.setCurrentLanguage(.english)
    }
   // let hippotheme = HippoTheme.defaultTheme()
    let lang = Localize.currentLang()
//    if lang == .english {
//        hippotheme.leftBarButtonImage = #imageLiteral(resourceName: "ic_back")
//    } else {
//        hippotheme.leftBarButtonImage = #imageLiteral(resourceName: "ic_back")
  //  }    
    if let call = yesCancelCallback {
        if LoginManagerApi.share.isAccessTokenValid {
          self.langaugeUpdate()
          return
        }
        self.dismiss(animated: true, completion: nil)
        call()
    }
    
  }
}
