//
//  UserInfoViewController.swift
//  TinderApp
//
//  Created by Timofey on 25/6/22.
//

import UIKit

enum Constants {
  static var imageViewHeightMultiplier: CGFloat = 0.63
  static var infoViewCornerRadius: CGFloat = 30
  static var horizontalPaddingMultiplier: CGFloat = 0.064
  static var horizontalReactiovViewPaddingMultiplier: CGFloat = 0.24
}

class UserView: UIView, UserViewProtocol {
  
  private var userImageView: UIImageView!
  private var infoViewContainer: UIView!
  private var interestLabel: UILabel!
  private var similarInterestLabel: UILabel!
  private var interestView: UIScrollView!
  private var interestsLabelsStackView: UIStackView!
  private var reactionView: ReactionButtonsView!
  private var userInfoView: UserInfoView!
  private var placeholderImage = UIImage(named: "person.fill")
  // must set deleagte in peoplevc
  weak var reactionsDelegate: ReactionViewDelegate?
  var viewModel: UserCardViewViewModelProtocol? {
    didSet {
      fillUI()
    }
  }
  
  var viewHieght: CGFloat!
  
  var flag = true
  
  init() {
    super.init(frame: .zero)
    setupElements()
    setupGestures()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if flag {
      setupConstraints()
      flag.toggle()
    }
    viewHieght = self.bounds.height
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
  
  private func setupElements() {
    setupUserImageView()
    setupInfoViewContainer()
    setupLabels()
    setupReactionView()
    setupUserInfoView()
    setupInterestView()
    fillUI()
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
  
  private func setupReactionView() {
    reactionView = ReactionButtonsView()
    reactionView.delegate = reactionsDelegate
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
    userImageView.contentMode = .scaleAspectFill
  }
  
  private func setupInfoViewContainer() {
    infoViewContainer = UIView()
    infoViewContainer.backgroundColor = UIColor(named: "peopleBG") ?? .black
    infoViewContainer.layer.cornerRadius = Constants.infoViewCornerRadius
  }
  
  private func setupConstraints() {
    let imageHeight = Constants.imageViewHeightMultiplier * self.bounds.height
    
    self.addSubview(userImageView)
    userImageView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
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
    if let viewModel = viewModel {
      let url = URL(string: viewModel.imageUrlString)
      userImageView.kf.setImage(with: url,
                                placeholder: placeholderImage,
                                options: [
                                  .transition(.fade(0.2))
                                ])
      similarInterestLabel.text = "\(viewModel.interests.count) Similar"
      userInfoView.viewModel = viewModel.userInfoViewViewModel
      updateInterestsView()
    } else {
      userInfoView.viewModel = nil
      let factor = Int.random(in: 0...1)
      let imgName = "user\(factor)"
      userImageView.image = UIImage(named: imgName)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

