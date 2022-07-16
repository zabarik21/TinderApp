//
//  StorageService.swift
//  TinderApp
//
//  Created by Timofey on 16/7/22.
//

import Foundation
import Accelerate


class StorageService {
  
  private let userKey = "USER"
  private let standart = UserDefaults.standard
  
  static var shared: StorageService {
    return StorageService()
  }
  
  private init() {}
  
  func saveUser(user: UserCardModel) {
    let data = user.jsonRepresent()
    standart.set(data, forKey: userKey)
  }
  
  func loadUser() -> UserCardModel? {
    var user: UserCardModel?
    do {
      if let savedUserData = UserDefaults.standard.data(forKey: userKey) {
        user = try JSONDecoder().decode(UserCardModel.self, from: savedUserData)
      }
    } catch(let decodeError) {
      print(decodeError)
    }
    return user
  }
  
  func resetData() {
    standart.removeObject(forKey: userKey)
  }
}
