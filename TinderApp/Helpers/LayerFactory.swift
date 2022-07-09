//
//  LayerFactory.swift
//  TinderApp
//
//  Created by Timofey on 9/7/22.
//

import UIKit

class LayerFactory {
  
  static let shared = LayerFactory()
  
  func getGradientLayer(with colors: [UIColor]) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = colors.map({ $0.cgColor })
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    return gradientLayer
  }
  
}
