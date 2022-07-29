//
//  BirthDate.swift
//  TinderApp
//
//  Created by Timofey on 29/7/22.
//

import Foundation


struct BirthDate: Codable {
  var date: String
  var age: Int
  
  enum CodingKeys: String, CaseIterable, CodingKey {
    case date
    case age
  }
}
