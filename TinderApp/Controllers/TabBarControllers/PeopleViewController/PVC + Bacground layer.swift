//
//  MTBC + Bacground layer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit



extension PeopleViewController {
  
  func setupGradientLayer() {
    gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor(named: "firstGradientColor")!.cgColor,
      UIColor(named: "secondGradientColor")!.cgColor
    ]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    
    gradientLayer.mask = headerOvalLayerMask
    self.view.layer.addSublayer(gradientLayer)
  }
  
  func setupHeaderOvalLayer() {
    setupGradientLayer()
    actualizePath()
  }
  
}
