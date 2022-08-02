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
    if !DemoModeService.isDemoMode {
      if let targetUser = self.topCardUser {
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
      self.viewModel.updateMatchViewRelay(with: topCardViewModel)
    }
  }
  
  private func likeUser(_ targetUser: UserCardModel) {
    if viewModel.isLikeMutually() {
      DispatchQueue.global(qos: .userInitiated).async {
        FirestoreService.shared.createChat(
          friend: targetUser) { result in
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
      self.viewModel.updateMatchViewRelay(with: UserCardViewViewModel(with: targetUser, myInterests: self.viewModel.user.interests))
    } else {
      DispatchQueue.global(qos: .userInitiated).async {
        FirestoreService.shared.addLikeInfoToUser(likedUser: targetUser)
      }
    }
  }
  
  private func checkUser(_ targetUser: UserCardModel) {
    FirestoreService.shared.addToChecked(user: targetUser) { result in
      switch result {
      case .success:
        print("User with id \(targetUser.id.value!) checked")
      case .failure(let error):
        print(error)
      }
    }
  }
}
