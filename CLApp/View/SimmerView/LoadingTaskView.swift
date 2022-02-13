//
//  LoadingTaskView.swift
//  Tookan
//
//  Created by cl-macmini-45 on 05/04/17.
//  Copyright © 2017 Click Labs. All rights reserved.
//

import UIKit

class LoadingTaskView: UIView {
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var shimmerView: FBShimmeringView!
  
  override func awakeFromNib() {
    self.shimmerView.contentView = self.imageView
    self.shimmerView.isShimmering = true
    self.shimmerView.shimmeringPauseDuration = 0.1
    self.shimmerView.shimmeringAnimationOpacity = 0.5
    self.shimmerView.shimmeringOpacity = 1.0
    self.shimmerView.shimmeringSpeed = 300
    self.shimmerView.shimmeringHighlightLength = 0.5
    self.shimmerView.shimmeringDirection = FBShimmerDirection.right
    self.shimmerView.shimmeringBeginFadeDuration = 0.1
    self.shimmerView.shimmeringEndFadeDuration = 0.3
  }
  
  static func loadingTaskView(view: UIView) -> LoadingTaskView {
    guard let loadingView = Bundle.main.loadNibNamed("LoadingTaskView", owner: self, options: nil)?.first as? LoadingTaskView else {
      fatalError()
    }
    loadingView.frame = view.frame
    loadingView.layoutIfNeeded()
    view.addSubview(loadingView)
    return loadingView
  }
  
  
}
