//
//  CardContainerViewViewModelProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/6/22.
//

import Foundation
import RxSwift
import RxRelay

protocol CardContainerViewViewModelProtocol {
  var user: UserCardModel { get set }
  var viewModels: [UserCardViewViewModelProtocol] { get set }
  var topCardViewModelRelay: BehaviorRelay<UserCardViewViewModelProtocol?> { get set }
  var matchRelay: PublishRelay<MatchViewViewModel?> { get }
  var userLoadObservable: Observable<Bool> { get }
  func nextCard() -> UserCardViewViewModelProtocol?
  func getDisplayedUser() -> UserCardModel?
}
