//
//  OTPView.swift
//  CLApp
//
//  Created by click Labs on 7/19/17.
//  Copyright © 2017 Click-Labs. All rights reserved.
//

import UIKit

class OTPTextField: UITextField {
  
  override var text: String? {
    willSet {
    }
  }
}

class OTPView: UIView {
  
  fileprivate var numberOfField: Int = 4
  private var stackView: UIStackView? {
    didSet {
      stackView?.semanticContentAttribute = .forceLeftToRight
    }
  }
  
  /// Horzontically
  var spacing: CGFloat = 16.0 {
    didSet {
      self.stackView?.spacing = spacing
    }
  }

  // FIXME: Need more work on commented code.
  var textColor: UIColor = .themeColor {
    didSet {
        
    }
  }

  // FIXME: Need more work on commented code.
  var font: UIFont = UIFont(medium: 36.0) {
    didSet {
      
    }
  }
  
  private var textField: OTPTextField = OTPTextField()
  private var completion: ((_ text: String) -> Void)?
  
  private func fields() -> [UILabel] {
    var labels = [UILabel]()
    for iVar in 0..<numberOfField {
      let label = UILabel()
      label.tag = iVar
      label.textAlignment = .center
      label.backgroundColor = .clear
      label.textColor = textColor
        label.tintColor = textColor
      label.font = font
      label.text = ""
      label.semanticContentAttribute = .forceLeftToRight
//      label.layer.borderColor = borderColor?.cgColor
//      label.layer.borderWidth = borderWidth
//      label.layer.cornerRadius = cornerRadius
      labels.append(label)
      
    }
    return labels
  }
  
  private func setupView() {
    stackView = UIStackView(arrangedSubviews: self.fields())
    stackView?.distribution = .fillEqually
    stackView?.alignment = .fill
    stackView?.spacing = spacing
    if let view = stackView {
    self.addSubview(view)
    }
    textField.backgroundColor = .clear
    textField.textColor = .clear
    textField.tintColor = textColor
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.keyboardType = .phonePad
    self.addSubview(textField)
    textField.addTarget(self, action: #selector(OTPView.textFiledEditingChanged), for: .editingChanged)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.semanticContentAttribute = .forceLeftToRight
    self.setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setupView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.stackView?.frame = self.bounds
  }
  
  func completionBlock(completion: @escaping (_ text: String) -> Void) {
    self.completion = completion
  }
  
  func showKeyboard() {
    textField.text = ""
    textField.becomeFirstResponder()
  }
  
  func hideKeyboard() {
    let when = DispatchTime.now() + 0.2
    DispatchQueue.main.asyncAfter(deadline: when) {
      self.textField.resignFirstResponder()
    }
  }
  
  @objc func textFiledEditingChanged() {
    
    let text: String = textField.text ?? ""
    let lenght = text.count
    
    if text.count == 0 {
      if  let label = self.stackView?.arrangedSubviews.first as? UILabel {
        label.text = ""
      }
      return
    }
    
    let subviews = self.stackView?.arrangedSubviews
    let lenghtCount = subviews?.count ?? 0
    
    for iVar in 0..<lenghtCount {
      
      guard let label = subviews?[iVar] as? UILabel else {
        continue
      }
      
      if iVar < lenght {
        let index = text.index(text.startIndex, offsetBy: iVar)
        let charteris = text[index]
        label.text = "\(charteris)"
      } else {
        label.text = ""
      }
      
    }
    
    if lenght == numberOfField {
      self.completion?(text)
      self.hideKeyboard()
      return
    }
  }
  
  func resetOTPText() {
    let subviews = self.stackView?.arrangedSubviews
    for iVar in 0..<numberOfField {
      guard let label = subviews?[iVar] as? UILabel else {
        continue
      }
      label.text = ""
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if textField.isFirstResponder == false {
      textField.becomeFirstResponder()
      textField.text = ""
      self.resetOTPText()
    }
  }
  
}
