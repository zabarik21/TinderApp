//
//  CardView + Gestures.swift
//  TinderApp
//
//  Created by Timofey on 2/6/22.
//

import UIKit

extension CardView: UIGestureRecognizerDelegate {
  
  func animateToIdentity() {
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut) {
      self.transform = .identity
      self.center = self.startPoint
    }
  }
  
  func setupGestures() {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    gestureRecognizer.delegate = self
    addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      startPoint = center
    case .changed:
      onChange(recognizer)
    case .ended:
      gestureEnded()
    @unknown default:
      print("oknown")
    }
  }
  
  func onChange(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self)
    guard let gestureView = recognizer.view else { return }
    
    gestureView.center = CGPoint(x: gestureView.center.x + translation.x * 0.8,
                                 y: gestureView.center.y + translation.y * 0.3)
    
    let xDelta = center.x - startPoint.x
    let angle: CGFloat = CardViewConstants.maxAngle * (CGFloat(xDelta) * 10 / 21)
    self.transform = CGAffineTransform(rotationAngle: angle * .pi/180)
    recognizer.setTranslation(.zero, in: self)
  }
  
  func gestureEnded() {
    let xDelta = center.x - startPoint.x
    if xDelta > CardViewConstants.maxDelta {
      swipe(liked: true)
    } else if xDelta < -CardViewConstants.maxDelta {
      swipe(liked: false)
    } else {
      animateToIdentity()
    }
  }
  
}
