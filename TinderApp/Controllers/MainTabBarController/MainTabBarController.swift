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
  
  
  
  let user = UserCardModel(name: Name(first: "Тимофей", last: "Резвых"),
                           gender: .male,
                           location: Location(city: "Perm",
                                              coordinates: Coordinates(latitude: "2", longitude: "3")),
                           birthDate: .init(date: "03.03.02", age: 19),
                           picture: WebImage(large: "https://vgmsite.com/soundtracks/spongebob-battle-for-bikini-bottom-gc-xbox-ps2/coverart.jpg",
                                             thumbnail: "https://prodigits.co.uk/thumbs/android-games/thumbs/s/1396790468.jpg"),
                           id: ID.init(value: "id"),
                           interests: Interest.getAllCases())
  
  lazy var peopleVC = PeopleViewController(user: user)
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

