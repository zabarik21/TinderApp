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

  var usersApi = RandomUserApi()

  private let bag = DisposeBag()
  
  var viewModels = [UserCardViewViewModelProtocol]()
  var users = [String: UserCardModel]()
  var liked = Set<String>()
  
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
  
  var topCardViewModel: UserCardViewViewModelProtocol?
  
  private var userIndex = 0
  
  init(user: UserCardModel) {
    self.user = user
    guard !DemoModeService.isDemoMode else {
      self.fetchViewModels()
      return
    }
    getUsersFromFirestore()
    getLikesFromFirestore()
    topCardViewModelRelay
      .subscribe(onNext: { [weak self] cardViewModel in
        self?.topCardViewModel = cardViewModel
      })
      .disposed(by: bag)
  }
  
  deinit {
    usersListener?.remove()
  }
  
  func topCardUser() -> UserCardModel? {
    guard let id = topCardViewModel?.id else { return nil }
    print(id)
    return users[id]
  }
  
  func nextCard() -> UserCardViewViewModelProtocol? {
    if DemoModeService.isDemoMode {
      if viewModels.count < 5 {
        fetchViewModels()
      }
    }
    return viewModels.shift()
  }
  
  func updateViewModels() {
    viewModels = users.map { UserCardViewViewModel(
      with: $0.value,
      myInterests: self.user.interests)
    }
    self.userLoadPublisher.onNext(true)
  }
  
  func updateMatchViewRelay(with viewModel: UserCardViewViewModelProtocol) {
    let matchViewModel = MatchViewViewModel(
      userName: self.user.name.first,
      userImageUrlString: self.user.picture.thumbnail,
      friendName: viewModel.name,
      friendImageUrlString: viewModel.imageUrlString,
      compatabilityScore: viewModel.compatabilityScore)
    matchRelay.accept(matchViewModel)
  }
  
  func isLikeMutually() -> Bool {
    guard let id = topCardViewModel?.id else { return false }
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
          case .success(let newUsers):
            self.users = newUsers
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
