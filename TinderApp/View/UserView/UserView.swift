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
  static var viewDissappearTime: TimeInterval = 0.3
}

class UserView: UIView, UserViewProtocol {
  
  private var userImageView: UIImageView!
  private var infoViewContainer: UIView!
  private var interestLabel: UILabel!
  private var similarInterestLabel: UILabel!
  private var interestsLabelsStackView: UIStackView!
  private var interestsCollectionView: InterestsCollectionViewController!
  private var reactionView: ReactionButtonsView!
  private var userInfoView: UserInfoView!
  
  weak var userViewDelegate: UserViewDelegate?
  weak var reactionsDelegate: ReactionViewDelegate?
  var viewModel: UserCardViewViewModelProtocol? {
    didSet {
      fillUI()
    }
  }
  
  var viewHieght: CGFloat!
  
  var flag = true
  var user: UserCardModel
  
  init(user: UserCardModel) {
    self.user = user
    super.init(frame: .zero)
    setupElements()
    setupGestures()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    viewHieght = self.bounds.height
    if flag {
      setupConstraints()
      flag.toggle()
    }
  }
  
  func fillUI() {
    if let viewModel = viewModel {
      let url = URL(string: viewModel.imageUrlString)
      DispatchQueue.main.async {
        self.userImageView.kf.setImage(with: url,
                                  options: [
                                    .transition(.fade(0.2))
                                  ])
        self.similarInterestLabel.text = "\(viewModel.interests.count) Similar"
        self.userInfoView.viewModel = viewModel.userInfoViewViewModel
        self.updateInterestsView()
      }
    } else {
      DispatchQueue.main.async {
        self.userImageView.image = .userPlaceholderImage
        self.userInfoView.viewModel = nil
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Elements & Constraints
extension UserView {
  
  private func setupElements() {
    setupUserImageView()
    setupInfoViewContainer()
    setupLabels()
    setupReactionView()
    setupUserInfoView()
    setupInterestView()
    fillUI()
    self.backgroundColor = .peopleViewControllerBackground
  }
  
  private func updateInterestsView() {
    let array = viewModel?.interests.map({ i in
      return (i, user.interests!.contains(i))
    }) ?? []
    interestsCollectionView.interests = array
  }
  
  private func setupUserInfoView() {
    userInfoView = UserInfoView()
    userInfoView.changeCompatabilityLabelTextColor(with: .black)
  }
  
  private func setupInterestView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 15
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
    interestsCollectionView = InterestsCollectionViewController(collectionViewLayout: layout)
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
    similarInterestLabel.textColor = UIColor.firstGradientColor.withAlphaComponent(0.6)
    similarInterestLabel.text = "0 Similar"
  }
  
  private func setupUserImageView() {
    userImageView = UIImageView()
    userImageView.contentMode = .scaleAspectFill
  }
  
  private func setupInfoViewContainer() {
    infoViewContainer = UIView()
    infoViewContainer.backgroundColor = UIColor.peopleViewControllerBackground
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
    
    infoViewContainer.addSubview(interestsCollectionView.view)
    interestsCollectionView.view.snp.makeConstraints { make in
      make.top.equalTo(interestsLabelsStackView.snp.bottom).offset(18)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
      make.height.equalTo(60)
    }
    
    infoViewContainer.addSubview(reactionView)
    reactionView.snp.makeConstraints { make in
      make.top.equalTo(interestsCollectionView.view.snp.bottom).offset(24)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalReactiovViewPaddingMultiplier * self.bounds.width)
      make.height.equalTo(75)
    }
  }
}

