//
//  CardContainerViewViewModelProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/6/22.
//

import Foundation
import RxSwift

protocol CardContainerViewViewModelProtocol {
  var viewModels: [UserCardViewViewModelProtocol] { get set }
  var userLoadObservable: Observable<Bool> { get }
  func nextCard() -> UserCardViewViewModelProtocol?
  func getCurrentUser() -> UserCardModel?
}
