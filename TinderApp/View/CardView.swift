//
//  CardView.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit



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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    anchorPoint.x = touches.first!.location(in: window).x - frame.minX
    anchorPoint.y = touches.first!.location(in: window).y - frame.minY
    
    startPoint = center
  }
  
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // delta is ok
    let delta = (touches.first!.location(in: window).x) - anchorPoint.x
    // delta max is 330 (if touch begin from edge of view to edge of screen)
    // and medium delta is about 160
    // maximum angle that we need is maximum 45 (if delta 330)1
    
    let maxAngle: CGFloat = .pi / 8
    // angle is ok
    let angle: CGFloat = maxAngle * (CGFloat(delta) * 10 / 33)
    print("delta \(delta)")
    print("angle \(angle)")
    
//    self.frame.origin.x = (touches.first!.location(in: window).x) - anchorPoint.x
    let x = (delta  + (self.bounds.width / 2))
    print("center x \(x)")
    
    self.transform = CGAffineTransform(rotationAngle: angle * .pi/180)
    self.center.x = x
    
    
    
    
    currentAngle = angle
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) { [ unowned self] in
      let maxDelta: CGFloat = 200
      let delta = (touches.first!.location(in: window).x) - anchorPoint.x
      if delta > maxDelta {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear) {
          self.frame.origin.x += 300
        } completion: { _ in
          self.delegate?.swiped()
        }
      }
      else if delta < -maxDelta {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear) {
          self.frame.origin.x -= 300
        } completion: { _ in
          self.delegate?.swiped()
        }
      }
      else {
        UIView.animate(withDuration: 0.2) {
          self.transform = .identity
          self.center = self.startPoint
        }
        self.transform = .identity
        self.center = self.startPoint
      }
    }

    
    
  }
  
  private func setupElements() {
    self.backgroundColor = .randomColor()
  }
    
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
}
