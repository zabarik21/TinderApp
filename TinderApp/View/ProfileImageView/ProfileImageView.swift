//
//  ProfileImageView.swift
//  TinderApp
//
//  Created by Timofey on 11/7/22.
//

import UIKit



protocol ProfileImageViewDelegate {
  func chooseImage() -> UIImage?
}

class ProfileImageView: UIImageView {
  
  var delegate: ProfileImageViewDelegate?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }
  
  init() {
    super.init(frame: .zero)
    isUserInteractionEnabled = true
    setupUI()
  }
  
  private func setupUI() {
    backgroundColor = .white.withAlphaComponent(0.5)
    image = UIImage(named: "camera.fill")
    contentMode = .center
    tintColor = .logoColor
    layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    layer.borderWidth = 1
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let newImage = delegate?.chooseImage() {
      self.image = newImage
    }
    super.touchesEnded(touches, with: event)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
