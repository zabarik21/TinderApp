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
}

class UserInfoView: UIView {
  
  private var userImageView: UIImageView!
  private var infoView: UIView!
  private var nameAgeLabel: UILabel!
  private var cityLabel: UILabel!
  private var interestLabel: UILabel!
  private var similarInterestLabel: UILabel!
  private var compatabilityView: CompatabilityView!
  private var interestView: UIScrollView!
  private var labelsStackView: UIStackView!
  private var interestsLabelsStackView: UIStackView!
  private var reactionView: ReactionButtonsView!
  private var placeholderImage = UIImage(named: "person.fill")
  private var viewModel: UserCardViewViewModelProtocol
  
  var flag = true
  
  init(with viewModel: UserCardViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
  }
  
  private func setupElements() {
    setupUserImageView()
    setupInfoView()
    setupLabels()
    setupReactionView()
    setupCompatabilityView()
    setupInterestView()
    fillUI()
    self.backgroundColor = .brown
  }
  
  private func setupInterestView() {
    interestView = UIScrollView()
    interestView.layer.borderColor = UIColor.black.cgColor
    interestView.layer.borderWidth = 1
  }
  
  private func setupCompatabilityView() {
      compatabilityView = CompatabilityView(with: viewModel.compatabilityScore)
      compatabilityView.changeLabelColor(with: .black)
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
    
    addSubview(infoView)
    infoView.snp.makeConstraints { make in
      make.top.equalTo(userImageView.snp.bottom).offset(-Constants.infoViewCornerRadius)
      make.bottom.equalToSuperview().offset(Constants.infoViewCornerRadius)
      make.left.right.equalToSuperview()
    }
    
    labelsStackView = UIStackView(arrangedSubviews: [nameAgeLabel, cityLabel])
    labelsStackView.spacing = 12
    labelsStackView.axis = .vertical
    
    infoView.addSubview(labelsStackView)
    
    labelsStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(22)
      make.leading.equalToSuperview().offset(Constants.horizontalPaddingMultiplier * self.bounds.width)
    }
    
    infoView.addSubview(compatabilityView)
    compatabilityView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-Constants.horizontalPaddingMultiplier * self.bounds.width)
      make.height.width.equalTo(70)
      make.centerY.equalTo(labelsStackView)
    }
    interestsLabelsStackView = UIStackView(arrangedSubviews: [interestLabel, similarInterestLabel])
    interestsLabelsStackView.axis = .horizontal
    interestsLabelsStackView.alignment = .center
    interestsLabelsStackView.distribution = .fill
    
    infoView.addSubview(interestsLabelsStackView)
    interestsLabelsStackView.snp.makeConstraints { make in
      make.top.equalTo(labelsStackView.snp.bottom).offset(30)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
    }
    
    infoView.addSubview(interestView)
    interestView.snp.makeConstraints { make in
      make.top.equalTo(interestsLabelsStackView.snp.bottom).offset(18)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
      make.height.equalTo(40)
    }
    
  }
  
  func fillUI() {
    let url = URL(string: viewModel.imageUrlString)
    userImageView.kf.setImage(with: url,
                              placeholder: placeholderImage,
                              options: [
                                .transition(.fade(0.2))
                              ])
    nameAgeLabel.text = viewModel.nameAgeLabelText()
    cityLabel.text = viewModel.cityDistanceLabelText()
    similarInterestLabel.text = "\(viewModel.interests.count) Similar"
    compatabilityView.updateScore(with: viewModel.compatabilityScore)
    updateInterestsView()
    // fill interests collection view
  }
  
  private func setupReactionView() {
    reactionView = ReactionButtonsView()
    reactionView.delegate = self
  }
  
  private func setupLabels() {
    nameAgeLabel = UILabel()
    nameAgeLabel.font = .systemFont(ofSize: 24, weight: .bold)
    nameAgeLabel.textColor = .black
    
    cityLabel = UILabel()
    cityLabel.font = .systemFont(ofSize: 12, weight: .bold)
    cityLabel.textColor = .black.withAlphaComponent(0.6)
    
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
    let url = URL(string: viewModel.imageUrlString)
    let image = UIImage(systemName: "person.fill")!
    userImageView.contentMode = .scaleToFill
    userImageView.kf.setImage(with: url, placeholder: image)
  }
  
  private func setupInfoView() {
    infoView = UIView()
    infoView.backgroundColor = UIColor(named: "peopleBG") ?? .black
    infoView.layer.cornerRadius = Constants.infoViewCornerRadius
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


extension UserInfoView: ReactionViewDelegate {

  func reacted(liked: Bool) {
    print(liked ? "like" : "disliked")
  }
  
}
