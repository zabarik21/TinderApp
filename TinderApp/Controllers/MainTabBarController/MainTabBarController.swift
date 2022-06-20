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
  static var cardContainerHeightMultiplier: CGFloat = 0.553
  static var cardDisappearTime: CGFloat = 0.1
  static var cardContainerHorizontalOffsetMultiplier: CGFloat = 0.0986
  static var buttonsHorizontalOffsetMultiplier: CGFloat = 0.24
  static var buttonsBottomOffsetMultiplier: CGFloat = 0.141
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

