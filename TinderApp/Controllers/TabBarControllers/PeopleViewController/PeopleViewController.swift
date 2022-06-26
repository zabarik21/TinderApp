//
//  PeopleViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit

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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(named: "peopleBG")!
    setupElements()
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      let uif = UserInfoView(with: self.cardContainer.viewModel.nextCard()!)
      self.view.addSubview(uif)
      uif.layer.zPosition = 2
      uif.snp.makeConstraints { make in
        make.horizontalEdges.equalToSuperview()
        make.top.equalToSuperview()
        make.bottom.equalToSuperview()
      }
    }
  }
  
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel.text = "People Nearby"
    titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
    titleLabel.textColor = UIColor(named: "peopleBG") ?? .black
    
    view.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(70)
      make.leading.equalToSuperview().offset(PeopleVCConstants.cardContainerHorizontalOffsetMultiplier * self.view.bounds.width)
    }
  }
  
  private func setupReactionsView(){
    reactionsView = ReactionButtonsView()
    reactionsView.delegate = self
    
    view.addSubview(reactionsView)
    
    let tabBarFrame = self.tabBarController!.tabBar.frame
    print(tabBarFrame)
    reactionsView.snp.makeConstraints { make in
      make.bottom.equalTo(tabBarFrame.origin.y).offset(-self.view.bounds.height * PeopleVCConstants.buttonsBottomOffsetMultiplier)
      make.leading.equalToSuperview().offset(self.view.bounds.width * PeopleVCConstants.buttonsHorizontalOffsetMultiplier)
      make.trailing.equalToSuperview().offset(-self.view.bounds.width * PeopleVCConstants.buttonsHorizontalOffsetMultiplier)
      make.height.equalTo(75)
    }
  }
  
  private func setupCardContainer() {
    let viewModel = CardContainerViewViewModel(users: [
      .init(),
      .init()])
    cardContainer = CardContainerView(viewModel: viewModel)
    
    view.addSubview(cardContainer)
    
    cardContainer.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(CardContainerConstants.horizontalCardOffset * self.view.bounds.width)
      make.height.equalTo(PeopleVCConstants.cardContainerHeightMultiplier * self.view.bounds.height)
      make.bottom.equalTo(reactionsView.snp.top).offset(-30)
    }
    cardContainer.delegate = self
    cardContainer.layer.zPosition = 0
  }
  
}

extension PeopleViewController: CardContainerDelagate {
  func usersLoaded() {
    print("loaded")
  }
}


extension PeopleViewController: ReactionViewDelegate {
  func reacted(liked: Bool) {
    cardContainer.reacted(liked: liked)
  }
}
