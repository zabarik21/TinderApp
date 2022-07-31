//
//  UIViewController + TabBar.swift
//  TinderApp
//
//  Created by Timofey on 26/6/22.
//

import UIKit


extension UITabBarController {
  func setTabBarHidden(_ hidden: Bool, animated: Bool, duration: TimeInterval) {
    guard self.tabBarController?.tabBar.isHidden != hidden else { return }
    if animated {
      let frame = self.tabBar.frame
      let sign: CGFloat = hidden ? 1 : -1
      let y = frame.origin.y + (frame.size.height * sign * 1.2)
      UIView.animate(withDuration: duration) {
        self.tabBar.frame.origin.y = y
      }
      return
    }
    self.tabBarController?.tabBar.isHidden = hidden
  }
}
