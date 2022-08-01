//
//  CardContainerView + Cards swiping manipulation.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import UIKit
import RxSwift

extension CardContainerView {
  
  func swiped(liked: Bool) {
    // send request for like/dislike if user in not demo mode
    if !DemoModeService.isDemoMode {
      if let targetUser = viewModel.getDisplayedUser() {
        if liked {
          likeUser(targetUser)
        } 
        checkUser(targetUser)
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
    let cardViewModel = viewModel.nextCard()
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      guard let self = self else { return }
      if self.topCardTurn {
        self.viewModel.topCardViewModelRelay
          .accept(self.topCardView.viewModelRelay.value)
      } else {
        self.viewModel.topCardViewModelRelay
          .accept(self.bottomCardView.viewModelRelay.value)
      }
    }
  }
  
  private func demoLikeReaction() {
    if Int.random(in: 0...3) == 2 {
      guard let topCardViewModel = viewModel.topCardViewModelRelay.value else { return }
      self.viewModel.updateMatchRelay(with: topCardViewModel)
      
    }
  }
  
  private func likeUser(_ targetUser: UserCardModel) {
    if viewModel.isMutually() {
      DispatchQueue.global(qos: .userInitiated).async {
        FirestoreService.shared.changeChatToActive(
          friendId: targetUser.id.value!) { result in
            switch result {
            case .failure(let error):
              print(error)
            case .success:
              print("active chat created succesfully")
              AlertService.shared.alertPublisher.accept((
                "You can chat now",
                "(Not added yet)"
              ))
            }
          }
      }
      self.viewModel.updateMatchRelay(with: UserCardViewViewModel(with: targetUser, myInterests: self.viewModel.user.interests))
    } else {
      DispatchQueue.global(qos: .userInitiated).async {
        FirestoreService.shared.addLikeInfoToUser(likedUser: targetUser)
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
    }
  }
  
  private func checkUser(_ targetUser: UserCardModel) {
    FirestoreService.shared.addToCheckedUsers(user: targetUser) { result in
      switch result {
      case .success:
        print("User moved to disliked")
      case .failure(let error):
        print(error)
      }
    }
  }
}
