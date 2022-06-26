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

enum MainTabBarVCConstants  {
  static var tabBarLayerHorizontalPaddingMultiplier: CGFloat = 0.0695
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
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    actualizePath()
  }
    
}

