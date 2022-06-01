//
//  CardContainerViewViewModelProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/6/22.
//

import Foundation


protocol CardContainerViewViewModelProtocol {
  var users: [UserCardViewViewModel] { get set }
  var topCardViewModel: UserCardViewViewModelProtocol! { get set }
  var bottomCardViewModel: UserCardViewViewModelProtocol! { get set }
  var delegate: CardContainerDelagate? { get set }
  
  func nextCard() -> UserCardViewViewModelProtocol?
}
