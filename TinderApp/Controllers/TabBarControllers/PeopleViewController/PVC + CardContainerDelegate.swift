//
//  PVC + CardContainerDelegate.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit

extension PeopleViewController: CardContainerDelagate {
  
  func cardTouched(with viewModel: UserCardViewViewModelProtocol?) {
    self.tabBarController?.setTabBarHidden(true, animated: true, duration: PeopleVCConstants.cardDisappearTime)
    userView.viewModel.accept(viewModel)
    showUserView()
  }
  
}
