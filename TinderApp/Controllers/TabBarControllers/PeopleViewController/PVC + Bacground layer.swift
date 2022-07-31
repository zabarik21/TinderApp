//
//  MTBC + Bacground layer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit


extension PeopleViewController {
  
  func setupGradientLayer() {
    gradientLayer = LayerFactory.shared.getGradientLayer()
    gradientLayer.mask = headerOvalLayerMask
    self.view.layer.addSublayer(gradientLayer)
  }
  
  func actualizePath() {
    let width = Int(view.bounds.width * PeopleVCConstants.ovalWidthMultiplier)
    let height = Int(view.bounds.height * PeopleVCConstants.ovalHeightMultiplier)
    let x = Int(self.view.center.x) - width / 2
    let y = -Int(self.view.bounds.maxY * 0.1)
    let path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: Int(width), height: height)).cgPath
    headerOvalLayerMask.path = path
    gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(width), height: height)
  }
  
  func setupHeaderOvalLayer() {
    setupGradientLayer()
    actualizePath()
  }
  
}
