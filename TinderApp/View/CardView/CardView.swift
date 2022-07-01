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
  static let xShift: CGFloat = 300
  static let swipedAngle: CGFloat = 30 * .pi / 180
  static let maxDeltaForHiddenViewMultiplier: CGFloat = 0.1
  static let maxDelta: CGFloat = 130
  static let maxVelocity: CGFloat = 1000
  static let maxAngle: CGFloat = .pi / 8
  static let topCardHorizontalOffset: CGFloat = 12
  static let topCardTopOffset: CGFloat = 5
  static let topCardBottomOffset: CGFloat = 11
  static let xTranslateMultiplier: CGFloat = 0.8
  static let yTranslateMultiplier: CGFloat = 0.3
}

class CardView: UIView {
  
  var viewModel: UserCardViewViewModelProtocol {
    didSet {
      fillUI()
    }
  }
  weak var delegate: CardViewDeleagate?
  
  var anchorPoint: CGPoint = .zero
  var startPoint: CGPoint = .zero
  
  private var profileImage: UIImageView!
  var blurView: UIVisualEffectView!
  var hiddenTopReactionView: HiddenReactionViewProtocol!
  var userInfoView: UserInfoView!
  
  init(with viewModel: UserCardViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
    setupGestures()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.startPoint = center
  }
  
  init() {
    let viewModel = UserCardViewViewModel()
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
    setupGestures()
  }
  
  func swipe(liked: Bool, fromButton: Bool = false) {
    let xShift: CGFloat = liked ? CardViewConstants.xShift : -CardViewConstants.xShift
    let angle: CGFloat = liked ? CardViewConstants.swipedAngle : -CardViewConstants.swipedAngle
    let duration = fromButton ? PeopleVCConstants.cardDisappearTime * 3 : PeopleVCConstants.cardDisappearTime
    UIView.animate(withDuration: duration) { 
      self.transform = CGAffineTransform(rotationAngle: angle)
      self.center.x += xShift
      self.hiddenTopReactionView.toggleReaction(like: liked)
      self.hiddenTopReactionView.alpha = 1
      self.alpha = 0
    } completion: { _ in
      self.transform = .identity
      self.hiddenTopReactionView.alpha = 0
      self.center = self.startPoint
      self.delegate?.swiped(liked: liked)
    }
  }

  private func fillUI() {
    guard let url = URL(string: viewModel.imageUrlString) else { return }
    userInfoView.viewModel = viewModel.userInfoViewViewModel
    profileImage.kf.setImage(with: url,
                             options: [
                              .transition(.fade(0.2)),
                             ]) { result in
                               switch result {
                               case .success(let value):
                                 print(value.cacheType)
                               case .failure(_): break
                               }
                             }
  }
  
  private func setupConstraints() {
    addSubview(profileImage)
    profileImage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    addSubview(blurView)
    blurView.snp.makeConstraints { make in
      make.leading.bottom.trailing.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.185)
    }
    
    blurView.contentView.addSubview(userInfoView)
    userInfoView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(24)
      make.height.equalTo(60)
      make.centerY.equalToSuperview()
    }
    
    addSubview(hiddenTopReactionView)
    hiddenTopReactionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupElements() {
    self.backgroundColor = .randomColor()
    clipsToBounds = true
    layer.cornerRadius = 20
    layer.borderWidth = 0.2
    layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    setupImageView()
    setupUserInfoView()
    setupHiddenTopReactionView()
    fillUI()
    setupConstraints()
  }
  
  func setupHiddenTopReactionView() {
    hiddenTopReactionView = HiddenReactionView()
    hiddenTopReactionView.alpha = 0
  }
  
  private func setupUserInfoView() {
    let blur = UIBlurEffect(style: .dark)
    blurView = UIVisualEffectView(effect: blur)
    userInfoView = UserInfoView()
  }
  
  private func setupImageView() {
    profileImage = UIImageView()
    profileImage.contentMode = .scaleAspectFill
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
