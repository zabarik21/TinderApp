//
//  UserCardViewModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation


struct UserCardViewViewModel: UserCardViewViewModelProtocol {
  var name: String
  
  var age: Int
  
  var city: String
  
  var imageUrlString: String
  
  init(with userCardModel: UserCardModel) {
    self.age = userCardModel.age
    self.city = userCardModel.city
    self.name = userCardModel.name
    self.imageUrlString = userCardModel.imageUrlString
  }
  
  // init for tests
  init() {
    self.age = Int.random(in: 0...94)
    self.city = ["Perm", "Ziben", "Moskow"].randomElement()!
    self.name = ["Seva", "Niben", "Bebra"].randomElement()!
    self.imageUrlString = "sdfasd"
  }
}


extension UserCardViewViewModel {
  func nameAgeLabelText() -> String {
    return "\(name), \(age) 􀇻"
  }
  func cityDistanceLabelText() -> String {
    var randomDistance = Int.random(in: 0...50)
    return "\(city) •\(randomDistance) km"
  }
}
