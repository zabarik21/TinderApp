//
//  MTBC + TabBarLayers.swift
//  TinderApp
//
//  Created by Timofey on 1/6/22.
//

import UIKit


extension MainTabBarController {
  
  func setupTabBarLayer() {
    let x: CGFloat = Constants.tabBarLayerHorizontalPadding
    let y: CGFloat = Constants.tabBarLayerVerticalPadding
    let width = self.tabBar.bounds.width - x * 2
    let height = CGFloat(Int(self.tabBar.bounds.height + y * 1.5))
    layerHeight = height
    layerWidth = width
    tabBarLayer.fillColor = UIColor.white.cgColor
    tabBarLayer.borderColor = UIColor.black.cgColor
    tabBarLayer.borderWidth = 0.1
    tabBarLayer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                        y: self.tabBar.bounds.minY - y * 0.5,
                                                        width: width,
                                                        height: height),
                                    cornerRadius: height / 2).cgPath
    
    tabBarLayer.shadowPath = tabBarLayer.path
    tabBarLayer.shadowColor = UIColor.black.cgColor
    tabBarLayer.shadowOffset = CGSize(width: 0, height: 1)
    tabBarLayer.shadowOpacity = 0.6
    
    self.tabBarLayer.shadowRadius = 4
    
    self.tabBar.layer.insertSublayer(tabBarLayer, at: 0)
  }
  
  func setupItemLayer() {
    let width = layerWidth / 3
    let height = layerHeight - 4
    let x = Constants.tabBarLayerHorizontalPadding + 3
    
    
    
    
    itemLayer.fillColor = UIColor(named: "itemLayerColor")!.cgColor
    itemLayer.opacity = 0.69
    itemLayer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                      y: -0.5,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height /  2).cgPath
    
    tabBarLayer.insertSublayer(itemLayer, at: 0)
  }
  
}

