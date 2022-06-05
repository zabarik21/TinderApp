//
//  CardView + Gestures.swift
//  TinderApp
//
//  Created by Timofey on 2/6/22.
//

import UIKit

extension CardView {
  
  func animateToIdentity() {
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut) {
      self.transform = .identity
      self.center = self.startPoint
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    anchorPoint.x = touches.first!.location(in: window).x - frame.minX
    anchorPoint.y = touches.first!.location(in: window).y - frame.minY
    
    startPoint = center
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let deltaX = (touches.first!.location(in: window).x) - anchorPoint.x
    let deltaY = (touches.first!.location(in: window).y) - anchorPoint.y
    
    let angle: CGFloat = CardViewConstants.maxAngle * (CGFloat(deltaX) * 10 / 33)
    
    let x = (deltaX / 2  + (self.bounds.width / 2))
    let y = (deltaY / 5  + (self.bounds.height / 2))
    
    self.transform = CGAffineTransform(rotationAngle: angle * .pi/180)
    self.center.x = x
    self.center.y = y
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let delta = (touches.first!.location(in: window).x) - anchorPoint.x
    if delta > CardViewConstants.maxDelta {
      swipe(liked: true)
    }
    else if delta < -CardViewConstants.maxDelta {
      swipe(liked: false)
    }
    else {
      animateToIdentity()
    }
  }
  
}
