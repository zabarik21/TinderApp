//
//  UserCardViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation


struct UserCardViewViewModel: UserCardViewViewModelProtocol {
  
  var compatabilityScore: Int
  var name: String
  var age: Int
  var city: String
  var imageUrlString: String
  var interests: Set<Interest>
  
  init(with userCardModel: UserCardModel) {
    self.age = userCardModel.birthDate.age
    self.city = userCardModel.location.city
    self.name = userCardModel.name.first
    self.imageUrlString = userCardModel.picture.large
    self.compatabilityScore = Int.random(in: 0...10)
    self.interests = Interest.getRandomCases()
  }
  
  // init for tests
  init() {
    self.age = Int.random(in: 0...94)
    self.city = ["Perm", "Ziben", "Moskow"].randomElement()!
    self.name = ["Seva", "Niben", "Bebra"].randomElement()!
    self.imageUrlString = "sdfasd"
    self.compatabilityScore = Int.random(in: 0...10)
    self.interests = Interest.getRandomCases()
  }
}


extension UserCardViewViewModel {
  func nameAgeLabelText() -> String {
    return "\(name), \(age)"
  }
  func cityDistanceLabelText() -> String {
    let randomDistance = Int.random(in: 0...50)
    return "\(city) •\(randomDistance) km"
  }
}
