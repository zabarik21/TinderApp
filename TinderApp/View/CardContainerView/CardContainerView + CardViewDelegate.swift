//
//  CardContainerView + CardViewDelegate.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit

extension CardContainerView: CardViewDeleagate {
  
  func swiped(liked: Bool) {
//    updateCardConstraints()
    swapViews()
    updateCurrentBottomCard()
  }
  
  func fillCards() {
    topCardView.viewModel = viewModel?.nextCard()
    bottomCardView.viewModel = viewModel?.nextCard()
  }
  
  func updateCurrentBottomCard() {
    let cardViewModel = viewModel?.nextCard()
    if topCardTurn {
      topCardView.viewModel = cardViewModel
    }
    else {
      bottomCardView.viewModel = cardViewModel
    }
  }
  
  func updateCardConstraints() {
      
      if topCardTurn {
        
        bottomCardView.snp.updateConstraints { make in
          make.width.equalToSuperview()
          make.bottom.equalToSuperview().offset(-5)
        }
        
//        topCardView.snp.remakeConstraints { make in
//          make.width.equalToSuperview().multipliedBy(0.9)
//          make.bottom.equalToSuperview()
//        }
        
      } else {
//        topCardView.snp.remakeConstraints { make in
//          make.width.equalToSuperview().priority(.high)
//          make.bottom.equalToSuperview().priority(.high)
//        }
//        bottomCardView.snp.remakeConstraints { make in
//          make.width.equalToSuperview().multipliedBy(0.9)
//          make.bottom.equalToSuperview().offset(5)
//        }
      }

//      UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
//        self.layoutIfNeeded()
//      }
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
