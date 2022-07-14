//
//  ContainerViewViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation
import RxSwift

class CardContainerViewViewModel: CardContainerViewViewModelProtocol {
    
  var users: [UserCardViewViewModelProtocol]
  var usersApi = RandomUserApi()
  
  // remake by adding user global property or some else
  var user: UserCardModel
  
  private var userLoadPublisher = PublishSubject<Bool>()
  
  var userLoadObservable: Observable<Bool> {
    return userLoadPublisher.asObservable()
  }
  
  func nextCard() -> UserCardViewViewModelProtocol? {
    if users.count < 5 {
      fetchViewModels()
    }
    return users.shift()
  }
  
  // init with users for случая when there are old saved users left in memory 
  init(users: [UserCardViewViewModel], user: UserCardModel) {
    self.users = users
    self.user = user
    self.fetchViewModels()
  }
  
  func fetchViewModels() {
    usersApi.fetchPeopleWithParametrs(count: 10) { result in
      switch result {
      case .success(let downloadedUsers):
        for user in downloadedUsers {
          var userWithInterest = user
          userWithInterest.interests = Interest.getRandomCases()
          let viewModel = UserCardViewViewModel(with: userWithInterest, myInterests: self.user.interests)
          self.users.append(viewModel)
        }
        self.userLoadPublisher.onNext(true)
      case .failure(let error):
        DispatchQueue.main.async { [weak self] in
          self?.userLoadPublisher.onNext(false)
          print(error)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
          self.fetchViewModels()
        })
      }
    }
  }
}
