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

class CardView: UIView, CardViewProtocol {
  
  var viewModel: UserCardViewViewModelProtocol? {
    didSet {
      fillUI()
    }
  }
  weak var delegate: CardViewDeleagate?
  
  var anchorPoint: CGPoint = .zero
  var startPoint: CGPoint = .zero
  
  private var profileImage: UIImageView!
  private var blurView: UIVisualEffectView!
  var hiddenTopReactionView: HiddenReactionViewProtocol!
  private var userInfoView: UserInfoView!
  var isSwipeble = false
  
  init(with viewModel: UserCardViewViewModelProtocol?) {
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
    DispatchQueue.main.async {
      if let viewModel = self.viewModel {
        self.isSwipeble = true
        guard let url = URL(string: viewModel.imageUrlString) else { return }
        
        self.userInfoView.viewModel = viewModel.userInfoViewViewModel
        self.profileImage.kf.setImage(with: url,
                                 options: [
                                  .transition(.fade(0.2)),
                                 ]) { result in
                                   switch result {
                                   case .success( _):
                                     break
                                   case .failure(_): break
                                   }
                                 }
      } else {
        self.isSwipeble = false
        self.userInfoView.viewModel = nil
        self.profileImage.image = .userPlaceholderImage
      }
    }
  }
  
  
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: - Setup Elements & Constraints
extension CardView {
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
}
