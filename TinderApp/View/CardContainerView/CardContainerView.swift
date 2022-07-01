//
//  CardViewContainer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit
import SnapKit

enum CardContainerConstants {
  static var topAnchorCardOffset: CGFloat = 5
  static var cardAppearTime: CGFloat = 0.25
  static let horizontalCardOffset: CGFloat = 0.032
  static let bottomCardOffset: CGFloat = 11
  static var minimizedCardHeightDelta: CGFloat = 0
  static var maximizedCardHeightDelta: CGFloat = -4
}

class CardContainerView: UIView {
  
  var viewModel: CardContainerViewViewModelProtocol?
  weak var delegate: CardContainerDelagate?
  
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
  
  init() {
    super.init(frame: .zero)
    setupElements()
  }
  
  
  private func setupElements() {
    backgroundColor = .clear
    topCardView = CardView(with: viewModel?.nextCard())
    bottomCardView = CardView(with: viewModel?.nextCard())
    setupConstraints()
    
    topCardView.delegate = self
    bottomCardView.delegate = self
  }
  
  private func setupConstraints() {
    
    addSubview(bottomCardView)
    addSubview(topCardView)
    
    bottomCardView.translatesAutoresizingMaskIntoConstraints = false
    topCardView.translatesAutoresizingMaskIntoConstraints = false
    
    bottomCardTopAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: CardContainerConstants.topAnchorCardOffset)
    bottomCardBottomAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: CardContainerConstants.bottomCardOffset)
    bottomCardLeadingAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: CardContainerConstants.horizontalCardOffset)
    bottomCardTrailingAnchorConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -CardContainerConstants.horizontalCardOffset)
    bottomCardHeightConstraint = NSLayoutConstraint(item: bottomCardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.bounds.height * CardContainerConstants.minimizedCardHeightDelta)
    
    topCardTopAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    topCardBottomAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
    topCardLeadingAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
    topCardTrailingAnchorConstraint = NSLayoutConstraint(item: topCardView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    topCardHeightConstraint = NSLayoutConstraint(item: topCardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.bounds.height * CardContainerConstants.maximizedCardHeightDelta)
    
    
    
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
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(#function)
    // fix unwrap
    if topCardTurn {
      delegate?.cardTouched(with: topCardView.viewModel)
    }
    else {
      delegate?.cardTouched(with: bottomCardView.viewModel)
    }
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
    if let cardViewModel = viewModel?.nextCard() {
      if topCardTurn {
        topCardView.viewModel = cardViewModel
      }
      else {
        bottomCardView.viewModel = cardViewModel
      }
    } else {
      // alert on cardContainer that users are ended
    }
  }
  
  func updateCardConstraints() {
    bottomCardBottomAnchorConstraint.isActive = false
    topCardBottomAnchorConstraint.isActive = false
    if topCardTurn {
      bottomCardHeightConstraint.constant = self.bounds.height + CardContainerConstants.maximizedCardHeightDelta
      bottomCardTopAnchorConstraint.constant = 0
      bottomCardLeadingAnchorConstraint.constant = 0
      bottomCardTrailingAnchorConstraint.constant = 0
      
      topCardHeightConstraint.constant = self.bounds.height + CardContainerConstants.minimizedCardHeightDelta
      topCardLeadingAnchorConstraint.constant = CardContainerConstants.horizontalCardOffset
      topCardTrailingAnchorConstraint.constant = -CardContainerConstants.horizontalCardOffset
      topCardTopAnchorConstraint.constant = CardContainerConstants.topAnchorCardOffset
      
    } else {
      topCardHeightConstraint.constant = self.bounds.height + CardContainerConstants.maximizedCardHeightDelta
      topCardTopAnchorConstraint.constant = 0
      topCardLeadingAnchorConstraint.constant = 0
      topCardTrailingAnchorConstraint.constant = 0
      
      bottomCardHeightConstraint.constant = self.bounds.height + CardContainerConstants.minimizedCardHeightDelta
      bottomCardTopAnchorConstraint.constant = CardContainerConstants.topAnchorCardOffset
      bottomCardLeadingAnchorConstraint.constant = CardContainerConstants.horizontalCardOffset
      bottomCardTrailingAnchorConstraint.constant = -CardContainerConstants.horizontalCardOffset
    }

    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
      self.layoutIfNeeded()
    }
  }
  
  func swapViews() {
    DispatchQueue.main.async {
      let currentTopCard = self.topCardTurn ? self.bottomCardView! : self.topCardView!
      let currentBottomCard = self.topCardTurn ? self.topCardView! : self.bottomCardView!
      currentBottomCard.isUserInteractionEnabled = false
      currentTopCard.isUserInteractionEnabled = true
      currentTopCard.layer.zPosition = 1
      currentBottomCard.layer.zPosition = 0
      UIView.animate(withDuration: CardContainerConstants.cardAppearTime) {
        currentBottomCard.alpha = 1
      }
      self.topCardTurn.toggle()
    }
  }
}


extension CardContainerView: ReactionViewDelegate {
  
  func reacted(liked: Bool) {
    if topCardTurn {
      guard topCardView.isSwipeble != false else { return }
      topCardView.swipe(liked: liked, fromButton: true)
      // send reaction request
    } else {
      guard bottomCardView.isSwipeble != false else { return }
      bottomCardView.swipe(liked: liked, fromButton: true)
      // send reaction request
    }
  }
  
}
