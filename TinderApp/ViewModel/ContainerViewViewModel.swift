//
//  ContainerViewViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation




class CardContainerViewViewModel: CardContainerViewViewModelProtocol {
  
  var users: [UserCardViewViewModel]
  
  var topCardViewModel: UserCardViewViewModelProtocol!
  
  var bottomCardViewModel: UserCardViewViewModelProtocol!
  
  var delegate: CardContainerDelagate?
  
  func nextCard() -> UserCardViewViewModelProtocol? {
    return users.shift()
  }
  
  init(users: [UserCardViewViewModel]) {
    self.users = users
    if let bottomCard = self.users.shift() {
      self.bottomCardViewModel = bottomCard
      if let topCard = self.users.shift() {
        self.topCardViewModel = topCard
      }
    }
  }
  
  func swapTopViewModel(with viewModel: UserCardViewViewModelProtocol) {
    topCardViewModel = bottomCardViewModel
    bottomCardViewModel = viewModel
  }
}
