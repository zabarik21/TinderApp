//
//  UserView + Gestures.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit


extension UserView: UIGestureRecognizerDelegate {
  
  func setupGestures() {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    gestureRecognizer.delegate = self
    addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let velocity = recognizer.velocity(in: self)
    switch recognizer.state {
    case .began:
      break
    case .changed:
      onChange(recognizer)
    case .ended:
      gestureEnded(with: velocity.y)
      break
    @unknown default:
      print("oknown")
    }
  }
  
  func onChange(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self)
    if (frame.minY <= 0 && translation.y < 0) { return }
    guard let gestureView = recognizer.view else { return }
    let yDelta = center.y
    gestureView.center = CGPoint(x: center.x,
                                 y: yDelta + translation.y)
    recognizer.setTranslation(.zero, in: self)
  }
  
  func gestureEnded(with velocity: CGFloat) {
    if velocity > 1000 || frame.minY > (self.viewHieght / 3) {
      hide()
    } else {
      UIView.animate(withDuration: Constants.viewDissappearTime) {
        self.center.y = self.viewHieght / 2
      }
    }
  }
  
}
