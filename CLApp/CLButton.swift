//
//  CLButton.swift
//  CLApp
//
//  Created by Hardeep Singh on 12/4/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

typealias CLButtonActionCallBack = (_ sender: CLButton) -> Void

class CLButton: UIButton {
  
  private var highlightLayer: CALayer?
  private var actionCallBack: CLButtonActionCallBack?
  
  // MARK: - Init
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    defaultInit()
  }
  
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - x: <#x description#>
  ///   - y: <#y description#>
  ///   - width: <#width description#>
  ///   - height: <#height description#>
  init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
    super.init(frame: CGRect(x: x, y: y, width: width, height: height))
    defaultInit()
  }
  
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - x: <#x description#>
  ///   - y: <#y description#>
  ///   - width: <#width description#>
  ///   - height: <#height description#>
  ///   - action: <#action description#>
  init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, action: CLButtonActionCallBack?) {
    super.init (frame: CGRect(x: x, y: y, width: width, height: height))
    self.actionCallBack = action
    defaultInit()
  }
  
  /// <#Description#>
  ///
  /// - Parameter action: <#action description#>
  init(action: @escaping CLButtonActionCallBack) {
    super.init(frame: CGRect.zero)
    self.actionCallBack = action
    defaultInit()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    defaultInit()
  }
  
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - frame: <#frame description#>
  ///   - action: <#action description#>
  init(frame: CGRect, action:  @escaping CLButtonActionCallBack) {
    super.init(frame: frame)
    self.actionCallBack = action
    defaultInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    defaultInit()
  }
  
  func addAction(actionCallBack: @escaping CLButtonActionCallBack) {
    self.actionCallBack = actionCallBack
  }
  
  private func defaultInit() {
    addTarget(self, action: #selector(CLButton.didPressed(_:)), for: UIControl.Event.touchUpInside)
    addTarget(self, action: #selector(CLButton.highlight), for: [
                UIControl.Event.touchDown,
                UIControl.Event.touchDragEnter])
    addTarget(self, action: #selector(CLButton.unhighlight), for: [
        UIControl.Event.touchUpInside,
        UIControl.Event.touchUpOutside,
        UIControl.Event.touchCancel,
        UIControl.Event.touchDragExit
      ])
    //            setTitleColor(UIColor.black, for: UIControlState.normal)
    //            setTitleColor(UIColor.blue, for: UIControlState.selected)
  }
  
  // MARK: Action
  @objc private func didPressed(_ sender: CLButton) {
    self.actionCallBack?(sender)
  }
  
  // MARK: Highlight
  
  @objc private func highlight() {
    let highlightLayer = CALayer()
    highlightLayer.frame = layer.bounds
    highlightLayer.backgroundColor = UIColor.black.cgColor
    highlightLayer.opacity = 0.5
    var maskImage: UIImage? = nil
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, 0)
    if let context = UIGraphicsGetCurrentContext() {
      layer.render(in: context)
      maskImage = UIGraphicsGetImageFromCurrentImageContext()
    }
    UIGraphicsEndImageContext()
    let maskLayer = CALayer()
    maskLayer.contents = maskImage?.cgImage
    maskLayer.frame = highlightLayer.frame
    highlightLayer.mask = maskLayer
    layer.addSublayer(highlightLayer)
    self.highlightLayer = highlightLayer
  }
  
  @objc private func unhighlight() {
    //        if action == nil {
    //            return
    //        }
    highlightLayer?.removeFromSuperlayer()
    highlightLayer = nil
  }
  
}
