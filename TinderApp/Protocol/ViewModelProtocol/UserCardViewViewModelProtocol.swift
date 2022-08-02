//
//  UserCardViewViewModelProtocol.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation

protocol UserCardViewViewModelProtocol {
  var name: String { get }
  var age: Int { get }
  var city: String { get }
  var id: String { get }
  var imageUrlString: String { get }
  var compatabilityScore: Int { get }
  var interests: Set<Interest> { get }
  var similarInterestsCount: Int { get }
  var userInfoViewViewModel: UsersInfoViewViewModelProtocol { get }
  
  func nameAgeLabelText() -> String
  func cityDistanceLabelText() -> String
}
