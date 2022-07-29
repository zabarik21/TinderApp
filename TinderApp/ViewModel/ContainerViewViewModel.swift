//
//  ContainerViewViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation
import RxSwift
import FirebaseFirestore

class CardContainerViewViewModel: CardContainerViewViewModelProtocol {
    
  var viewModels: [UserCardViewViewModelProtocol]
  var users = [UserCardModel]()
  var usersApi = RandomUserApi()
  
  // remake by adding user global property or some else
  var user: UserCardModel
  
  private var userLoadPublisher = PublishSubject<Bool>()
  
  private var usersListener: ListenerRegistration?
  
  var userLoadObservable: Observable<Bool> {
    return userLoadPublisher.asObservable()
  }
  
  func nextCard() -> UserCardViewViewModelProtocol? {
    if DemoModeService.isDemoMode {
      if viewModels.count < 5 {
        fetchViewModels()
      }
    }
    return viewModels.shift()
  }
  
  // init with users for случая when there are old saved users left in memory 
  init(users: [UserCardViewViewModel], user: UserCardModel) {
    self.viewModels = users
    self.user = user
    guard !DemoModeService.isDemoMode else {
      self.fetchViewModels()
      return
    }
    getUsersFromFirestore()
  }
  
  deinit {
    usersListener?.remove()
  }
  
  func getUsersFromFirestore() {
    usersListener = ListenerService.shared.observeUsers(
      users: self.users,
      completion: { result in
        switch result {
        case .success(let users):
          self.users = users
          self.updateViewModels()
        case .failure(let error):
          print(error)
        }
      })
  }
  
  func updateViewModels() {
    viewModels = users.map { UserCardViewViewModel(with: $0, myInterests: self.user.interests) }
    self.userLoadPublisher.onNext(true)
  }
  
  func fetchViewModels() {
    usersApi.fetchPeopleWithParametrs(count: 10) { result in
      switch result {
      case .success(let downloadedUsers):
        for user in downloadedUsers {
          var userWithInterest = user
          userWithInterest.interests = Interest.getRandomCases()
          let viewModel = UserCardViewViewModel(with: userWithInterest, myInterests: self.user.interests)
          self.viewModels.append(viewModel)
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
