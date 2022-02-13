//
//  CLAPP+EnvConfig.swift
//  CLApp
//
//  Created by cl-macmini-68 on 05/04/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//
//abc
import Foundation

/// xcconfig files environments
///
/// - develop: develop description
/// - test: <#test description#>
/// - client: <#client description#>
/// - live: <#live description#>
/// - unknow: <#unknow description#>

enum AppEnvironment: String {
  
  case develop = "Develop"
  case test = "Test"
  case client = "Client"
  case live = "Live"
  case unknow
  
  func displayName() -> String {
    switch self {
    case .develop:
      return "Dev"
    case .test:
      return "Test"
    case .client:
      return "Client"
    case .live:
      return "Live"
    case .unknow:
      return "Unknow"
    }
  }
  
  func displayImage() -> UIImage? {
    switch self {
    case .develop:
      return nil //#imageLiteral(resourceName: "xcode64")
    case .test:
      return nil
    default:
        return nil
    }
  }
}



// MARK: -
extension AppDelegate {
  
  var baseURL: String {
    
    guard let baseURLString = Bundle.main.infoDictionary?["kBaseURL"] as? String,
      baseURLString.isBlank == false else {
        fatalError("Base url is not set in xcconfig file.")
    }
    return baseURLString
  }
  
  var facebookId: String {
    
    guard let fbID = Bundle.main.infoDictionary?["kFacebookID"] as? String else {
      fatalError("FacebookID is not set in xcconfig file.")
    }
    print("Facebook id\(fbID)")
    return fbID
  }
    var googleClientId: String {
        
        guard let clientID = Bundle.main.infoDictionary?["kGoogleClientID"] as? String else {
            fatalError("clientID is not set in xcconfig file.")
        }
        print("clientID \(clientID)")
        return clientID
    }
  
  var environment: AppEnvironment {
    guard let environment = Bundle.main.infoDictionary?["APP_ENVIRONMENT"] as? String else {
      fatalError("App Environment is not set in '.xcconfig' files.")
    }
    
    if let environment = AppEnvironment(rawValue: environment) {
      return environment
    }
    return .unknow
  }
  
}

// MARK: -
final class EnvironmentView: UIView {
  
  private static let reusableTag: Int = 19417
  private var environment: AppEnvironment = .live
  private var label: UILabel?
  private var imageView: UIImageView?
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.clear
    self.isUserInteractionEnabled = false
    self.clipsToBounds = true
    self.alpha = 1.0
    
  // TODO:  /* Dev and Test icon view if need to show.*/
//    let imgView = UIImageView(frame: self.bounds)
//    imgView.contentMode = .scaleAspectFill
//    imgView.image = nil
//    imgView.alpha = 0.1
//    imgView.clipsToBounds = true
//    self.addSubview(imgView)
//    imageView = imgView
    
    let lbl: UILabel = UILabel(frame: self.bounds)
    lbl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    lbl.textAlignment = .right
    lbl.textColor = .gray
    lbl.font = AppFont.regular(size: 13)
    self.addSubview(lbl)
    label = lbl
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.clipsToBounds = true
    
    if var labelSize = self.label?.sizeThatFits(self.bounds.size) {
      
      labelSize.width += 4.0
      labelSize.height += 4.0
      
      var labelFrame = self.label?.frame ?? CGRect.zero
      labelFrame.origin.x = (self.frame.width - labelSize.width)
      labelFrame.origin.y = (self.frame.height - labelSize.height)
      labelFrame.size = labelSize
      
      self.label?.frame = labelFrame

    }
    
  }
  
  private func showContent() {
    let env = appDelegate.environment
    
    let envStr = env.displayName()
    let version = appDelegate.appVersion
    let name = appDelegate.displayName
    let fullStr = "\(name)_\(envStr)_\(version)"
    
    label?.text = fullStr
    if let image = env.displayImage() {
      imageView?.image = image
    }

  }
  
  private class func viewFrame() -> CGRect {
    
    var windowFrame = CGRect.zero
    if let frame = appDelegate.window?.frame {
      windowFrame = frame
    }
    
    var viewFrame: CGRect = CGRect(x: 50.0, y: 50.0, width: 40.0, height: 40.0)
    viewFrame.origin.x = 0.0
    viewFrame.origin.y = windowFrame.size.height - 25.0
    viewFrame.size.width = windowFrame.size.width
    viewFrame.size.height = 25.0
    return viewFrame
  }
  
  private class func canRegisterView() -> Bool {
    switch appDelegate.environment {
    case .develop:
      return true
    case .test:
      return true
    default:
      return false
    }
  }
  
  class func register() {
    
    if !EnvironmentView.canRegisterView() {
      return
    }
    
    if appDelegate.window?.viewWithTag(EnvironmentView.reusableTag) != nil {
      return
    }
    let farme = EnvironmentView.viewFrame()
    let view = EnvironmentView(frame: farme)
    view.tag = EnvironmentView.reusableTag
//    appDelegate.window?.addSubview(view)
    view.showContent()
  }
  
}
