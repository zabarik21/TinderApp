//
//  PVC + UserViewAnimating.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import Foundation
import UIKit

extension PeopleViewController {
  
  func hideView(_ view: MovableView) {
    view.snp.updateConstraints { make in
      make.top.equalTo(self.view.snp.bottom).offset(0)
    }
    UIView.animate(withDuration: PeopleVCConstants.cardDisappearTime * 3, delay: 0) {
      self.view.layoutIfNeeded()
    } completion: { _ in
      self.tabBarController?.setTabBarHidden(false, animated: true, duration: PeopleVCConstants.cardDisappearTime * 2)
      view.toIdentity()
    }
  }
  
  func showHiddenView(_ view: UIView) {
    view.snp.updateConstraints { make in
      make.top.equalTo(self.view.snp.bottom).offset(-self.view.bounds.height)
    }
    
    UIView.animate(withDuration: PeopleVCConstants.cardDisappearTime * 3) {
      view.alpha = 1
      self.view.layoutIfNeeded()
    }
  }
}
