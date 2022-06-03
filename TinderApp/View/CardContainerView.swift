//
//  CardViewContainer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit
import SnapKit


//    private var currentUserCard: UserCard
//    private var nextUserCard: UserCard

// has 2 properties that updates every time card swipe
// properties are initing in init

// at the init
// setup top & bottom card
// bring top card to the front via animation

// after swipe
// removing top card from superview
// back card animating to top
// configuring new back card


// states
// 0. no cards
// 1. 2 cards is given
// 2. top card swiped
// 3. cards ended


// how to notificate container that card is swiped
// delegate for every view?


// state 2:
// top card is being moved by x on constant: shiftConstant
// after bottom card animates to top
// after top card moves behind the bottom
// state is changing on state where top card now is bottom and bottom now on top


class CardContainerView: UIView {
  
  var viewModel: CardContainerViewViewModelProtocol
  var delegate: CardContainerDelagate?
  
  var backCardContainer: UIView!
  var bottomCardView: CardView!
  var topCardView: CardView!
  
  var topCardTurn: Bool = true
  
  init(viewModel: CardContainerViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
  }
  
  private func setupElements() {
    backgroundColor = .black
    topCardView = CardView(with: viewModel.topCardViewModel)
    bottomCardView = CardView(with: viewModel.bottomCardViewModel)
    self.addSubview(bottomCardView)
    self.addSubview(topCardView)
   
    bottomCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    topCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    topCardView.delegate = self
    bottomCardView.delegate = self
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function)
    print(#file)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


extension CardContainerView: CardViewDeleagate {
  
  func swiped(liked: Bool) {
    swapViews()
  }
  
  func swapViews() {
    if topCardTurn {
      topCardView.isUserInteractionEnabled = false
      bottomCardView.isUserInteractionEnabled = true
      topCardView.layer.zPosition = 0
      bottomCardView.layer.zPosition = 1
      topCardView.alpha = 1
    } else {
      bottomCardView.isUserInteractionEnabled = false
      topCardView.isUserInteractionEnabled = true
      bottomCardView.alpha = 0
      topCardView.layer.zPosition = 1
      bottomCardView.alpha = 1
    }
    topCardTurn.toggle()
  }
  
}
