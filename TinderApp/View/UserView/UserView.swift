//
//  UserInfoViewController.swift
//  TinderApp
//
//  Created by Timofey on 25/6/22.
//

import UIKit

private enum Constants {
  static var imageViewHeightMultiplier: CGFloat = 0.63
  static var infoViewCornerRadius: CGFloat = 30
  static var horizontalPaddingMultiplier: CGFloat = 0.064
  static var horizontalReactiovViewPaddingMultiplier: CGFloat = 0.24
}

class UserView: UIView {
  
  private var userImageView: UIImageView!
  private var infoViewContainer: UIView!
  private var interestLabel: UILabel!
  private var similarInterestLabel: UILabel!
  private var interestView: UIScrollView!
  private var labelsStackView: UIStackView!
  private var interestsLabelsStackView: UIStackView!
  private var reactionView: ReactionButtonsView!
  private var placeholderImage = UIImage(named: "person.fill")
  private var userInfoView: UserInfoView!
  public var viewModel: UserCardViewViewModelProtocol! {
    didSet {
      fillUI()
    }
  }
  
  var flag = true
//  with viewModel: UserCardViewViewModelProtocol
  init() {
//    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
  }

  private func setupElements() {
    setupUserImageView()
    setupInfoViewContainer()
    setupLabels()
    setupReactionView()
    setupUserInfoView()
    setupCompatabilityView()
    setupInterestView()
    self.backgroundColor = .brown
  }
  
  private func setupUserInfoView() {
    userInfoView = UserInfoView()
    userInfoView.changeCompatabilityLabelTextColor(with: .black)
  }
  
  private func setupInterestView() {
    interestView = UIScrollView()
    interestView.layer.borderColor = UIColor.black.cgColor
    interestView.layer.borderWidth = 1
  }
  
  private func setupCompatabilityView() {
//      compatabilityView = CompatabilityView(with: viewModel.compatabilityScore)
//      compatabilityView.changeLabelColor(with: .black)
    }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if flag {
      setupConstraints()
      flag.toggle()
    }
  }
  
  private func updateInterestsView() {
    let label = Interestlabel()
    label.textColor = UIColor(named: "firstGradientColor")!
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.layer.cornerRadius = 15
    label.layer.masksToBounds = true
    label.backgroundColor = UIColor(named: "firstGradientColor")!.withAlphaComponent(0.2)
    
    label.text = "Shopping"
    interestView.addSubview(label)
    
    label.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(5)
      make.centerY.equalToSuperview()
    }
  }
  
  private func setupConstraints() {
    let imageHeight = Constants.imageViewHeightMultiplier * self.bounds.height
    
    self.addSubview(userImageView)
    userImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.height.equalTo(imageHeight)
    }
    
    addSubview(infoViewContainer)
    infoViewContainer.snp.makeConstraints { make in
      make.top.equalTo(userImageView.snp.bottom).offset(-Constants.infoViewCornerRadius)
      make.bottom.equalToSuperview().offset(Constants.infoViewCornerRadius)
      make.left.right.equalToSuperview()
    }
    
    infoViewContainer.addSubview(userInfoView)
    
    userInfoView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(26)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
      make.height.equalTo(70)
    }
    
    interestsLabelsStackView = UIStackView(arrangedSubviews: [interestLabel, similarInterestLabel])
    interestsLabelsStackView.axis = .horizontal
    interestsLabelsStackView.alignment = .center
    interestsLabelsStackView.distribution = .fill
    
    infoViewContainer.addSubview(interestsLabelsStackView)
    interestsLabelsStackView.snp.makeConstraints { make in
      make.top.equalTo(userInfoView.snp.bottom).offset(30)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
    }
    
    infoViewContainer.addSubview(interestView)
    interestView.snp.makeConstraints { make in
      make.top.equalTo(interestsLabelsStackView.snp.bottom).offset(18)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
      make.height.equalTo(40)
    }
    
    infoViewContainer.addSubview(reactionView)
    reactionView.snp.makeConstraints { make in
      make.top.equalTo(interestView.snp.bottom).offset(24)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalReactiovViewPaddingMultiplier * self.bounds.width)
      make.height.equalTo(75)
    }
  }
  
  func fillUI() {
    let url = URL(string: viewModel.imageUrlString)
    userImageView.kf.setImage(with: url,
                              placeholder: placeholderImage,
                              options: [
                                .transition(.fade(0.2))
                              ])
    similarInterestLabel.text = "\(viewModel.interests.count) Similar"
    userInfoView.viewModel = viewModel.userInfoViewViewModel
    updateInterestsView()
  }
  
  private func setupReactionView() {
    reactionView = ReactionButtonsView()
    reactionView.delegate = self
  }
  
  private func setupLabels() {
    interestLabel = UILabel()
    interestLabel.font = .systemFont(ofSize: 18, weight: .bold)
    interestLabel.textColor = .black
    interestLabel.text = "Interests"
    similarInterestLabel = UILabel()
    similarInterestLabel.font = .systemFont(ofSize: 14, weight: .bold)
    similarInterestLabel.textColor = UIColor(named: "firstGradientColor")!.withAlphaComponent(0.6)
    similarInterestLabel.text = "0 Similar"
  }
  
  private func setupUserImageView() {
    userImageView = UIImageView()
    let image = UIImage(systemName: "person.fill")!
    userImageView.contentMode = .scaleToFill
  }
  
  private func setupInfoViewContainer() {
    infoViewContainer = UIView()
    infoViewContainer.backgroundColor = UIColor(named: "peopleBG") ?? .black
    infoViewContainer.layer.cornerRadius = Constants.infoViewCornerRadius
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    DispatchQueue.main.async {
      self.alpha = 0
    }
  }
  
}


extension UserView: ReactionViewDelegate {

  func reacted(liked: Bool) {
    print(liked ? "like" : "disliked")
  }
  
}
