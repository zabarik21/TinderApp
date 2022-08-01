//
//  StorageService.swift
//  TinderApp
//
//  Created by Timofey on 16/7/22.
//

import Foundation
import Accelerate
import UIKit


class StorageService {
  
  private let userKey = "USER"
  private let demoKey = "DEMO"
  private let standart = UserDefaults.standard
  
  static var shared = StorageService()
  
  private init() {}
  
  func saveUser(user: UserCardModel) {
    let data = user.jsonRepresent()
    standart.set(data, forKey: userKey)
  }
  
  func demoMode() -> Bool {
    return standart.bool(forKey: demoKey)
  }
  
  func setDemoMode(_ bool: Bool) {
    if bool {
      standart.set(bool, forKey: demoKey)
    }
  }
  
  func loadUser() -> UserCardModel? {
    var user: UserCardModel?
    do {
      if let savedUserData = UserDefaults.standard.data(forKey: userKey) {
        user = try JSONDecoder().decode(UserCardModel.self, from: savedUserData)
      }
    } catch (let decodeError) {
      print(decodeError)
    }
    return user
  }
 
  func resetData() {
    standart.removeObject(forKey: userKey)
    standart.removeObject(forKey: demoKey)
  }
}
