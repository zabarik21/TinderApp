//
//  MTBC + TabBarLayers.swift
//  TinderApp
//
//  Created by Timofey on 1/6/22.
//

import UIKit


extension MainTabBarController {
  
  func setupTabBarLayer() {
    let x: CGFloat = self.view.bounds.width * MainTabBarVCConstants.tabBarLayerHorizontalPaddingMultiplier
    let y: CGFloat = MainTabBarVCConstants.tabBarLayerVerticalPadding
    layerHeight = CGFloat(Int(self.tabBar.bounds.height + y * 1.5))
    layerWidth = self.tabBar.bounds.width - x * 2
    tabBarLayer.fillColor = UIColor.white.cgColor
    tabBarLayer.borderColor = UIColor.black.cgColor
    tabBarLayer.borderWidth = 0.1
    tabBarLayer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                        y: self.tabBar.bounds.minY - y * 0.5,
                                                        width: layerWidth,
                                                        height: layerHeight),
                                    cornerRadius: layerHeight / 2).cgPath
    tabBarLayer.shadowPath = tabBarLayer.path
    tabBarLayer.shadowColor = UIColor.black.cgColor
    tabBarLayer.shadowOffset = CGSize(width: 0, height: 1)
    tabBarLayer.shadowOpacity = 0.6
    self.tabBarLayer.shadowRadius = 4
    self.tabBar.layer.insertSublayer(tabBarLayer, at: 0)
  }
  
  func actualizePath() {
    let x: CGFloat = self.view.bounds.width * MainTabBarVCConstants.tabBarLayerHorizontalPaddingMultiplier
    let y: CGFloat = MainTabBarVCConstants.tabBarLayerVerticalPadding
    layerWidth = self.tabBar.bounds.width - x * 2
    tabBarLayer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                        y: self.tabBar.bounds.minY - y * 0.5,
                                                        width: layerWidth,
                                                        height: layerHeight),
                                    cornerRadius: layerHeight / 2).cgPath
  }
  
  func setupItemLayer() {
    let width = layerWidth / 3
    itemWidth = width
    let height = layerHeight - 4
    let x = MainTabBarVCConstants.tabBarLayerHorizontalPaddingMultiplier * self.view.bounds.width
    
    itemLayer.fillColor = UIColor(named: "itemLayerColor")!.cgColor
    itemLayer.opacity = 0.69
    itemLayer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                      y: -0.5,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height /  2).cgPath
    
    tabBarLayer.insertSublayer(itemLayer, at: 0)
  }
  
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

