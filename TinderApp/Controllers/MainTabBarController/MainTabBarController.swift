//
//  MainTabBarController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit
import SnapKit


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
  let appearence = UITabBarAppearance()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
  }
    
}

extension MainTabBarController: CardContainerDelagate {
  
  func getNextUser(_ cardContainer: CardContainerView) -> UserCardViewViewModelProtocol {
    return UserCardViewViewModel()
  }

}
