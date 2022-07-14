//
//  ReactionButtonsView.swift
//  TinderApp
//
//  Created by Timofey on 8/6/22.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

enum ReactionButtonsViewConstants {
  static var shadowOpacity: Float = 0.3
  static var shadowBlur: CGFloat = 10
  static var delay: TimeInterval = 0.3
}

enum Reaction {
  case like
  case dislike
}

class ReactionButtonsView: UIView, ReactionButtonsViewProtocol {
  
  private var likeButton: UIButton!
  private var dislikeButton: UIButton!
  private var publishRelay = PublishRelay<Reaction>()
  
  var reactedObservable: Observable<Reaction> {
    return publishRelay.asObservable()
  }
  
  var delayIsOn = false
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = .clear
    setupElements()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    likeButton.layer.cornerRadius = frame.height / 2
    dislikeButton.layer.cornerRadius = frame.height / 2
    updateShadowPath()
    setupGradientLayer()
  }
  
  private func updateShadowPath() {
    likeButton.layer.shadowPath = UIBezierPath(roundedRect: likeButton.bounds, cornerRadius: likeButton.frame.height / 2).cgPath
    dislikeButton.layer.shadowPath = UIBezierPath(roundedRect: dislikeButton.bounds, cornerRadius: dislikeButton.frame.height / 2).cgPath
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Button functions
extension ReactionButtonsView {
  
  @objc private func touchDown(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      sender.layer.shadowOpacity = 0
    }
  }
  
  @objc private func touchUpInside(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      sender.layer.shadowOpacity = ReactionButtonsViewConstants.shadowOpacity
    }
    guard delayIsOn != true else { return }
    if sender === likeButton {
      publishRelay.accept(.like)
    } else {
      publishRelay.accept(.dislike)
    }
    delayIsOn = true
    DispatchQueue.main.asyncAfter(deadline: .now() + ReactionButtonsViewConstants.delay, execute: {
      self.delayIsOn.toggle()
    })
  }
}

// MARK: - Setup Elements & Constraints
extension ReactionButtonsView {
  
  private func setupElements() {
    setupButtons()
    setupConstraints()
  }
  
  private func setupButtons() {
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
    dislikeButton.tintColor = .firstGradientColor
    
    setupShadow(likeButton.layer)
    setupShadow(dislikeButton.layer)
    
    likeButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
    dislikeButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
    likeButton.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    dislikeButton.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
  }
  
  private func setupShadow(_ layer: CALayer) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = ReactionButtonsViewConstants.shadowOpacity
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = ReactionButtonsViewConstants.shadowBlur
  }
  
  private func setupGradientLayer() {
    let gradientLayer = LayerFactory.shared.getGradientLayer(with: [.firstGradientColor,         .secondGradientColor])
    
    gradientLayer.frame = dislikeButton.frame
    gradientLayer.cornerRadius = frame.height / 2
    
    likeButton.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  private func setupConstraints() {
    
    addSubview(likeButton)
    addSubview(dislikeButton)
    
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
}
