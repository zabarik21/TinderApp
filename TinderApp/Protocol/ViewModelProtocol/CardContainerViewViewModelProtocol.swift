//
//  CardContainerViewViewModelProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/6/22.
//

import Foundation
import RxSwift

protocol CardContainerViewViewModelProtocol {
  var users: [UserCardViewViewModelProtocol] { get set }
  var delegate: CardContainerViewViewModelDelegate? { get set }
  var userLoadObservable: Observable<Bool> { get }
  func nextCard() -> UserCardViewViewModelProtocol?
}
