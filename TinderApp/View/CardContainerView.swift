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

protocol CardContainerDelagate {
  func getNextUser(_ cardContainer: CardContainerView) -> UserCardViewViewModelProtocol
}

class CardContainerView: UIView {
  
  var viewModel: CardContainerViewViewModelProtocol
  var delegate: CardContainerDelagate?
  
  var backCardContainer: UIView!
  
  var bottomCardView: CardView!
  var topCardView: CardView!
  
  init(viewModel: CardContainerViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
  }
  
  func loadCards() {
    guard let bottomCard = viewModel.nextCard(),
          let topCard = viewModel.nextCard() else { return }
    topCardView = CardView(with: topCard)
    bottomCardView = CardView(with: bottomCard)
    
    backCardContainer.addSubview(bottomCardView)
    backCardContainer.addSubview(topCardView)
  }
  
  
  
  
  
  
  func bringBottomCardToTop() {
    UIView.animate(withDuration: 0.5) {
      self.bottomCardView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }
  
  private func setupElements() {
    backgroundColor = .blue
    topCardView = CardView(with: viewModel.topCardViewModel)
    bottomCardView = CardView(with: viewModel.bottomCardViewModel)
    self.addSubview(bottomCardView)
    self.addSubview(topCardView)
   
    bottomCardView.snp.makeConstraints { make in
      make.top.equalTo(self.snp.top).offset(5)
      make.left.equalTo(self.snp.left).offset(12)
      make.right.equalTo(self.snp.right).offset(-12)
      make.bottom.equalTo(self.snp.bottom).offset(11)
    }
    topCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    topCardView.delegate = self
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function)
    print(#file)
  }
  
//  
//  private func swiped() {
//    topCardView.removeFromSuperview()
//    let card = CardView(CardContainerDelagate.?getNextUser(self))
//    topCardView = backCardView
//    showNew()
//    backCardContainer.addSubview(card)
//  }
//  
//  private func showNew() {
//    UIView.animate(withDuration: 0.5) {
//      // top anchor up to 5
//      // left and right up to 12
//      // bottom up to 11
//    }
//  }
//  
//  private func setupCards(_ front: Data, _ second: Data) {
//    let frontCardView = CardView(front)
//    let bottomCardView = CardView(bottom)
//    frontCardView = currentCard
//    backCardContainer.addSubview(bottomCardView)
//    backCardContainer.addSubview(frontCardView)
//    
//    UIView.animate(withDuration: 0.5) {
//      NSLayoutConstraint.activate([
//        // top anchor up to 5
//        // left and right up to 12
//        // bottom up to 11
//      ]])
//    }
//  }
  
 
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension CardContainerView: CardViewDeleagate {
  func swiped(liked: Bool) {
    print("swiped")
    topCardView.removeFromSuperview()
    guard let newData = delegate?.getNextUser(self) else { return }
    let newBottomView = CardView(with: newData)
    bringBottomCardToTop()
    topCardView = bottomCardView
    bottomCardView = newBottomView
    addSubview(bottomCardView)
    bottomCardView.snp.makeConstraints { make in
      make.top.equalTo(self.snp.top).offset(5)
      make.left.equalTo(self.snp.left).offset(12)
      make.right.equalTo(self.snp.right).offset(-12)
      make.bottom.equalTo(self.snp.bottom).offset(11)
    }
    (viewModel as! CardContainerViewViewModel).swapTopViewModel(with: newData)
  }
}
