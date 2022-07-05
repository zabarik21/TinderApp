//
//  PeopleViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit
import SnapKit

enum PeopleVCConstants {
  static var cardContainerHeightMultiplier: CGFloat = 0.553
  static var cardDisappearTime: CGFloat = 0.1
  static var cardContainerHorizontalOffsetMultiplier: CGFloat = 0.0986
  static var buttonsHorizontalOffsetMultiplier: CGFloat = 0.24
  static var buttonsBottomOffsetMultiplier: CGFloat = 0.141
  static var ovalHeightMultiplier: CGFloat = 0.385
  static var ovalWidthMultiplier: CGFloat = 1.289
}

class PeopleViewController: UIViewController {
  
  var cardContainer: CardContainerViewProtocol!
  var reactionsView: ReactionButtonsViewProtocol!
  var titleLabel: UILabel!
  let headerOvalLayerMask = CAShapeLayer()
  var gradientLayer: CAGradientLayer!
  var userView: UserViewProtocol!
  var user: UserCardModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupConstraints()
  }
  
  init(user: UserCardModel) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    actualizePath()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Constraints and Elements
extension PeopleViewController {
  private func setupConstraints() {
    view.addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(70)
      make.leading.equalToSuperview().offset(PeopleVCConstants.cardContainerHorizontalOffsetMultiplier * self.view.bounds.width)
    }
    
    view.addSubview(reactionsView)
    
    let tabBarFrame = self.tabBarController!.tabBar.frame
    reactionsView.snp.makeConstraints { make in
      make.bottom.equalTo(tabBarFrame.origin.y).offset(-self.view.bounds.height * PeopleVCConstants.buttonsBottomOffsetMultiplier)
      make.horizontalEdges.equalToSuperview().inset(PeopleVCConstants.buttonsHorizontalOffsetMultiplier * self.view.bounds.width)
      make.height.equalTo(75)
    }
    
    view.addSubview(cardContainer)
    
    cardContainer.snp.makeConstraints { make in
      make.height.equalTo(Int(PeopleVCConstants.cardContainerHeightMultiplier * self.view.bounds.height))
      make.horizontalEdges.equalToSuperview().inset(CardContainerConstants.horizontalCardOffset * self.view.bounds.width)
      make.bottom.equalTo(reactionsView.snp.top).offset(-30)
    }
    
    view.addSubview(userView)
    
    userView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.height.equalToSuperview()
      make.top.equalTo(self.view.snp.bottom).offset(0)
    }
  }
  
  private func setupElements() {
    view.backgroundColor = UIColor.peopleViewControllerBackground
    setupHeaderOvalLayer()
    setupReactionsView()
    setupCardContainer()
    setupTitleLabel()
    setupUserView()
  }
  
  private func setupUserView() {
    userView = UserView(user: self.user)
    userView.userViewDelegate = self
    userView.reactionsDelegate = self
    userView.alpha = 0
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel.text = "People Nearby"
    titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
    titleLabel.textColor = UIColor.peopleViewControllerBackground
  }
  
  private func setupReactionsView(){
    reactionsView = ReactionButtonsView()
    reactionsView.delegate = self
  }
  
  private func setupCardContainer() {
    // let cachedUsers = ...
    let viewModel = CardContainerViewViewModel(users: [], user: self.user)
    // delegate for telling viewController that users have loaded and cards must be showedw
    viewModel.delegate = self
    cardContainer = CardContainerView()
    cardContainer.delegate = self
    cardContainer.viewModel = viewModel
  }
}
