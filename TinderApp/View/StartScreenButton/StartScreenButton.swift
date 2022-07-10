//
//  StartScreenButton.swift
//  TinderApp
//
//  Created by Timofey on 10/7/22.
//

import UIKit
import SwiftUI

enum ButtonStyle {
  case dark
  case light
  case demoApp
}

class StartScreenButton: UIButton {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = self.bounds.height / 2
    gradientLayer?.cornerRadius = self.bounds.height / 2
    gradientLayer?.frame = self.bounds
  }
  
  private var gradientLayer: CAGradientLayer?
  
  init(with style: ButtonStyle, title: String) {
    super.init(frame: .zero)
    setupButton(with: style)
    setTitle(title, for: .normal)
  }
  
  private func setupButton(with style: ButtonStyle) {
    if style == .demoApp {
      gradientLayer = LayerFactory.shared.getGradientLayer()
      gradientLayer?.frame = self.bounds
      layer.insertSublayer(gradientLayer!, at: 0)
      setTitleColor(.white, for: .normal)
      setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
      titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
      addALayerAnimation()
    } else {
      let titleColor: UIColor = ((style == .dark) ? .white : .black)
      let buttonBackgroundColor: UIColor = ((style == .light) ? .white : .black.withAlphaComponent(0.5))
      setTitleColor(titleColor, for: .normal)
      setTitleColor(titleColor.withAlphaComponent(0.5), for: .highlighted)
      
      backgroundColor = buttonBackgroundColor
      titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }
  }
  
  private func addALayerAnimation() {
    let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
    startPointAnimation.fromValue = CGPoint(x: 0.0, y: 0.0)
    startPointAnimation.toValue = CGPoint(x: 1.0, y: 0.0)
    startPointAnimation.duration = 3.0
    startPointAnimation.repeatCount = Float.infinity
    startPointAnimation.autoreverses = true
    
    let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
    endPointAnimation.fromValue = CGPoint(x: 1.0, y: 1.0)
    endPointAnimation.toValue = CGPoint(x: 0.0, y: 1.0)
    endPointAnimation.duration = 3.0
    endPointAnimation.repeatCount = Float.infinity
    endPointAnimation.autoreverses = true
    
    gradientLayer?.add(startPointAnimation, forKey: nil)
    gradientLayer?.add(endPointAnimation, forKey: nil)
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
