//
//  MovableView.swift
//  TinderApp
//
//  Created by Timofey on 31/7/22.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

protocol MovableView: UIView, UIGestureRecognizerDelegate {
  var viewHieght: CGFloat! { get set }
  func toIdentity()
  var hideViewPublishRelay: PublishRelay<Void> { get }
  var hideViewObservable: Observable<Void> { get }
  func setupGestures(action: Selector)
}


extension MovableView {
  
  func setupGestures(action: Selector) {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: action)
    gestureRecognizer.delegate = self
    addGestureRecognizer(gestureRecognizer)
  }
  
  func onChange(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self)
    let minY = frame.minY
    let translationY = translation.y
    if minY <= 0 && translationY <= 0 { return }
    guard let gestureView = recognizer.view else { return }
    let yDelta = center.y
    gestureView.center = CGPoint(
      x: center.x,
      y: yDelta + translationY)
    recognizer.setTranslation(.zero, in: self)
  }
  
  func gestureEnded(with velocity: CGFloat) {
    if velocity > 1000 || frame.minY > (self.viewHieght / 3) {
      self.hideViewPublishRelay.accept(())
    } else {
      UIView.animate(withDuration: Constants.viewDissappearTime) {
        self.center.y = self.viewHieght / 2
      }
    }
  }
}
