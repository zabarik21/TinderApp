//
//  UserCardViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation
import CoreLocation


struct UserCardViewViewModel: UserCardViewViewModelProtocol {
  
  var similarInterestsCount: Int
  var compatabilityScore: Int
  var id: String
  var name: String
  var age: Int
  var city: String
  var imageUrlString: String
  var distance: Int
  var interests: Set<Interest>
  
  var userInfoViewViewModel: UsersInfoViewViewModelProtocol {
    return UsersInfoViewViewModel(
      nameAgeText: self.nameAgeLabelText(),
      cityText: self.cityDistanceLabelText(),
      compatabilityScore: self.compatabilityScore)
  }
  
  
  init(with userCardModel: UserCardModel, myInterests: Set<Interest>?) {
    if let myInterests = myInterests, !myInterests.isEmpty {
      let similarInterests = userCardModel.interests!.reduce(0, { partialResult, interest in
        partialResult + (myInterests.contains(interest) ? 1 : 0)
      })
      let compatablityScore = Double(similarInterests) / Double(myInterests.count) * 10
      self.compatabilityScore = Int(compatablityScore)
      self.similarInterestsCount = similarInterests
    } else {
      self.id = userCardModel.id.value ?? ""
      self.compatabilityScore = 0
      self.similarInterestsCount = 0
    }
    
    self.interests = userCardModel.interests!
    self.age = userCardModel.birthDate.age
    self.city = userCardModel.location.city
    self.name = userCardModel.name.first
    self.imageUrlString = userCardModel.picture.large
    self.distance = Int.random(in: 0...50)
    self.id = userCardModel.id.value!
  }
  
  // init for tests
  init() {
    self.age = Int.random(in: 0...94)
    self.city = ["Perm", "Ziben", "Moskow"].randomElement()!
    self.name = ["Seva", "Niben", "Bebra"].randomElement()!
    self.imageUrlString = "https://ru.citaty.net/media/authors/steve-jobs.jpeg"
    
    self.compatabilityScore = Int.random(in: 0...10)
    self.interests = Interest.getRandomCases()
    self.similarInterestsCount = 0
    self.distance = Int.random(in: 0...50)
    self.id = UUID().uuidString
  }
  
  func calculateDistance() {
    
  }
}


extension UserCardViewViewModel {
  
  func nameAgeLabelText() -> String {
    return "\(name), \(age)"
  }
  
  func cityDistanceLabelText() -> String {
    return "\(city) •\(distance) km"
  }
}
