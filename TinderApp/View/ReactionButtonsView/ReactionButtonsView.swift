//
//  ReactionButtonsView.swift
//  TinderApp
//
//  Created by Timofey on 8/6/22.
//

import UIKit
import SnapKit

enum ReactionButtonsViewConstants {
  static var shadowOpacity: Float = 0.3
  static var shadowBlur: CGFloat = 10
}

class ReactionButtonsView: UIView {

  var delegate: ReactionViewDelegate?
  
  var likeButton: UIButton!
  var dislikeButton: UIButton!
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = .clear
    setupElements()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    likeButton.layer.cornerRadius = frame.height / 2
    dislikeButton.layer.cornerRadius = frame.height / 2
    setupGradientLayer()
    
  }
  
  private func setupGradientLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
        UIColor(named: "firstGradientColor")!.cgColor,
        UIColor(named: "secondGradientColor")!.cgColor
    ]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    
    gradientLayer.frame = dislikeButton.frame
    gradientLayer.cornerRadius = frame.height / 2
    
    likeButton.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  private func setupElements() {
    likeButton = UIButton(type: .system)
    dislikeButton = UIButton(type: .system)
    
    likeButton.backgroundColor = .red
    dislikeButton.backgroundColor = .white
    
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 31), scale: .default)
    let likeImage = UIImage(systemName: "heart.fill", withConfiguration: config)
    let dislikeImage = UIImage(systemName: "multiply", withConfiguration: config)
    
    likeButton.setImage(likeImage, for: .normal)
    dislikeButton.setImage(dislikeImage, for: .normal)
    
    likeButton.tintColor = .white
    dislikeButton.tintColor = UIColor(named: "firstGradientColor")!
    
    setupShadow(likeButton.layer)
    setupShadow(dislikeButton.layer)
    
    addSubview(likeButton)
    addSubview(dislikeButton)
    
    likeButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
    dislikeButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
    likeButton.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    dislikeButton.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    
    setupConstraints()
  }
  
  @objc func touchDown(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      sender.layer.shadowOpacity = 0
    }
  }
  
  @objc func touchUpInside(_ sender: UIButton) {
    if sender === likeButton {
      delegate?.reacted(liked: true)
    } else {
      delegate?.reacted(liked: false)
    }
    UIView.animate(withDuration: 0.3) {
      sender.layer.shadowOpacity = ReactionButtonsViewConstants.shadowOpacity
    }
    
  }
  
  private func setupConstraints() {
    likeButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.height.equalTo(self.snp.height)
    }
    
    dislikeButton.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.height.equalTo(self.snp.height)
    }
  }
  
  private func setupShadow(_ layer: CALayer) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = ReactionButtonsViewConstants.shadowOpacity
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = ReactionButtonsViewConstants.shadowBlur
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
