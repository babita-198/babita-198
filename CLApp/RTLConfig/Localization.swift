//
//  Localization.swift
//  KurdTaxi
//
//  Created by Cl-macmini-100 on 6/12/17.
//  Copyright © 2017 Click Lab 100. All rights reserved.
//

import Foundation

let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/**
 - Listen for this notification for update UI for new Language.
 */
enum Language {
  case english
  case arabic

  var selectLanguage: String {
    switch self {
    case .english:
        return "en"
    case .arabic:
        return "en"
    }
  }

  static func getLanguageFromString(langString: String) -> Language {
    switch langString {
    case "en":
      return .english
    case "en":
      return .arabic
    default:
      return .english
    }
  }
}

//MARK: TextField Extension for Alignment of text from left to right and right to left
extension UITextField {
  func changeAlignment() {
    if Localize.currentLang() == .english {
      self.textAlignment = .left
    } else {
      self.textAlignment = .left
    }
  }
}

extension UITextView {
    func changeTextViewAlignment() {
        if Localize.currentLang() == .english {
            self.textAlignment = .left
        } else {
            self.textAlignment = .left
        }
    }
}

//MARK: TextField Extension for Alignment of text from left to right and right to left
extension UIButton {
    
    func changeBackBlackButton() {
        if Localize.currentLang() == .english {
            self.setImage(#imageLiteral(resourceName: "Back_Pink"), for: .normal )
            self.tintColor = lightBlackColor
        } else {
             self.setImage(#imageLiteral(resourceName: "Back_Pink"), for: .normal )
            self.tintColor = lightBlackColor
        }
    }
    
    func changeBackWhiteButton() {
        if Localize.currentLang() == .english {
            self.setImage(#imageLiteral(resourceName: "Back_Pink"), for: .normal )
            self.tintColor = .white
        } else {
            self.setImage(#imageLiteral(resourceName: "Back_Pink"), for: .normal )
            self.tintColor = .white
        }
    }
    
    func changeBackRedButton() {
        if Localize.currentLang() == .english {
            self.setImage(#imageLiteral(resourceName: "Back_Pink"), for: .normal )
            self.tintColor = darkPinkColor
        } else {
             self.setImage(#imageLiteral(resourceName: "Back_Pink"), for: .normal )
                self.tintColor = darkPinkColor
        }
    }
    
    func changeBackRedEditButton() {
        if Localize.currentLang() == .english {
            self.setImage(#imageLiteral(resourceName: "backMarker"), for: .normal )
            self.tintColor = darkPinkColor
        } else {
             self.setImage(#imageLiteral(resourceName: "backMarker"), for: .normal )
            self.tintColor = darkPinkColor
        }
    }
}

// MARK: Language Setting Functions
open class Localize: NSObject {
  /**
     List available languages
   - Returns: Array of available languages.
  */
  open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
    var availableLanguages = Bundle.main.localizations
    if let indexOfBase = availableLanguages.index(of: "Base"), excludeBase == true {
      availableLanguages.remove(at: indexOfBase)
    }
    return availableLanguages
  }
  
  
  /**
   Current language
   - Returns: The current language. String.
   */
  open class func currentLanguage() -> String {
    if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
      return currentLanguage
    }
    return defaultLanguage()
  }
  
  /**
   */
  class func currentLanguage() -> Language {
    if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
    let lang = Language.getLanguageFromString(langString: currentLanguage)
    setSemanticAttributes(language: lang)
    return lang
  }
    return .english
 }
  
  
  class func currentLang() -> Language {
    if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
      let lang = Language.getLanguageFromString(langString: currentLanguage)
      return lang
    }
    return .english
  }
  
  /**
   Change the current language
   - Parameter language: Desired language.
   */
  open class func setCurrentLanguage(_ language: String) {
    let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
    if selectedLanguage != currentLanguage() {
      //TODO:- Set Semantics here.
      UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
      UserDefaults.standard.synchronize()
      //NotificationCenter.default.post(name: Notification.Name.LanguageManagment.languageChanged, object: nil)
    }
  }

  static func setSemanticAttributes(language: Language) {
    switch language {
    case .english:
      UIView.appearance().semanticContentAttribute = .forceLeftToRight
    case .arabic:
     UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
  }
  
  /**
   Change the current language
   - Parameter language: Desired language.
   */
  class func setCurrentLanguage(_ language: Language) {
    let langString = getLanguageString(language: language)
    let selectedLanguage = availableLanguages().contains(langString) ? langString : defaultLanguage()
   // if selectedLanguage != currentLanguage() {
      setSemanticAttributes(language: language)
      UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
      UserDefaults.standard.synchronize()
   // }
  }
  
  class func getLanguageString(language: Language) -> String {
    switch language {
    case .english:
      return "en"
    case .arabic:
      return "en"
    }
  }
  
  /**
   Default language
   - Returns: The app's default language. String.
   */
  open class func defaultLanguage() -> String {
    var defaultLanguage: String = String()
    guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
      return LCLDefaultLanguage
    }
    let availableLanguages: [String] = self.availableLanguages()
    if availableLanguages.contains(preferredLanguage) {
      defaultLanguage = preferredLanguage
    } else {
      defaultLanguage = LCLDefaultLanguage
    }
    return defaultLanguage
  }
  
  /**
   Resets the current language to the default
   */
  open class func resetCurrentLanguageToDefault() {
    setCurrentLanguage(self.defaultLanguage())
  }
  
  /**
   Get the current language's display name for a language.
   - Parameter language: Desired language.
   - Returns: The localized string.
   */
  open class func displayNameForLanguage(_ language: String) -> String {
    let locale: NSLocale = NSLocale(localeIdentifier: currentLanguage())
    if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
      return displayName
    }
    return String()
  }
}
