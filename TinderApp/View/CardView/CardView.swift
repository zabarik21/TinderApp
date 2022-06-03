//
//  CardView.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit

enum CardViewConstants {
  static let xShift: CGFloat = 400
  static let swipedAngle: CGFloat = 60 * .pi / 180
  static let maxDelta: CGFloat = 180
  static let maxAngle: CGFloat = .pi / 8
  static let topCardHorizontalOffset: CGFloat = 12
  static let topCardTopOffset: CGFloat = 5
  static let topCardBottomOffset: CGFloat = 11
}

class CardView: UIView, UserCardViewViewModelProtocol {
  
  var name: String
  var age: Int
  var city: String
  var imageUrlString: String
  var delegate: CardViewDeleagate?
  
  var anchorPoint: CGPoint = .zero
  var startPoint: CGPoint = .zero
  var currentAngle: CGFloat = 0
  var oldAngle: CGFloat = 0
    
  init(with viewModel: UserCardViewViewModelProtocol) {
    self.name = viewModel.name
    self.age = viewModel.age
    self.imageUrlString = viewModel.imageUrlString
    self.city = viewModel.city
    super.init(frame: .zero)
    setupElements()
  }
  
  init() {
    let viewModel = UserCardViewViewModel()
    self.age = viewModel.age
    self.imageUrlString = viewModel.imageUrlString
    self.city = viewModel.city
    self.name = viewModel.name
    super.init(frame: .zero)
    setupElements()
  }
  
  func animateToIdentity() {
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut) {
      self.transform = .identity
      self.center = self.startPoint
    }
  }
  
  func swipe(liked: Bool) {
    let xShift: CGFloat = liked ? CardViewConstants.xShift : -CardViewConstants.xShift
    let angle: CGFloat = liked ? CardViewConstants.swipedAngle : -CardViewConstants.swipedAngle
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveLinear) {
      self.transform = CGAffineTransform(rotationAngle: angle)
      self.center.x += xShift
      self.alpha = 0
    } completion: { _ in
      self.transform = .identity
      self.center = self.startPoint
      self.backgroundColor = .randomColor()
    }
    self.delegate?.swiped(liked: liked)
    
    
  }
  
  private func setupElements() {
    self.backgroundColor = .randomColor()
  }
    
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
}
