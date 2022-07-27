//
//  Interests.swift
//  TinderApp
//
//  Created by Timofey on 25/6/22.
//

import Foundation

enum Interest: String, Codable, CaseIterable {
  case shopping
  case netflix
  case gaming
  case sport
  case drinking
  case books
  case blogging
  case cooking
  case music
  case drawing
  case dances
  case parkour
  case fishing
  case radio
  case tier
  case animals
  case horse
  case gardening
  case tourism
  case singing
  case photo
  
  static func getRandomCases() -> Set<Interest> {
    let allCases = Interest.allCases
    let count = Int.random(in: 1...(Interest.allCases.count))
    var res = Set<Interest>()
    for _ in 0...count {
      let rand = Int.random(in: 0...(count - 1))
      res.insert(allCases[rand])
    }
    return res
  }
  
  static func getAllCases() -> Set<Interest> {
    let allCases = Interest.allCases
    var res = Set<Interest>()
    for interset in allCases {
      res.insert(interset)
    }
    return res
  }
  
}
