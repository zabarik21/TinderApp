//
//  PeopleViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit

class PeopleViewController: UIViewController {

  var cardContainer: CardContainerView!
  var reactionsView: ReactionButtonsView!
  var titleLabel: UILabel!
  let headerOvalLayerMask = CAShapeLayer()
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor(named: "peopleBG")!
      setupElements()
    }
  
  private func setupElements() {
    setupHeaderOvalLayer()
    setupReactionsView()
    setupCardContainer()
    setupTitleLabel()
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel.text = "People Nearby"
    titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
    titleLabel.textColor = UIColor(named: "peopleBG") ?? .black
    
    view.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(70)
      make.leading.equalToSuperview().offset(Constants.cardContainerHorizontalOffset)
    }
  }
  
  private func setupReactionsView(){
    reactionsView = ReactionButtonsView()
    reactionsView.delegate = self
    
    view.addSubview(reactionsView)
    
    let tabBarFrame = self.tabBarController!.tabBar.frame
    print(tabBarFrame)
    reactionsView.snp.makeConstraints { make in
      make.bottom.equalTo(tabBarFrame.origin.y).offset(-115)
      make.leading.equalToSuperview().offset(90)
      make.trailing.equalToSuperview().offset(-90)
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
      make.leading.equalTo(self.view.snp.leading).offset(Constants.cardContainerHorizontalOffset)
      make.trailing.equalTo(self.view.snp.trailing).offset(-Constants.cardContainerHorizontalOffset)
      make.height.equalTo(self.view.bounds.height * Constants.cardContainerHeightMultiplier)
      make.bottom.equalTo(reactionsView.snp.top).offset(-30)
    }
    cardContainer.delegate = self
    cardContainer.layer.zPosition = 1
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
