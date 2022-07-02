//
//  PVC + UserViewDelegate.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import Foundation

extension PeopleViewController: UserViewDelegate {
  
  func hided() {
    self.tabBarController?.setTabBarHidden(false, animated: true, duration: PeopleVCConstants.cardDisappearTime)
  }
  
  
}
