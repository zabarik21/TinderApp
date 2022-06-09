//
//  CardView.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit
import SnapKit
import Kingfisher

enum CardViewConstants {
  static let xShift: CGFloat = 1000
  static let swipedAngle: CGFloat = 45 * .pi / 180
  static let maxDelta: CGFloat = 130
  static let maxAngle: CGFloat = .pi / 8
  static let topCardHorizontalOffset: CGFloat = 12
  static let topCardTopOffset: CGFloat = 5
  static let topCardBottomOffset: CGFloat = 11
}

class CardView: UIView {
  
  var viewModel: UserCardViewViewModelProtocol
  var delegate: CardViewDeleagate?
  
  var anchorPoint: CGPoint = .zero
  var startPoint: CGPoint = .zero
  
  var profileImage = UIImageView()
  var nameAgeLabel = UILabel()
  var cityDistanceLabel = UILabel()
  var compatabilityView = UIView()
    
  init(with viewModel: UserCardViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
  }
  
  init() {
    let viewModel = UserCardViewViewModel()
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
  }
  
  func updateCard(with viewModel: UserCardViewViewModelProtocol) {
    self.viewModel = viewModel
    fillUI()
  }
  
  func swipe(liked: Bool) {
    let xShift: CGFloat = liked ? CardViewConstants.xShift : -CardViewConstants.xShift
    let angle: CGFloat = liked ? CardViewConstants.swipedAngle : -CardViewConstants.swipedAngle
    UIView.animate(withDuration: Constants.cardDisappearTime, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveLinear) {
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
  
  private func setupLabels() {
    let nameLabelFont = UIFont.systemFont(ofSize: 24, weight: .bold)
    let cityFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    nameAgeLabel.font = nameLabelFont
    cityDistanceLabel.font = cityFont
    nameAgeLabel.textColor = UIColor(named: "cardLabelTextColor") ?? .white
    cityDistanceLabel.textColor = UIColor(named: "cardLabelTextColor") ?? .white
    
    addSubview(nameAgeLabel)
    addSubview(cityDistanceLabel)
    
    nameAgeLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-37)
      make.leading.equalToSuperview().offset(26)
    }
    
    cityDistanceLabel.snp.makeConstraints { make in
      make.top.equalTo(nameAgeLabel.snp.bottom).offset(4)
      make.leading.equalToSuperview().offset(26)
    }
  }
  
  private func setupImageView() {
    addSubview(profileImage)
    profileImage.contentMode = .scaleAspectFill
    profileImage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func fillUI() {
    cityDistanceLabel.text = viewModel.cityDistanceLabelText()
    nameAgeLabel.text = viewModel.nameAgeLabelText()
    guard let url = URL(string: viewModel.imageUrlString) else { return }
    profileImage.kf.setImage(with: url)
  }
  
  private func setupElements() {
    self.backgroundColor = .randomColor()
    clipsToBounds = true
    layer.cornerRadius = 20
    setupImageView()
    setupLabels()
    fillUI()
  }
    
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
}
