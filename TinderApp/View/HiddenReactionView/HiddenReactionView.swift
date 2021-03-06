//
//  HiddenReactionView.swift
//  TinderApp
//
//  Created by Timofey on 20/6/22.
//

import UIKit
import SnapKit

class HiddenReactionView: UIView, HiddenReactionViewProtocol {

  private var sybmolImage = UIImageView()
  private var reactionLabel = UILabel()
  
  private let likeText = "のように"
  private var liked = true
  private let dislikeText = "いいえ。."
  private let config = UIImage.SymbolConfiguration(pointSize: 144, weight: .bold)
  private lazy var dislikeImage = UIImage(systemName: "multiply", withConfiguration: config)
  private lazy var likeImage = UIImage(systemName: "heart.fill", withConfiguration: config)
  
  init() {
    super.init(frame: .zero)
    setupElements()
    setupConstraints()
  }
  
  func toggleReaction(like: Bool) {
    if like == liked { return }
    liked = like
    backgroundColor = like ? .highCompatabilityColor : .lowCompatabilityColor
    reactionLabel.text = like ? likeText : dislikeText
    sybmolImage.image = like ? likeImage : dislikeImage
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Setup Elements & Constraints
extension HiddenReactionView {
  private func setupElements() {
    backgroundColor = UIColor.highCompatabilityColor
    setupSymbolImageView()
    setupReactionLabel()
  }
  
  private func setupSymbolImageView() {
    sybmolImage.image = likeImage
    sybmolImage.tintColor = .cardLabelTextColor
  }
  
  private func setupReactionLabel() {
    reactionLabel.text = likeText
    reactionLabel.font = .boldSystemFont(ofSize: 50)
    
    reactionLabel.textColor = .cardLabelTextColor
  }
  
  private func setupConstraints() {
    addSubview(sybmolImage)
    
    sybmolImage.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    addSubview(reactionLabel)
    
    reactionLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(sybmolImage.snp.bottom)
    }
  }
}
