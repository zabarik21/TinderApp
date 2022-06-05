//
//  MTB + CardContainerDelegate.swift
//  TinderApp
//
//  Created by Timofey on 5/6/22.
//

import Foundation


extension MainTabBarController: CardContainerDelagate {
  
  func usersLoaded() {
    print("loaded")
  }

  func getNextUser(_ cardContainer: CardContainerView) -> UserCardViewViewModelProtocol {
    return UserCardViewViewModel()
  }

}
