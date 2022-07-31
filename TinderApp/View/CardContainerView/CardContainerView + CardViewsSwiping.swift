//
//  CardContainerView + Cards swiping manipulation.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit

extension CardContainerView {
  
  func swiped(liked: Bool) {
    // send request for like/dislike if user in not demo mode
    if !DemoModeService.isDemoMode {
      if let targetUser = viewModel?.getDisplayedUser() {
        if liked {
          likeUser(targetUser)
        } else {
          dislikeUser(targetUser)
        }
      }
    } else {
      if liked {
        demoLikeReaction()
      }
    }
    
    
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
      self.updateViewModelTopCard()
    }
  }
  
  private func updateViewModelTopCard() {
    if topCardTurn {
      viewModel?.topCardViewModelRelay.accept(topCardView.viewModelRelay.value)
    } else {
      viewModel?.topCardViewModelRelay.accept(bottomCardView.viewModelRelay.value)
    }
  }
  
  private func demoLikeReaction() {
    if Int.random(in: 0...3) == 2 {
      guard let viewModel = viewModel,
            let topCardViewModel = viewModel.topCardViewModelRelay.value else { return }
      self.viewModel?.matchRelay.accept(MatchViewViewModel(
        userName: viewModel.user.name.first,
        userImageUrlString: viewModel.user.picture.thumbnail,
        friendName: topCardViewModel.name,
        friendImageUrlString: topCardViewModel.imageUrlString,
        compatabilityScore: topCardViewModel.compatabilityScore))
    }
  }
  
  private func likeUser(_ targetUser: UserCardModel) {
    FirestoreService.shared.createWaitingChat(reciever: targetUser) { result in
      switch result {
      case .success:
        print("waiting chat created succesfully")
      case .failure(let error):
        AlertService.shared.alertPublisher.accept(
          ("Error",
           "\(error.localizedDescription)")
        )
      }
    }
  }
  
  private func dislikeUser(_ targetUser: UserCardModel) {
    FirestoreService.shared.removeUser(user: targetUser) { result in
      switch result {
      case .success:
        print("User moved to disliked")
      case .failure(let error):
        print(error)
      }
    }
  }
}
