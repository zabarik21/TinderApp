//
//  UserCardModel.swift
//  TinderApp
//
//  Created by Timofey on 31/5/22.
//

import Foundation


struct UserCardModel: Encodable {
  var name: String
  var age: Int
  var city: String
  var imageUrlString: String
  

  // test init
  init () {
    self.age = Int.random(in: 0...94)
    self.city = ["Perm", "Ziben", "Moskow"].randomElement()!
    self.name = ["Seva", "Niben", "Bebra"].randomElement()!
    self.imageUrlString = "sdfasd"
  }
}
