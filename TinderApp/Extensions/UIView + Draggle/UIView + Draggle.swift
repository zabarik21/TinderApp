//
//  UIView + Draggle.swift
//  TinderApp
//
//  Created by Timofey on 13/7/22.
//

import Foundation
import UIKit


extension UIView {
  
  func twitch() {
    UIView.animateKeyframes(withDuration: 0.7, delay: 0.1, options: .calculationModeCubic) {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
        self.transform = CGAffineTransform(translationX: 8, y: 0)
      }
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
        self.transform = CGAffineTransform(translationX: -8, y: 0)
      }
      UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
        self.transform = .identity
      }
    }
  }
  
}
