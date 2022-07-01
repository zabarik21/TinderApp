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
  
  var cardContainer: CardContainerView!
  var reactionsView: ReactionButtonsView!
  var titleLabel: UILabel!
  let headerOvalLayerMask = CAShapeLayer()
  var gradientLayer: CAGradientLayer!
  var userView: UserViewProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(named: "peopleBG")!
    setupElements()
    setupConstraints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    actualizePath()
    self.tabBarController?.setTabBarHidden(true, animated: true, duration: 1)
  }
  
  private func setupElements() {
    setupHeaderOvalLayer()
    setupReactionsView()
    setupCardContainer()
    setupTitleLabel()
    setupUserView()
  }
  
  private func setupUserView() {
    userView = UserView()
    userView.reactionsDelegate = self
    userView.alpha = 0
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel.text = "People Nearby"
    titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
    titleLabel.textColor = UIColor(named: "peopleBG") ?? .black
  }
  
  private func setupReactionsView(){
    reactionsView = ReactionButtonsView()
    reactionsView.delegate = self
  }
  
  private func setupCardContainer() {
    let viewModel = CardContainerViewViewModel(users: [
      .init(),
      .init()])
    cardContainer = CardContainerView(viewModel: viewModel)
    cardContainer.delegate = self
  }
  
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
      make.leading.equalToSuperview().offset(self.view.bounds.width * PeopleVCConstants.buttonsHorizontalOffsetMultiplier)
      make.trailing.equalToSuperview().offset(-self.view.bounds.width * PeopleVCConstants.buttonsHorizontalOffsetMultiplier)
      make.height.equalTo(75)
    }
    
    view.addSubview(cardContainer)
    
    cardContainer.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(CardContainerConstants.horizontalCardOffset * self.view.bounds.width)
      make.height.equalTo(PeopleVCConstants.cardContainerHeightMultiplier * self.view.bounds.height)
      make.bottom.equalTo(reactionsView.snp.top).offset(-30)
    }
    
    view.addSubview(userView)
    
    userView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  
}
