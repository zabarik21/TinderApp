//
//  CardContainerView + ReactionView ObserversHandling.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit


extension CardContainerView  {
  
  func reacted(liked: Bool) {
    if topCardTurn {
      guard topCardView.isSwipeble != false else { return }
      topCardView.swipe(liked: liked, fromButton: true)
    } else {
      guard bottomCardView.isSwipeble != false else { return }
      bottomCardView.swipe(liked: liked, fromButton: true)
    }
  }
}
