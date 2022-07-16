//
//  LayerFactory.swift
//  TinderApp
//
//  Created by Timofey on 9/7/22.
//

import UIKit

class LayerFactory {
  
  static var shared: LayerFactory {
    let shared = LayerFactory()
    return shared
  }
  
  private init() {}
  
  func getGradientLayer(with colors: [UIColor] = [.firstGradientColor, .secondGradientColor], locations: [NSNumber] = [0.0, 1.0], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0), type: CAGradientLayerType = .axial) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = colors.map({ $0.cgColor })
    gradientLayer.locations = locations
    gradientLayer.type = type
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    return gradientLayer
  }
  
}
