//
//  ContainerViewViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation
import RxSwift
import FirebaseFirestore
import RxRelay

class CardContainerViewViewModel: CardContainerViewViewModelProtocol {

  private let bag = DisposeBag()
  
  var viewModels = [UserCardViewViewModelProtocol]()
  var users = [UserCardModel]()
  var liked = Set<String>()
  var usersApi = RandomUserApi()
  
  var user: UserCardModel
  
  private var userLoadPublisher = PublishSubject<Bool>()
  var matchRelay = PublishRelay<MatchViewViewModel?>()
  
  private var usersListener: ListenerRegistration?
  private var likesListener: ListenerRegistration?
  
  public var matchObservable: Observable<MatchViewViewModel?> {
    return matchRelay.asObservable()
  }
  
  var userLoadObservable: Observable<Bool> {
    return userLoadPublisher.asObservable()
  }
  
  var topCardViewModelRelay = BehaviorRelay<UserCardViewViewModelProtocol?>(value: nil)
  
  private var userIndex = 0
  
  var displayedUserModel: UserCardModel?
  
  init(user: UserCardModel) {
    self.user = user
    guard !DemoModeService.isDemoMode else {
      self.fetchViewModels()
      return
    }
    getUsersFromFirestore()
    getLikesFromFirestore()
    topCardViewModelRelay
      .subscribe()
      .disposed(by: bag)
  }
  
  deinit {
    usersListener?.remove()
  }
  
  func getDisplayedUser() -> UserCardModel? {
    if viewModels.count == 0 { return users.last! }
    guard (userIndex - 2) < users.count else { return nil }
    return users[userIndex - 2]
  }
  
  func nextCard() -> UserCardViewViewModelProtocol? {
    if DemoModeService.isDemoMode {
      if viewModels.count < 5 {
        fetchViewModels()
      }
    }
    userIndex += 1
    return viewModels.shift()
  }
  
  func updateViewModels() {
    viewModels = users.map { UserCardViewViewModel(
      with: $0,
      myInterests: self.user.interests)
    }
    self.userLoadPublisher.onNext(true)
  }
  
  func updateMatchRelay(with viewModel: UserCardViewViewModelProtocol) {
    let matchViewModel = MatchViewViewModel(
      userName: self.user.name.first,
      userImageUrlString: self.user.picture.thumbnail,
      friendName: viewModel.name,
      friendImageUrlString: viewModel.imageUrlString,
      compatabilityScore: viewModel.compatabilityScore)
    matchRelay.accept(matchViewModel)
  }
  
  func isMutually() -> Bool {
    guard let id = getDisplayedUser()?.id.value else { return false }
    return liked.contains(id)
  }
}

// MARK: - Firestore Listeners
extension CardContainerViewViewModel {
  
  func getLikesFromFirestore() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      self.likesListener = ListenerService.shared.observeLikedUsers(
        liked: self.liked,
        completion: { result in
          switch result {
          case .success(let likedUsers):
            self.liked = likedUsers
          case .failure(let error):
            print(error)
          }
      })
    }
  }
  
  func getUsersFromFirestore() {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self = self else { return }
      self.usersListener = ListenerService.shared.observeUsers(
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
  }
}

// fetch users for demo mode
extension CardContainerViewViewModel {
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
