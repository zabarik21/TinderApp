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
}
