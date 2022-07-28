//
//  BounceScrollView.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import UIKit

class BounceScrollView: UIScrollView {
  
  var scrollPoints: CGFloat
  
  init(maximumScroll: CGFloat) {
    self.scrollPoints = maximumScroll
    super.init(frame: .zero)
    self.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


extension BounceScrollView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrolledY = scrollView.contentOffset.y
    if (scrolledY < -scrollPoints) {
      scrollView.contentOffset = CGPoint(x: 0, y: -scrollPoints)
    }
  }
}
