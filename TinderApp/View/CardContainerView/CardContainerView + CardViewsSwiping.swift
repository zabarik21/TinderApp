//
//  CardContainerView + Cards swiping manipulation.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit

extension CardContainerView {
  
  func swiped(liked: Bool) {
    // send request for like/dislike
    //    updateCardConstraints()
    swapViews()
    updateCurrentBottomCard()
  }
  
  func updateCurrentBottomCard() {
    let cardViewModel = viewModel?.nextCard()
    if topCardTurn {
      topCardView.viewModelRelay.accept(cardViewModel)
    } else {
      bottomCardView.viewModelRelay.accept(cardViewModel)
    }
  }
  
  func updateCardConstraints() {
    if topCardTurn {
      
    } else {

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
