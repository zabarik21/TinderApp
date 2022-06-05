//
//  MainTabBarController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit
import SnapKit

enum ViewControllers: Int {
  case people
  case messages
  case profile
}

enum Constants  {
  static let ovalHeight: Int = 313
  static var cardContainer: Int = 485
  static var cardDisappearTime: CGFloat = 0.5
  static var cardContainerHorizontalOffset: Int = 37
  static var tabBarLayerHorizontalPadding: CGFloat = 26
  static var tabBarLayerVerticalPadding: CGFloat = 5
}

class MainTabBarController: UITabBarController {
  
  lazy var peopleVC = PeopleViewController()
  lazy var messagesVC = MessagerViewController()
  lazy var profileVC = ProfileViewController()
  
  let tabBarLayer = CAShapeLayer()
  let itemLayer = CAShapeLayer()
  var layerHeight = CGFloat()
  var layerWidth = CGFloat()
  var itemWidth = CGFloat()
  let appearence = UITabBarAppearance()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
  }
    
}

extension MainTabBarController: CardContainerDelagate {
  
  func usersLoaded() {
    print("loaded")
  }
  
  
  func getNextUser(_ cardContainer: CardContainerView) -> UserCardViewViewModelProtocol {
    return UserCardViewViewModel()
  }

}


extension MainTabBarController {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let index = tabBar.items?.firstIndex(of: item) else { return }
    
    var padding: CGFloat {
      let vc = ViewControllers(rawValue: index)
      switch vc {
      case .people:
        return 3
      case .profile:
        return -3
      case .messages:
        return 0
      case .none:
        return 0
      }
    }
    itemLayer.frame.origin.x = CGFloat((index)) * itemWidth + padding
  }
}
