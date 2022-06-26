//
//  Interests.swift
//  TinderApp
//
//  Created by Timofey on 25/6/22.
//

import Foundation

enum Interest: Codable, CaseIterable {
  case shopping
  case netflix
  case gaming
  case sport
  case drinking
  case learning
  case books
  
  static func getRandomCases() -> Set<Interest> {
    let allCases = Interest.allCases
    let n = Int.random(in: 0...3)
    var res = Set<Interest>()
    for _ in 0...n {
      let rand = Int.random(in: 0...(allCases.count - 1))
      res.insert(allCases[rand])
    }
    return res
  }
}
