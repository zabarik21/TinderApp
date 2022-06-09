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

enum CardContainerConstants {
  static var topAnchorCardOffset: CGFloat = 5
  static let horizontalCardOffset: CGFloat = 12
  static let bottomCardOffset: CGFloat = 11
  static var minimizedCardHeight: CGFloat = 491
  static var maximizedCardHeight: CGFloat = 485
}

class CardContainerView: UIView {
  
  var viewModel: CardContainerViewViewModelProtocol
  var delegate: CardContainerDelagate?
  
  var backCardContainer: UIView!
  var bottomCardView: CardView!
  var topCardView: CardView!
  
  var bottomCardTopAnchorConstraint: NSLayoutConstraint!
  var bottomCardLeadingAnchorConstraint: NSLayoutConstraint!
  var bottomCardTrailingAnchorConstraint: NSLayoutConstraint!
  var bottomCardBottomAnchorConstraint: NSLayoutConstraint!
  var bottomCardHeightConstraint: NSLayoutConstraint!
  
  var topCardTopAnchorConstraint: NSLayoutConstraint!
  var topCardLeadingAnchorConstraint: NSLayoutConstraint!
  var topCardTrailingAnchorConstraint: NSLayoutConstraint!
  var topCardBottomAnchorConstraint: NSLayoutConstraint!
  var topCardHeightConstraint: NSLayoutConstraint!
  
  var topCardTurn: Bool = true
  
  init(viewModel: CardContainerViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
  }
  
  private func setupElements() {
    backgroundColor = .clear
    topCardView = CardView(with: viewModel.topCardViewModel)
    bottomCardView = CardView(with: viewModel.bottomCardViewModel)
    self.addSubview(bottomCardView)
    self.addSubview(topCardView)
    
    bottomCardView.translatesAutoresizingMaskIntoConstraints = false
    topCardView.translatesAutoresizingMaskIntoConstraints = false
    
    bottomCardTopAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: CardContainerConstants.topAnchorCardOffset)
    bottomCardBottomAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: CardContainerConstants.bottomCardOffset)
    bottomCardLeadingAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: CardContainerConstants.horizontalCardOffset)
    bottomCardTrailingAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -CardContainerConstants.horizontalCardOffset)
    bottomCardHeightConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CardContainerConstants.minimizedCardHeight)
    
    topCardTopAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    topCardBottomAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
    topCardLeadingAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    topCardTrailingAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    topCardHeightConstraint = NSLayoutConstraint(item: topCardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CardContainerConstants.maximizedCardHeight)
    
 
    
    NSLayoutConstraint.activate([
      bottomCardTopAnchorConstraint,
      bottomCardBottomAnchorConstraint,
      bottomCardLeadingAnchorConstraint,
      bottomCardTrailingAnchorConstraint,
      bottomCardHeightConstraint,
      
      topCardTopAnchorConstraint,
      topCardLeadingAnchorConstraint,
      topCardTrailingAnchorConstraint,
      topCardBottomAnchorConstraint,
      topCardHeightConstraint
    ])
    
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
    updateCardConstraints()
    swapViews()
    updateCurrentBottomCard()
  }
  
  func updateCurrentBottomCard() {
    if let cardViewModel = viewModel.nextCard() {
      if topCardTurn {
        topCardView.updateCard(with: cardViewModel)
      }
      else {
        bottomCardView.updateCard(with: cardViewModel)
      }
    } else {
      // alert on cardContainer that users are ended
    }
  }
  
  func updateCardConstraints() {
    bottomCardBottomAnchorConstraint.isActive = false
    topCardBottomAnchorConstraint.isActive = false
    if topCardTurn {
      bottomCardHeightConstraint.constant = CardContainerConstants.maximizedCardHeight
      bottomCardTopAnchorConstraint.constant = 0
      bottomCardLeadingAnchorConstraint.constant = 0
      bottomCardTrailingAnchorConstraint.constant = 0
      
      topCardHeightConstraint.constant = CardContainerConstants.minimizedCardHeight
      topCardLeadingAnchorConstraint.constant = CardContainerConstants.horizontalCardOffset
      topCardTrailingAnchorConstraint.constant = -CardContainerConstants.horizontalCardOffset
      topCardTopAnchorConstraint.constant = CardContainerConstants.topAnchorCardOffset
      
    } else {
      topCardHeightConstraint.constant = CardContainerConstants.maximizedCardHeight
      topCardTopAnchorConstraint.constant = 0
      topCardLeadingAnchorConstraint.constant = 0
      topCardTrailingAnchorConstraint.constant = 0
      
      bottomCardHeightConstraint.constant = CardContainerConstants.minimizedCardHeight
      bottomCardTopAnchorConstraint.constant = CardContainerConstants.topAnchorCardOffset
      bottomCardLeadingAnchorConstraint.constant = CardContainerConstants.horizontalCardOffset
      bottomCardTrailingAnchorConstraint.constant = -CardContainerConstants.horizontalCardOffset
    }

    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
      self.layoutIfNeeded()
    }
  }
  
  func swapViews() {
    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.cardDisappearTime) {
      if self.topCardTurn {
        self.topCardView.isUserInteractionEnabled = false
        self.bottomCardView.isUserInteractionEnabled = true
        self.topCardView.layer.zPosition = 0
        self.bottomCardView.layer.zPosition = 1
        UIView.animate(withDuration: 0.1) {
          self.topCardView.alpha = 1
        }
      } else {
        self.bottomCardView.isUserInteractionEnabled = false
        self.topCardView.isUserInteractionEnabled = true
        self.bottomCardView.alpha = 0
        self.topCardView.layer.zPosition = 1
        UIView.animate(withDuration: 0.2) {
          self.bottomCardView.alpha = 1
        }
      }
      self.topCardTurn.toggle()
    }
  }
}
