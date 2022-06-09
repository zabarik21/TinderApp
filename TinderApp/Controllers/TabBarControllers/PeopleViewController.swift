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
  
  let headerOvalLayerMask = CAShapeLayer()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor(named: "peopleBG")!
      setupHeaderOvalLayer()
      setupCardContainer()
      setupReactionsView()
    }
  
  private func setupReactionsView(){
    reactionsView = ReactionButtonsView()
    reactionsView.delegate = self
    
    view.addSubview(reactionsView)
    
    reactionsView.snp.makeConstraints { make in
      make.top.equalTo(cardContainer.snp.bottom).offset(30)
      make.leading.equalToSuperview().offset(100)
      make.trailing.equalToSuperview().offset(-100)
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
      make.height.equalTo(Constants.cardContainerHeight)
      make.top.equalToSuperview().offset(120)
    }
    
    cardContainer.delegate = self
  }

}

extension PeopleViewController: CardContainerDelagate {
  func usersLoaded() {
    print("loaded")
  }
}


extension PeopleViewController: ReactionViewDelegate {
  
  func reacted(liked: Bool) {
//    if liked {
//      cardContainer.like()
//    } else {
//      cardContainer.dislike()
//    }
  }
  
}
