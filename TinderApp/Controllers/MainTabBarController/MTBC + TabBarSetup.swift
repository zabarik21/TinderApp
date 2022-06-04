//
//  MTBC + TabBarSetup.swift
//  TinderApp
//
//  Created by Timofey on 4/6/22.
//

import UIKit


extension MainTabBarController {
  // TO-DO: complete floating tabbar setup
  func setupTabBar() {
    let regularConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
    let peopleTabBarImage = UIImage(systemName: "figure.wave", withConfiguration: regularConfiguration)!
    let messagesTabBarImage = UIImage(systemName: "message", withConfiguration: regularConfiguration)!
    let profileTabBarImage = UIImage(systemName: "person", withConfiguration: regularConfiguration)!
    
    setupVCTabBar(viewController: peopleVC, title: "Discover", image: peopleTabBarImage)
    setupVCTabBar(viewController: messagesVC, title: "Messages", image: messagesTabBarImage)
    setupVCTabBar(viewController: profileVC, title: "Profile", image: profileTabBarImage)
    
    tabBar.tintColor = UIColor(named: "selectedBarItemColor")!
    tabBar.backgroundColor = .clear
    viewControllers = [
      peopleVC,
      messagesVC,
      profileVC
    ]
    self.tabBar.itemPositioning = .centered
    
    setupTabBarLayer()
    setupItemLayer()
  }
  
  func setupVCTabBar(viewController: UIViewController, title: String, image: UIImage) {
    viewController.tabBarItem.title = title
    viewController.tabBarItem.image = image
  }
}
